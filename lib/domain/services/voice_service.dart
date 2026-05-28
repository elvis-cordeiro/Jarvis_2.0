import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  bool _sttAvailable = false;

  Future<void> init() async {
    _sttAvailable = await _stt.initialize();

    // Configurações de voz — mais próximo do Jarvis (britânico, grave, pausado)
    await _tts.setLanguage('en-GB');         // sotaque britânico
    await _tts.setSpeechRate(0.42);          // velocidade pausada e elegante
    await _tts.setPitch(0.85);               // tom levemente mais grave
    await _tts.setVolume(1.0);

    // Tenta usar voz masculina britânica se disponível
    final voices = await _tts.getVoices;
    final jarvisVoice = (voices as List).firstWhere(
      (v) => v['name'].toString().toLowerCase().contains('daniel') ||
             v['name'].toString().toLowerCase().contains('british') ||
             v['name'].toString().toLowerCase().contains('en-gb'),
      orElse: () => null,
    );
    if (jarvisVoice != null) {
      await _tts.setVoice({'name': jarvisVoice['name'], 'locale': 'en-GB'});
    }
  }

  // Jarvis fala
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  // Para de falar
  Future<void> stop() async => await _tts.stop();

  // Começa a ouvir
  Future<void> startListening({required Function(String) onResult}) async {
    if (!_sttAvailable) return;
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'pt_BR',   // reconhece português
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  // Para de ouvir
  Future<void> stopListening() async => await _stt.stop();

  bool get isListening => _stt.isListening;
}