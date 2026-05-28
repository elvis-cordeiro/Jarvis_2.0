import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../../domain/services/api_service.dart';

class MemoryRepository {
  final AppDatabase db;
  final ApiService _api = ApiService();

  MemoryRepository(this.db);

  // ====================== NÍVEL 1 — PERMANENTE ======================
  // Personalidade, preferências, rotinas — nunca expira
  Future<void> savePermanentMemory({
    required String content,
    required String category,
  }) async {
    // Salva local (Drift)
    await db.into(db.longTermMemory).insert(
      LongTermMemoryCompanion(
        category: Value(category),
        content: Value(content),
        source: const Value('conversation'),
        // expiresAt ausente = null = permanente
      ),
    );

    // Sincroniza com API (nuvem)
    try {
      await _api.savePermanentMemory(content, category);
    } catch (e) {
      // Não quebra o app se a API falhar — dados já estão salvos local
      print('[API] Erro ao sincronizar memória permanente: $e');
    }
  }

  // ====================== NÍVEL 2 — LONGO PRAZO (10 anos) ======================
  // Assuntos importantes, fatos relevantes
  Future<void> saveLongTermMemory({
    required String content,
    String category = 'general',
  }) async {
    // Salva local (Drift)
    await db.into(db.longTermMemory).insert(
      LongTermMemoryCompanion(
        category: Value(category),
        content: Value(content),
        source: const Value('conversation'),
        expiresAt: Value(DateTime.now().add(const Duration(days: 3650))),
      ),
    );

    // Sincroniza com API (nuvem)
    try {
      await _api.saveLongTermMemory(content, category: category);
    } catch (e) {
      print('[API] Erro ao sincronizar memória longo prazo: $e');
    }
  }

  // ====================== NÍVEL 3 — TEMPORÁRIA (3 meses) ======================
  // Rotina do dia, assuntos passageiros
  Future<void> saveTemporaryMemory({
    required String content,
  }) async {
    // Salva local (Drift)
    await db.into(db.temporaryMemory).insert(
      TemporaryMemoryCompanion(
        content: Value(content),
        expiresAt: Value(DateTime.now().add(const Duration(days: 90))),
      ),
    );

    // Sincroniza com API (nuvem)
    try {
      await _api.saveTemporaryMemory(content);
    } catch (e) {
      print('[API] Erro ao sincronizar memória temporária: $e');
    }
  }

  // ====================== BUSCAR ======================

  // Busca todas as memórias de longo prazo válidas (permanentes + não expiradas)
  // Tenta buscar da nuvem primeiro, cai para local se falhar
  Future<List<LongTermMemoryData>> getAllLongTermMemories() async {
    final now = DateTime.now();
    final all = await db.select(db.longTermMemory).get();
    return all
        .where((m) => m.expiresAt == null || m.expiresAt!.isAfter(now))
        .toList();
  }

  // Busca apenas memórias permanentes (expiresAt == null)
  Future<List<LongTermMemoryData>> getPermanentMemories() async {
    final all = await db.select(db.longTermMemory).get();
    return all.where((m) => m.expiresAt == null).toList();
  }

  // Busca memórias de longo prazo com expiração (não expiradas)
  Future<List<LongTermMemoryData>> getActiveLongTermMemories() async {
    final now = DateTime.now();
    final all = await db.select(db.longTermMemory).get();
    return all
        .where((m) => m.expiresAt != null && m.expiresAt!.isAfter(now))
        .toList();
  }

  // Busca memórias temporárias válidas
  Future<List<TemporaryMemoryData>> getActiveTemporaryMemories() async {
    final now = DateTime.now();
    final all = await db.select(db.temporaryMemory).get();
    return all.where((m)