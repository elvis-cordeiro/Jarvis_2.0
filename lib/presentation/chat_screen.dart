import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../core/providers/app_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  bool _isLoadingHistory = true;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _autoSpeak = true;
  bool _apiOnline = false;

  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVoice();
    _loadCloudHistory();
    _checkApiHealth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkApiHealth() async {
    final api = ref.read(apiServiceProvider);
    final healthy = await api.checkHealth();
    if (mounted) {
      setState(() {
        _apiOnline = healthy;
      });
    }
  }

  Future<void> _initVoice() async {
    final voice = ref.read(voiceServiceProvider);
    await voice.init(
      onStatus: (status) {
        if (mounted) {
          setState(() {
            _isListening = voice.isListening;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
  }

  Future<void> _loadCloudHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final api = ref.read(apiServiceProvider);
      final history = await api.getConversationHistory();

      if (mounted) {
        setState(() {
          if (history.isNotEmpty) {
            // A API retorna do mais recente para o mais antigo, invertemos para ordem cronológica
            final reversed = history.reversed.toList();
            for (final item in reversed) {
              if (item['user_message'] != null) {
                _messages.add({
                  'sender': 'user',
                  'text': item['user_message'],
                  'timestamp': item['timestamp'],
                });
              }
              if (item['jarvis_response'] != null) {
                _messages.add({
                  'sender': 'jarvis',
                  'text': item['jarvis_response'],
                  'timestamp': item['timestamp'],
                });
              }
            }
          } else {
            // Primeira inicialização ou histórico limpo
            _messages.add({
              'sender': 'jarvis',
              'text': 'Todos os sistemas operacionais, senhor. Como posso ajudá-lo hoje?',
            });
          }
          _isLoadingHistory = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('[ChatScreen] Erro ao carregar histórico da nuvem: $e');
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'jarvis',
            'text': 'Sistemas iniciados em modo de prontidão, senhor. Banco em processo de sincronização.',
          });
          _isLoadingHistory = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'txt', 'md'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  Future<void> _toggleListening() async {
    final voice = ref.read(voiceServiceProvider);

    if (_isListening) {
      await voice.stopListening();
      setState(() => _isListening = false);
      return;
    }

    if (_isSpeaking) {
      await voice.stop();
      setState(() => _isSpeaking = false);
    }

    setState(() => _isListening = true);

    final started = await voice.startListening(
      onResult: (words, isFinal) {
        if (mounted) {
          setState(() {
            _controller.text = words;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });

          if (isFinal && words.trim().isNotEmpty) {
            setState(() => _isListening = false);
            _sendMessage(words);
          }
        }
      },
      onStatusChange: (status) {
        if (mounted && (status == 'done' || status == 'notListening')) {
          setState(() => _isListening = false);
        }
      },
    );

    if (!started && mounted) {
      setState(() => _isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microfone indisponível ou permissão não concedida no navegador.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _speakMessage(String text) async {
    final voice = ref.read(voiceServiceProvider);
    if (_isSpeaking) {
      await voice.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      await voice.speak(text);
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  Future<void> _sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty && _selectedFile == null) return;

    final file = _selectedFile;
    final text = userMessage.trim();

    // Se estiver falando ou ouvindo, para
    final voice = ref.read(voiceServiceProvider);
    await voice.stopListening();
    await voice.stop();

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text.isEmpty ? '📎 ${file!.name}' : text,
        'fileName': file?.name,
        'fileType': file?.extension,
      });
      _isLoading = true;
      _selectedFile = null;
      _isListening = false;
      _isSpeaking = false;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final geminiService = ref.read(geminiServiceProvider);
      String response;

      if (file != null && file.bytes != null) {
        final ext = file.extension?.toLowerCase();
        final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
        final isPdf = ext == 'pdf';
        final isText = ['txt', 'md'].contains(ext);

        if (isImage) {
          final base64Image = base64Encode(file.bytes!);
          final mimeType = 'image/${ext == 'jpg' ? 'jpeg' : ext}';
          response = await geminiService.sendMessageWithImage(
            text.isEmpty ? 'Analise esta imagem.' : text,
            base64Image,
            mimeType,
          );
        } else if (isText) {
          final textContent = utf8.decode(file.bytes!);
          final prompt = text.isEmpty
              ? 'Analise este arquivo:\n\n$textContent'
              : '$text\n\nConteúdo do arquivo:\n\n$textContent';
          response = await geminiService.sendMessage(prompt);
        } else if (isPdf) {
          final base64Pdf = base64Encode(file.bytes!);
          response = await geminiService.sendMessageWithPdf(
            text.isEmpty ? 'Analise este PDF.' : text,
            base64Pdf,
          );
        } else {
          response = await geminiService.sendMessage(text);
        }
      } else {
        response = await geminiService.sendMessage(text);
      }

      // 1. Salva na Memória de Longo/Curto Prazo
      final saveMemoryUseCase = ref.read(saveImportantMemoryUseCaseProvider);
      await saveMemoryUseCase.call(
        userMessage: text.isEmpty ? '[arquivo: ${file?.name}]' : text,
        jarvisResponse: response,
      );

      // 2. Persiste a conversa localmente (Drift) e na nuvem (API Render / PostgreSQL)
      final memoryRepo = ref.read(memoryRepositoryProvider);
      await memoryRepo.saveConversation(
        userMessage: text.isEmpty ? '📎 ${file?.name}' : text,
        jarvisResponse: response,
      );

      setState(() {
        _messages.add({'sender': 'jarvis', 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();

      // 3. Síntese de Voz (TTS) automática se ativada
      if (_autoSpeak) {
        _speakMessage(response);
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'jarvis',
          'text': 'Falha na comunicação, senhor. Erro: $e',
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111422),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _apiOnline ? const Color(0xFF00FFCC) : Colors.amberAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_apiOnline ? const Color(0xFF00FFCC) : Colors.amberAccent)
                        .withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'JARVIS 2.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.2,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _apiOnline ? 'ONLINE • NUVEM CONECTADA' : 'SINCRONIZANDO COM A NUVEM...',
                  style: TextStyle(
                    color: _apiOnline ? const Color(0xFF00FFCC) : Colors.amberAccent,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Botão de alternar leitura por voz (TTS)
          IconButton(
            tooltip: _autoSpeak ? 'Desativar voz automática' : 'Ativar voz automática',
            icon: Icon(
              _autoSpeak ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _autoSpeak ? const Color(0xFF00FFCC) : Colors.grey[500],
            ),
            onPressed: () {
              setState(() {
                _autoSpeak = !_autoSpeak;
                if (!_autoSpeak && _isSpeaking) {
                  ref.read(voiceServiceProvider).stop();
                  _isSpeaking = false;
                }
              });
            },
          ),
          // Botão recarregar histórico da nuvem
          IconButton(
            tooltip: 'Sincronizar histórico',
            icon: const Icon(Icons.sync_rounded, color: Colors.white70),
            onPressed: () {
              _loadCloudHistory();
              _checkApiHealth();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              children: [
                // Banner de Status de Voz (Arc Reactor Pulse)
                if (_isListening || _isSpeaking)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isListening
                            ? [const Color(0xFF005577), const Color(0xFF00FFCC)]
                            : [const Color(0xFF4A148C), const Color(0xFF7C4DFF)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isListening ? Icons.mic_rounded : Icons.graphic_eq_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isListening
                              ? 'Jarvis está ouvindo você...'
                              : 'Jarvis falando (toque para silenciar)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Lista de Mensagens
                Expanded(
                  child: _isLoadingHistory
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FFCC)),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Conectando ao banco de dados unificado...',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 20 : 14,
                            vertical: 16,
                          ),
                          itemCount: _messages.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoading && index == _messages.length) {
                              return const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: _TypingIndicator(),
                                ),
                              );
                            }

                            final msg = _messages[index];
                            final isUser = msg['sender'] == 'user';
                            final fileName = msg['fileName'] as String?;
                            final fileType = msg['fileType'] as String?;
                            final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp']
                                .contains(fileType?.toLowerCase());

                            return Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: isDesktop ? 620 : screenWidth * 0.82,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isUser
                                      ? const LinearGradient(
                                          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                                        )
                                      : const LinearGradient(
                                          colors: [Color(0xFF141926), Color(0xFF1B2236)],
                                        ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                                    bottomRight: Radius.circular(isUser ? 4 : 16),
                                  ),
                                  border: Border.all(
                                    color: isUser
                                        ? const Color(0xFF8E24AA).withValues(alpha: 0.4)
                                        : const Color(0xFF00FFCC).withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (fileName != null)
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isImage
                                                  ? Icons.image_rounded
                                                  : Icons.insert_drive_file_rounded,
                                              color: const Color(0xFF00FFCC),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                fileName,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (msg['text'] != null &&
                                        (msg['text'] as String).isNotEmpty &&
                                        msg['text'] != '📎 $fileName')
                                      SelectableText(
                                        msg['text']!,
                                        style: TextStyle(
                                          color: isUser ? Colors.white : const Color(0xFFE0E6ED),
                                          fontSize: 15,
                                          height: 1.45,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    if (!isUser && msg['text'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => _speakMessage(msg['text']!),
                                              child: Icon(
                                                Icons.volume_up_rounded,
                                                color: Colors.white.withValues(alpha: 0.4),
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Preview do Arquivo Selecionado
                if (_selectedFile != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2236),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          ['jpg', 'jpeg', 'png', 'gif', 'webp']
                                  .contains(_selectedFile!.extension?.toLowerCase())
                              ? Icons.image_rounded
                              : Icons.insert_drive_file_rounded,
                          color: const Color(0xFF00FFCC),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedFile!.name,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: _clearFile,
                          child: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                        ),
                      ],
                    ),
                  ),

                // Barra Inferior de Entrada (Totalmente Responsiva)
                Container(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 20 : 12,
                    10,
                    isDesktop ? 20 : 12,
                    isDesktop ? 16 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F121C),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFF00FFCC).withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Botão de Anexo
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A2133),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(
                            Icons.attach_file_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Campo de Texto com suporte a Desktop Enter
                      Expanded(
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter &&
                                !HardwareKeyboard.instance.isShiftPressed) {
                              _sendMessage(_controller.text);
                            }
                          },
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            maxLines: 4,
                            minLines: 1,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: _isListening
                                  ? 'Ouvindo sua voz...'
                                  : (_selectedFile != null
                                      ? 'Adicione uma instrução sobre o arquivo...'
                                      : 'Fale ou digite para o Jarvis...'),
                              hintStyle: TextStyle(
                                color: _isListening ? const Color(0xFF00FFCC) : Colors.grey[500],
                                fontStyle: _isListening ? FontStyle.italic : FontStyle.normal,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF151B2B),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: _isListening
                                      ? const Color(0xFF00FFCC)
                                      : Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00FFCC),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botão do Microfone (Voz)
                      GestureDetector(
                        onTap: _toggleListening,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening
                                ? const Color(0xFF00FFCC)
                                : const Color(0xFF1A2133),
                            border: Border.all(
                              color: _isListening
                                  ? const Color(0xFF00FFCC)
                                  : Colors.white24,
                            ),
                            boxShadow: _isListening
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00FFCC).withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                            color: _isListening ? Colors.black : Colors.white70,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botão de Enviar Mensagem
                      GestureDetector(
                        onTap: () => _sendMessage(_controller.text),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FFCC), Color(0xFF0099FF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFCC).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.3)),
      ),
      child: FadeTransition(
        opacity: _animation,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FFCC)),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Jarvis está processando...',
              style: TextStyle(
                color: Color(0xFF00FFCC),
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
