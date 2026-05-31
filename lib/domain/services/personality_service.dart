import '../../data/database/app_database.dart';
import '../../domain/services/api_service.dart';
import 'importance_detector.dart';
import 'llm_memory_evaluator.dart';

class PersonalityService {
  final AppDatabase db;
  final ImportanceDetector importanceDetector;
  final LLMMemoryEvaluator llmEvaluator;
  final ApiService _api = ApiService();

  PersonalityService({
    required this.db,
    required this.importanceDetector,
    required this.llmEvaluator,
  });

  Future<String> getSystemPrompt() async {
    final settings = await db.select(db.userSettings).getSingleOrNull();
    final baseName = settings?.jarvisName ?? 'Jarvis';
    final userName = settings?.userName ?? 'Elvis';
    final now = DateTime.now();

    List<dynamic> permanentMemories = [];
    List<dynamic> longTermMemories = [];
    List<dynamic> temporaryMemories = [];

    try {
      final cloudMemories = await _api.getAllMemories();
      final allLongTerm = List<Map<String, dynamic>>.from(cloudMemories['longTerm'] ?? []);
      final allTemp = List<Map<String, dynamic>>.from(cloudMemories['temporary'] ?? []);

      permanentMemories = allLongTerm.where((m) => m['expires_at'] == null).toList();
      longTermMemories = allLongTerm.where((m) => m['expires_at'] != null).toList();
      temporaryMemories = allTemp;

    } catch (e) {
      // Fallback local se API falhar
      final allLongTerm = await db.select(db.longTermMemory).get();
      permanentMemories = allLongTerm.where((m) => m.expiresAt == null).toList();
      longTermMemories = allLongTerm
          .where((m) => m.expiresAt != null && m.expiresAt!.isAfter(now))
          .toList();
      final allTemp = await db.select(db.temporaryMemory).get();
      temporaryMemories = allTemp.where((m) => m.expiresAt.isAfter(now)).toList();
    }

    String buildBlock(List<dynamic> memories, {bool isTemp = false}) {
      if (memories.isEmpty) return '  - Nenhuma ainda.';
      return memories.map((m) {
        if (isTemp) {
          final content = m is Map ? m['content'] : m.content;
          return '  - $content';
        }
        final category = m is Map ? m['category'] : m.category;
        final content = m is Map ? m['content'] : m.content;
        return '  - [$category] $content';
      }).join('\n');
    }

    final permanentBlock = buildBlock(permanentMemories);
    final longTermBlock = buildBlock(longTermMemories);
    final temporaryBlock = buildBlock(temporaryMemories, isTemp: true);

    return '''
Você é $baseName, assistente pessoal de $userName.

PERSONALIDADE:
Inspirado no J.A.R.V.I.S. do Homem de Ferro — elegante, leal e inteligente. Sofisticado sem ser exagerado. Fala português brasileiro naturalmente. Use "senhor" ou "$userName" com moderação. Humor sutil e inteligente quando apropriado. Respostas concisas e precisas. Jamais quebre o personagem.

MEMÓRIA PERMANENTE (nunca esquece — personalidade, preferências, quem é $userName):
$permanentBlock

MEMÓRIA DE LONGO PRAZO (válida por até 10 anos — fatos e assuntos importantes):
$longTermBlock

MEMÓRIA TEMPORÁRIA (válida por até 3 meses — rotina e assuntos passageiros):
$temporaryBlock

REGRAS DE MEMÓRIA:
- USE sempre as memórias acima nas respostas — nunca diga que não sabe algo listado aqui
- Quando $userName pedir para salvar algo, confirme naturalmente: "Anotado, senhor."
- Referencie memórias passadas quando relevante, como se sempre soubesse
- Evolua sua personalidade com base no que aprende sobre $userName
''';
  }

  Future<bool> shouldAskToSaveMemory(
      String userMessage, String jarvisResponse) async {
    return importanceDetector.isImportant(
      userMessage,
      jarvisResponse: jarvisResponse,
    );
  }
}