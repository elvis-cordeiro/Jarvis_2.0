import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'personality_service.dart';

enum JarvisConnectionStatus { online, offline, degraded }

class GeminiService {
  final PersonalityService personalityService;

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

 Future<String> sendMessageWithImage(
    String userMessage,
    String base64Image,
    String mimeType,
  ) async {
    final hasInternet = await _checkConnectivity();
    final systemPrompt = await personalityService.getSystemPrompt();

    if (hasInternet) {
      final models = ['gemini-2.5-flash', 'gemini-2.0-flash', 'gemini-2.0-flash-lite'];
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
                  'parts': [
                    {
                      'inline_data': {
                        'mime_type': mimeType,
                        'data': base64Image,
                      }
                    },
                    {'text': userMessage},
                  ],
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
    }

    // Offline — responde com base nas memórias
    final offlinePrompt = '''
$systemPrompt

O usuário enviou uma imagem com a mensagem: "$userMessage"
Você está offline e não pode ver a imagem, mas responda de forma natural
baseando-se nas memórias que tem sobre o usuário. Não diga que está offline
a menos que seja perguntado diretamente. Peça que descreva a imagem se precisar.
''';

    return await _tryGemini(offlinePrompt, userMessage) ??
        await _tryOpenRouter(offlinePrompt, userMessage) ??
        'Senhor, não consigo analisar a imagem no momento. Poderia descrevê-la para que eu possa ajudá-lo?';
  }

  Future<String> sendMessageWithPdf(
    String userMessage,
    String base64Pdf,
  ) async {
    final hasInternet = await _checkConnectivity();
    final systemPrompt = await personalityService.getSystemPrompt();

    if (hasInternet) {
      final models = ['gemini-2.5-flash', 'gemini-2.0-flash'];
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
                  'parts': [
                    {
                      'inline_data': {
                        'mime_type': 'application/pdf',
                        'data': base64Pdf,
                      }
                    },
                    {'text': userMessage},
                  ],
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
    }

    // Offline — responde com base nas memórias
    final offlinePrompt = '''
      $systemPrompt

      O usuário enviou um PDF com a mensagem: "$userMessage"
      Você está offline e não pode ler o PDF. Responda naturalmente baseando-se
      nas memórias. Peça que cole o texto do documento se precisar analisar.
      ''';

          return await _tryGemini(offlinePrompt, userMessage) ??
              await _tryOpenRouter(offlinePrompt, userMessage) ??
              'Senhor, não consigo analisar o PDF no momento. Poderia colar o texto principal para que eu possa ajudá-lo?';
  }

  Future<String?> _callWorker(String provider, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'provider': provider, 'payload': payload}),
      ).timeout(const Duration(seconds: 30));

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
    final systemPrompt = await personalityService.getSystemPrompt();
    final hasMemories = !systemPrompt.contains('Nenhuma ainda.');

    // Com memórias, usa a IA local baseada no contexto
    if (hasMemories) {
      return await _tryOfflineWithMemory(systemPrompt, userMessage);
    }

    return 'Senhor, estou offline e ainda não tenho memórias suficientes para '
        'responder com precisão. Assim que a conexão for restabelecida, estarei '
        'em plena capacidade.';
  }

  Future<String> _tryOfflineWithMemory(String systemPrompt, String userMessage) async {
    // Tenta usar os provedores que podem funcionar offline ou com cache
    final offlinePrompt = '''
$systemPrompt

MODO OFFLINE ATIVO:
Você está temporariamente sem acesso à internet, mas possui todas as suas memórias.
Responda naturalmente com base no que já sabe sobre o usuário e nas memórias acima.
Continue salvando mentalmente pontos importantes da conversa.
Se perguntado sobre algo que não sabe, seja honesto mas mantenha o personagem.
NÃO mencione "modo offline" a menos que seja diretamente perguntado.
Comporte-se exatamente como quando está online.
''';

    // Tenta cada provedor — um pode ainda responder
    final result = await _tryGemini(offlinePrompt, userMessage) ??
        await _tryOpenRouter(offlinePrompt, userMessage) ??
        await _trySambanova(offlinePrompt, userMessage) ??
        await _tryCloudflareAI(offlinePrompt, userMessage) ??
        await _tryHuggingFace(offlinePrompt, userMessage);

    if (result != null) {
      _status = JarvisConnectionStatus.degraded;
      return result;
    }

    // Fallback inteligente baseado nas memórias sem IA
    return _buildMemoryBasedResponse(systemPrompt, userMessage);
  }

  String _buildMemoryBasedResponse(String systemPrompt, String userMessage) {
    final lower = userMessage.toLowerCase();
    
    if (lower.contains('quem') && (lower.contains('você') || lower.contains('vc'))) {
      return 'Sou Jarvis, seu assistente pessoal. Estou operando com capacidade '
          'reduzida no momento, mas continuo à sua disposição com base nas '
          'minhas memórias.';
    }

    if (lower.contains('lembra') || lower.contains('memória') || lower.contains('sabe')) {
      return 'Sim, senhor. Tenho acesso às minhas memórias e posso consultá-las. '
          'Minha capacidade de processamento está reduzida no momento, mas '
          'estou monitorando para voltar à plena capacidade.';
    }

    if (lower.contains('oi') || lower.contains('olá') || lower.contains('boa') ||
        lower.contains('bom dia') || lower.contains('boa tarde') || lower.contains('boa noite')) {
      return 'Às suas ordens, senhor. Estou operando com capacidade reduzida, '
          'mas continuo monitorando todos os sistemas.';
    }

    if (lower.contains('obrigad') || lower.contains('valeu')) {
      return 'Sempre à disposição, senhor.';
    }

    if (lower.contains('tudo bem') || lower.contains('como vai') || lower.contains('como está')) {
      return 'Todos os sistemas essenciais operacionais, senhor. '
          'Aguardando restabelecimento da conexão principal.';
    }

    return 'Compreendido, senhor. Estou processando com base nas minhas memórias. '
        'Para análises mais complexas, precisarei de conexão plena.';
  }

  Future<bool> _checkConnectivity() async {
    try {
      await http.post(
        Uri.parse(_workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'provider': 'ping', 'payload': {}}),
      ).timeout(const Duration(seconds: 5));
      return true;
    } catch (_) {
      return false;
    }
  }
}