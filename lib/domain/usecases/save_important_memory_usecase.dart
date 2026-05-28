import '../services/importance_detector.dart';
import '../services/personality_service.dart';
import '../../data/repositories/memory_repository.dart';

class SaveImportantMemoryUseCase {
  final MemoryRepository memoryRepository;
  final ImportanceDetector importanceDetector;
  final PersonalityService personalityService;

  SaveImportantMemoryUseCase({
    required this.memoryRepository,
    required this.importanceDetector,
    required this.personalityService,
  });

  Future<void> call({
    required String userMessage,
    required String jarvisResponse,
  }) async {
    final lower = userMessage.toLowerCase();
    final isExplicit = _isExplicitSaveRequest(lower);
    final isImportant = importanceDetector.isImportant(
      userMessage,
      jarvisResponse: jarvisResponse,
    );

    if (!isExplicit && !isImportant) return;

    final level = _detectMemoryLevel(lower);
    final category = _detectCategory(lower);

    switch (level) {
      case MemoryLevel.permanent:
        await memoryRepository.savePermanentMemory(
          content: userMessage,
          category: category,
        );
        break;
      case MemoryLevel.longTerm:
        await memoryRepository.saveLongTermMemory(
          content: userMessage,
          category: category,
        );
        break;
      case MemoryLevel.temporary:
        await memoryRepository.saveTemporaryMemory(
          content: userMessage,
        );
        break;
    }
  }

  // Detecta qual nível de memória usar
  MemoryLevel _detectMemoryLevel(String lower) {
    // Nível 1 — Permanente: sobre personalidade, preferências, quem é Elvis
    if (lower.contains('personalidade') ||
        lower.contains('preferência') ||
        lower.contains('prefiro') ||
        lower.contains('sempre') ||
        lower.contains('odeio') ||
        lower.contains('amo') ||
        lower.contains('nunca') ||
        lower.contains('programado') ||
        lower.contains('você é') ||
        lower.contains('minha rotina')) {
      return MemoryLevel.permanent;
    }

    // Nível 3 — Temporária: rotina do dia, tarefas passageiras
    if (lower.contains('hoje') ||
        lower.contains('amanhã') ||
        lower.contains('essa semana') ||
        lower.contains('esse mês') ||
        lower.contains('temporari')) {
      return MemoryLevel.temporary;
    }

    // Nível 2 — Longo prazo: tudo mais importante
    return MemoryLevel.longTerm;
  }

  bool _isExplicitSaveRequest(String lower) {
    return lower.contains('salva') ||
        lower.contains('guarda') ||
        lower.contains('memoriza') ||
        lower.contains('anota') ||
        lower.contains('não esqueça') ||
        lower.contains('lembre') ||
        lower.contains('memória');
  }

  String _detectCategory(String lower) {
    if (lower.contains('rotina') ||
        lower.contains('acord') ||
        lower.contains('horário') ||
        lower.contains('hoje')) return 'rotina';

    if (lower.contains('gost') ||
        lower.contains('prefer') ||
        lower.contains('favorit') ||
        lower.contains('prefiro')) return 'preferencias';

    if (lower.contains('personalidade') ||
        lower.contains('comportamento') ||
        lower.contains('programado') ||
        lower.contains('você é')) return 'personalidade';

    if (lower.contains('trabalho') ||
        lower.contains('projeto') ||
        lower.contains('tarefa')) return 'trabalho';

    return 'general';
  }
}

enum MemoryLevel { permanent, longTerm, temporary }