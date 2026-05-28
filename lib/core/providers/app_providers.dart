import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_pessoal/domain/services/gemini_service.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/services/importance_detector.dart';
import '../../domain/services/llm_memory_evaluator.dart';
import '../../domain/services/personality_service.dart';
import '../../domain/usecases/save_important_memory_usecase.dart';

// ==================== BANCO DE DADOS ====================

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ==================== REPOSITÓRIOS ====================

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MemoryRepository(db);
});

// ==================== SERVICES ====================

final importanceDetectorProvider = Provider<ImportanceDetector>((ref) {
  return ImportanceDetector();
});

final llmMemoryEvaluatorProvider = Provider<LLMMemoryEvaluator>((ref) {
  final detector = ref.watch(importanceDetectorProvider);
  return LLMMemoryEvaluator(detector);
});

final personalityServiceProvider = Provider<PersonalityService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final detector = ref.watch(importanceDetectorProvider);
  final llmEvaluator = ref.watch(llmMemoryEvaluatorProvider);
  
  return PersonalityService(
    db: db,
    importanceDetector: detector,
    llmEvaluator: llmEvaluator,
  );
});

// ==================== USE CASES ====================

final saveImportantMemoryUseCaseProvider = Provider<SaveImportantMemoryUseCase>((ref) {
  return SaveImportantMemoryUseCase(
    memoryRepository: ref.watch(memoryRepositoryProvider),
    importanceDetector: ref.watch(importanceDetectorProvider),
    personalityService: ref.watch(personalityServiceProvider),
  );
});

// ... no final do arquivo

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final personalityService = ref.watch(personalityServiceProvider);
  return GeminiService(personalityService);
});