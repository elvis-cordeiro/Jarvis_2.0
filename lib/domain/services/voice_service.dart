import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  bool _sttAvailable = false;
  bool _isSpeaking = false;
  bool _autoSpeakEnabled = true;

  bool get isSttAvailable => _sttAvailable;
  bool get isListening => _stt.isListening;
  bool get isSpeaking => _isSpeaking;
  bool get autoSpeakEnabled => _autoSpeakEnabled;

  void toggleAutoSpeak() {
    _autoSpeakEnabled = !_autoSpeakEnabled;
    if (!_autoSpeakEnabled && _isSpeaking) {
      stop();
    }
  }

  Future<bool> init({
    Function(String status)? onStatus,
    Function(String error)? onError,
  }) async {
    try {
      _sttAvailable = await _stt.initialize(
        onStatus: (status) {
          debugPrint('[VoiceService] STT Status: $status');
          onStatus?.call(status);
        },
        onError: (errorNotification) {
          debugPrint('[VoiceService] STT Error: ${errorNotification.errorMsg}');
          onError?.call(errorNotification.errorMsg);
        },
      );
    } catch (e) {
      debugPrint('[VoiceService] STT init failed: $e');
      _sttAvailable = false;
    }

    try {
      // Configuração TTS em Português Brasileiro (pt-BR)
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(1.10); // Velocidade natural e fluida (era 0.50 — muito lento)
      await _tts.setPitch(0.92);      // Tom levemente mais grave e firme
      await _tts.setVolume(1.0);

      _tts.setStartHandler(() {
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts.setCancelHandler(() {
        _isSpeaking = false;
      });

      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('[VoiceService] TTS Error: $msg');
      });

      // Tenta selecionar voz masculina ou suave em pt-BR se disponível no navegador/sistema
      if (kIsWeb) {
        final voices = await _tts.getVoices;
        if (voices is List) {
          final ptVoices = voices.where((v) {
            final name = v['name']?.toString().toLowerCase() ?? '';
            final locale = v['locale']?.toString().toLowerCase() ?? '';
            return locale.contains('pt') || name.contains('portuguese') || name.contains('brasil');
          }).toList();

          if (ptVoices.isNotEmpty) {
            final preferred = ptVoices.firstWhere(
              (v) {
                final name = v['name']?.toString().toLowerCase() ?? '';
                return name.contains('ricardo') || name.contains('felipe') || name.contains('daniel') || name.contains('male');
              },
              orElse: () => ptVoices.first,
            );
            await _tts.setVoice({
              'name': preferred['name'],
              'locale': preferred['locale'] ?? 'pt-BR',
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[VoiceService] TTS init error: $e');
    }

    return _sttAvailable;
  }

  /// Jarvis sintetiza a resposta por voz
  Future<void> speak(String text) async {
    if (!_autoSpeakEnabled || text.trim().isEmpty) return;

    try {
      await _tts.stop();
      // Remove caracteres especiais de formatação markdown antes de falar
      final cleanedText = _cleanMarkdownForSpeech(text);
      _isSpeaking = true;
      await _tts.speak(cleanedText);
    } catch (e) {
      _isSpeaking = false;
      debugPrint('[VoiceService] Erro ao sintetizar fala: $e');
    }
  }

  /// Para a fala imediatamente
  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (_) {}
  }

  /// Inicia a captura de fala (STT)
  Future<bool> startListening({
    required Function(String words, bool isFinal) onResult,
    Function(String status)? onStatusChange,
  }) async {
    if (!_sttAvailable) {
      final initialized = await init(onStatus: onStatusChange);
      if (!initialized) return false;
    }

    // Se estiver falando, para a voz para não capturar a própria fala
    if (_isSpeaking) {
      await stop();
    }

    try {
      await _stt.listen(
        onResult: (result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        localeId: 'pt_BR',
        listenFor: const Duration(seconds: 40),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.dictation,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('[VoiceService] Erro ao iniciar escuta: $e');
      return false;
    }
  }

  /// Para de escutar
  Future<void> stopListening() async {
    try {
      if (_stt.isListening) {
        await _stt.stop();
      }
    } catch (_) {}
  }

  /// Limpa markdown (asteriscos, blocos de código, links) para pronúncia fluida
  String _cleanMarkdownForSpeech(String markdown) {
    var text = markdown;
    // Remove blocos de código
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), 'bloco de código omitido');
    // Remove código inline
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'$1');
    // Remove links [texto](url)
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');
    // Remove negrito e itálico
    text = text.replaceAll(RegExp(r'[*_~#]'), '');
    // Remove múltiplos espaços ou quebras de linha
    text = text.replaceAll(RegExp(r'\n+'), '. ');
    return text.trim();
  }
}
