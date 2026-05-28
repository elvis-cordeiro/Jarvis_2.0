import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SettingsRepository {
  final AppDatabase db;

  SettingsRepository(this.db);

  // Buscar configurações
  Future<UserSetting> getSettings() async {
    return await (db.select(db.userSettings).getSingle());
  }

  // Atualizar nome do Jarvis
  Future<void> updateJarvisName(String newName) async {
    await (db.update(db.userSettings)
          ..where((tbl) => tbl.id.equals(1)))
        .write(UserSettingsCompanion(
      jarvisName: Value(newName),
    ));
  }

  // Atualizar prompt de personalidade (futuro)
  Future<void> updatePersonalityPrompt(String newPrompt) async {
    await (db.update(db.userSettings)
          ..where((tbl) => tbl.id.equals(1)))
        .write(UserSettingsCompanion(
      personalityPrompt: Value(newPrompt),
    ));
  }
}