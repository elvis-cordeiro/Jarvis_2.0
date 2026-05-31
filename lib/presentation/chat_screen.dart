import 'dart:convert';
import 'package:flutter/material.dart';
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
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  PlatformFile? _selectedFile;
  bool _welcomeSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sendWelcome();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendWelcome() async {
    if (_welcomeSent) return;
    _welcomeSent = true;
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _messages.add({
        'sender': 'jarvis',
        'text': 'Todos os sistemas operacionais, senhor. Como posso ajudá-lo hoje?',
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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

  Future<void> _sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty && _selectedFile == null) return;

    final file = _selectedFile;
    final text = userMessage.trim();

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text.isEmpty ? '📎 ${file!.name}' : text,
        'fileName': file?.name,
        'fileType': file?.extension,
      });
      _isLoading = true;
      _selectedFile = null;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final geminiService = ref.read(geminiServiceProvider);
      String response;

      if (file != null && file.bytes != null) {
        final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp']
            .contains(file.extension?.toLowerCase());
        final isPdf = file.extension?.toLowerCase() == 'pdf';
        final isText = ['txt', 'md'].contains(file.extension?.toLowerCase());

        if (isImage) {
          final base64Image = base64Encode(file.bytes!);
          final mimeType = 'image/${file.extension?.toLowerCase() == 'jpg' ? 'jpeg' : file.extension?.toLowerCase()}';
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

      final saveMemoryUseCase = ref.read(saveImportantMemoryUseCaseProvider);
      await saveMemoryUseCase.call(
        userMessage: text.isEmpty ? '[arquivo: ${file?.name}]' : text,
        jarvisResponse: response,
      );

      setState(() {
        _messages.add({'sender': 'jarvis', 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Jarvis',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple[900],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple : const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isUser ? 18 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 18),
                      ),
                      border: isUser
                          ? null
                          : Border.all(
                              color: Colors.deepPurple.withValues(alpha: 0.4),
                              width: 1,
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (fileName != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isImage ? Icons.image_rounded : Icons.insert_drive_file_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
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
                          Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.grey[200],
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_selectedFile != null)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    ['jpg', 'jpeg', 'png', 'gif', 'webp']
                            .contains(_selectedFile!.extension?.toLowerCase())
                        ? Icons.image_rounded
                        : Icons.insert_drive_file_rounded,
                    color: Colors.deepPurpleAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedFile!.name,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearFile,
                    child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              border: Border(
                top: BorderSide(color: Colors.deepPurple.withValues(alpha: 0.3)),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple.withValues(alpha: 0.3),
                      border: Border.all(
                          color: Colors.deepPurple.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(
                      Icons.attach_file_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _selectedFile != null
                          ? 'Adicione uma mensagem (opcional)...'
                          : 'Fale com Jarvis...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF1A1A2E),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.4)),
      ),
      child: FadeTransition(
        opacity: _animation,
        child: const Text(
          'Jarvis está processando...',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }
}