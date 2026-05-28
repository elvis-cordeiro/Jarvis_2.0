import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_database.g.dart';

/// Tabela de Tarefas
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabela de Rotina / Aprendizado Permanente
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayOfWeek => text()();           // Monday, Tuesday...
  IntColumn get wakeUpTime => integer()();        // em minutos (4:30 = 270)
  IntColumn get leaveHomeTime => integer().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Memória Longa (até 10 anos) - Conversas importantes
class LongTermMemory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();           // ex: "personalidade", "rotina", "preferencias", "fatos"
  TextColumn get content => text()();
  TextColumn get source => text().nullable()();  // "voz", "texto"
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()(); // null = permanente
}

/// Memória Temporária (até 3 meses)
class TemporaryMemory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();   // Obrigatório expirar
}

/// Histórico de Conversas (curto prazo)
class ConversationHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userMessage => text()();
  TextColumn get jarvisResponse => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

/// Configurações / Personalidade do Jarvis
class UserSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get userName => text().withDefault(const Constant('Elvis'))();
  TextColumn get jarvisName => text().withDefault(const Constant('Jarvis'))();
  TextColumn get personalityPrompt => text().withDefault(const Constant(''))(); // Prompt customizado
  BoolColumn get voiceEnabled => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [
  Tasks,
  Routines,
  LongTermMemory,
  TemporaryMemory,
  ConversationHistory,
  UserSettings
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Aqui vamos colocar migrações futuras
      },
    );
  }
}

QueryExecutor _openConnection() {
  if (kIsWeb) {
    return driftDatabase(
      name: 'jarvis_pessoal',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  return driftDatabase(
    name: 'jarvis_pessoal',
    native: const DriftNativeOptions(),
  );
}