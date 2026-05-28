import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'personality_service.dart';

enum JarvisConnectionStatus { online, offline, degraded }

class GeminiService {
  final PersonalityService personalityService;

  // URL do Cloudflare Worker — lida do .env ou usa padrão
  static String get _workerUrl =>
      dotenv.env['WORKER_URL'] ??
      'https://fragrant-poetry-849c.kingcontents.workers.dev';

  JarvisConnectionStatus _status = JarvisConnectionStatus.online;
  JarvisConnectionStatus get status => _status;

  GeminiService(this.personalityService);

  Future<String> sendMessage(String userMessage) async {
    final hasInternet = await _checkConnectivity();

    if (!hasInternet) {
      _status = JarvisConnectionStatus.offline;
      return await _offlineResponse(userMessage);
    }

    final systemPrompt = await personalityService.getSystemPrompt();
    final wasOffline = _status != JarvisConnectionStatus.online;

    // Tenta cada provedor em ordem
    final result = await _tryGemini(systemPrompt, userMessage) ??
        await _tryOpenRouter(systemPrompt, userMessage) ??
        await _trySambanova(systemPrompt, userMessage) ??
        await _tryCloudflareAI(systemPrompt, userMessage) ??
        await _tryHuggingFace(systemPrompt, userMessage);

    if (result != null) {
      final wasDown = _status != JarvisConnectionStatus.online;
      _status = JarvisConnectionStatus.online;
      return wasDown || wasOffline
          ? 'Senhor, voltamos a operar em plena capacidade.\n\n$result'
          : result;
    }

    _status = JarvisConnectionStatus.offline;
    return await _offlineResponse(userMessage);
  }

  Future<String?> _callWorker(String provider, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'provider': provider, 'payload': payload}),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (_) {}
    return null;
  }

  Future<String?> _tryGemini(String systemPrompt, String userMessage) async {
    final models = [
      'gemini-2.5-flash',
      'gemini-2.0-flash',
      'gemini-2.0-flash-lite',
    ];

    for (final model in models) {
      try {
        final raw = await _callWorker('gemini', {
          'model': model,
          'body': {
            'system_instruction': {
              'parts': [{'text': systemPrompt}]
            },
            'contents': [
              {
                'role': 'user',
                'parts': [{'text': userMessage}]
              }
            ],
            'generationConfig': {
              'temperature': 0.85,
              'maxOutputTokens': 2048,
            },
          },
        });

        if (raw != null) {
          final data = jsonDecode(raw);
          if (data['candidates'] != null) {
            return data['candidates'][0]['content']['parts'][0]['text'] as String;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String?> _tryOpenRouter(String systemPrompt, String userMessage) async {
    final models = [
      'meta-llama/llama-3.3-70b-instruct:free',
      'mistralai/mistral-7b-instruct:free',
      'qwen/qwen-2.5-72b-instruct:free',
    ];

    for (final model in models) {
      try {
        final raw = await _callWorker('openrouter', {
          'model': model,
          'body': {
            'model': model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userMessage},
            ],
            'max_tokens': 2048,
            'temperature': 0.85,
          },
        });

        if (raw != null) {
          final data = jsonDecode(raw);
          if (data['choices'] != null) {
            return data['choices'][0]['message']['content'] as String;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String?> _trySambanova(String systemPrompt, String userMessage) async {
    final models = [
      'Meta-Llama-3.3-70B-Instruct',
      'Meta-Llama-3.1-8B-Instruct',
    ];

    for (final model in models) {
      try {
        final raw = await _callWorker('sambanova', {
          'model': model,
          'body': {
            'model': model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userMessage},
            ],
            'max_tokens': 2048,
            'temperature': 0.85,
          },
        });

        if (raw != null) {
          final data = jsonDecode(raw);
          if (data['choices'] != null) {
            return data['choices'][0]['message']['content'] as String;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String?> _tryCloudflareAI(String systemPrompt, String userMessage) async {
    final models = [
      '@cf/meta/llama-3.3-70b-instruct-fp8-fast',
      '@cf/mistral/mistral-7b-instruct-v0.1',
    ];

    for (final model in models) {
      try {
        final raw = await _callWorker('cloudflare', {
          'model': model,
          'body': {
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userMessage},
            ],
            'max_tokens': 2048,
          },
        });

        if (raw != null) {
          final data = jsonDecode(raw);
          if (data['result'] != null) {
            return data['result']['response'] as String;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String?> _tryHuggingFace(String systemPrompt, String userMessage) async {
    final models = [
      'Qwen/Qwen2.5-72B-Instruct',
      'meta-llama/Llama-3.3-70B-Instruct',
      'mistralai/Mistral-7B-Instruct-v0.3',
    ];

    for (final model in models) {
      try {
        final raw = await _callWorker('huggingface', {
          'model': model,
          'body': {
            'model': model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userMessage},
            ],
            'max_tokens': 2048,
            'temperature': 0.85,
          },
        });

        if (raw != null) {
          final data = jsonDecode(raw);
          if (data['choices'] != null) {
            return data['choices'][0]['message']['content'] as String;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String> _offlineResponse(String userMessage) async {
    final lower = userMessage.toLowerCase();
    final systemPrompt = await personalityService.getSystemPrompt();
    final hasMemories = !systemPrompt.contains('Nenhuma ainda.');

    if (lower.contains('oi') ||
        lower.contains('olá') ||
        lower.contains('boa') ||
        lower.contains('bom dia') ||
        lower.contains('boa tarde') ||
        lower.contains('boa noite')) {
      return 'Senhor, no momento estou operando em modo offline. '
          'Posso conversar sobre assuntos que já conheço, '
          'mas não consigo responder dúvidas sobre temas ainda não discutidos. '
          'Estou monitorando e avisarei assim que voltar.';
    }

    if (hasMemories) {
      return 'Senhor, estou temporariamente offline. '
          'Tenho acesso às minhas memórias, mas minha capacidade está limitada. '
          'Continuarei monitorando a conexão.';
    }

    return 'Senhor, no momento estou com problemas de conexão. '
        'Assim que restabelecida, avisarei imediatamente.';
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
