import '../../data/database/app_database.dart';
import '../../data/repositories/memory_repository.dart';
import 'importance_detector.dart';
import 'llm_memory_evaluator.dart';

class PersonalityService {
  final AppDatabase db;
  final ImportanceDetector importanceDetector;
  final LLMMemoryEvaluator llmEvaluator;

  PersonalityService({
    required this.db,
    required this.importanceDetector,
    required this.llmEvaluator,
  });

  Future<String> getSystemPrompt() async {
    final settings = await db.select(db.userSettings).getSingleOrNull();
    final baseName = settings?.jarvisName ?? 'Jarvis';
    final userName = settings?.userName ?? 'Elvis';

    final repo = MemoryRepository(db);
    final now = DateTime.now();

    // Busca todas de uma vez e filtra em Dart puro
    final allLongTerm = await db.select(db.longTermMemory).get();

    final permanentMemories = allLongTerm
        .where((m) => m.expiresAt == null)
        .toList();

    final longTermMemories = allLongTerm
        .where((m) => m.expiresAt != null && m.expiresAt!.isAfter(now))
        .toList();

    final allTemp = await db.select(db.temporaryMemory).get();
    final temporaryMemories = allTemp
        .where((m) => m.expiresAt.isAfter(now))
        .toList();

    // Monta os blocos de memória
    final permanentBlock = permanentMemories.isNotEmpty
        ? permanentMemories
            .map((m) => '  - [${m.category}] ${m.content}')
            .join('\n')
        : '  - Nenhuma ainda.';

    final longTermBlock = longTermMemories.isNotEmpty
        ? longTermMemories
            .map((m) => '  - [${m.category}] ${m.content}')
            .join('\n')
        : '  - Nenhuma ainda.';

    final temporaryBlock = temporaryMemories.isNotEmpty
        ? temporaryMemories.map((m) => '  - ${m.content}').join('\n')
        : '  - Nenhuma ainda.';

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