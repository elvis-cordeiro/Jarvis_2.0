import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';
import 'dart:convert';

late Connection db;

Future<void> main() async {
  final dbUrl = Platform.environment['DATABASE_URL']!;
  final uri = Uri.parse(dbUrl);

  // Separa usuário e senha corretamente
  final userInfo = uri.userInfo.split(':');
  final username = userInfo[0];
  final password = userInfo.sublist(1).join(':'); // senha pode ter : dentro

  db = await Connection.open(
    Endpoint(
      host: uri.host,
      port: uri.port == 0 ? 5432 : uri.port, // garante porta 5432
      database: uri.path.replaceFirst('/', ''),
      username: username,
      password: password,
    ),
    settings: const ConnectionSettings(sslMode: SslMode.require),
  );

  await _createTables();

  final router = Router()
    // Memórias
    ..post('/memory/permanent', savePermanentMemory)
    ..post('/memory/longterm', saveLongTermMemory)
    ..post('/memory/temporary', saveTemporaryMemory)
    ..get('/memory/all', getAllMemories)
    ..delete('/memory/cleanup', cleanExpiredMemories)
    // Conversas
    ..post('/conversation', saveConversation)
    ..get('/conversation/history', getConversationHistory)
    // Configurações
    ..get('/settings', getSettings)
    ..put('/settings', updateSettings);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await serve(handler, InternetAddress.anyIPv4, port);
  print('Jarvis API rodando na porta $port');
}

// ============ TABELAS ============
Future<void> _createTables() async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS long_term_memory (
      id SERIAL PRIMARY KEY,
      category TEXT NOT NULL,
      content TEXT NOT NULL,
      source TEXT,
      created_at TIMESTAMP DEFAULT NOW(),
      expires_at TIMESTAMP
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS temporary_memory (
      id SERIAL PRIMARY KEY,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT NOW(),
      expires_at TIMESTAMP NOT NULL
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS conversation_history (
      id SERIAL PRIMARY KEY,
      user_message TEXT NOT NULL,
      jarvis_response TEXT NOT NULL,
      timestamp TIMESTAMP DEFAULT NOW()
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS tasks (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      due_date TIMESTAMP,
      is_completed BOOLEAN DEFAULT FALSE,
      priority INTEGER DEFAULT 1,
      created_at TIMESTAMP DEFAULT NOW()
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS routines (
      id SERIAL PRIMARY KEY,
      day_of_week TEXT NOT NULL,
      wake_up_time INTEGER NOT NULL,
      leave_home_time INTEGER,
      notes TEXT
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS user_settings (
      id INTEGER DEFAULT 1 PRIMARY KEY,
      user_name TEXT DEFAULT 'Elvis',
      jarvis_name TEXT DEFAULT 'Jarvis',
      personality_prompt TEXT DEFAULT '',
      voice_enabled BOOLEAN DEFAULT TRUE
    );
  ''');
  // Garante que as configurações padrão existam
  await db.execute('''
    INSERT INTO user_settings (id) VALUES (1)
    ON CONFLICT (id) DO NOTHING;
  ''');
  print('Tabelas criadas/verificadas com sucesso!');
}

// ============ CORS ============
Middleware _corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await handler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

// ============ HANDLERS ============
Future<Response> savePermanentMemory(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await db.execute(
    'INSERT INTO long_term_memory (category, content, source) VALUES (\$1, \$2, \$3)',
    parameters: [body['category'], body['content'], body['source'] ?? 'conversation'],
  );
  return Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> saveLongTermMemory(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await db.execute(
    'INSERT INTO long_term_memory (category, content, source, expires_at) VALUES (\$1, \$2, \$3, \$4)',
    parameters: [
      body['category'] ?? 'general',
      body['content'],
      'conversation',
      DateTime.now().add(const Duration(days: 3650)).toIso8601String(),
    ],
  );
  return Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> saveTemporaryMemory(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await db.execute(
    'INSERT INTO temporary_memory (content, expires_at) VALUES (\$1, \$2)',
    parameters: [
      body['content'],
      DateTime.now().add(const Duration(days: 90)).toIso8601String(),
    ],
  );
  return Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> getAllMemories(Request req) async {
  final now = DateTime.now().toIso8601String();
  final longTerm = await db.execute(
    'SELECT id, category, content, source, created_at::text, expires_at::text FROM long_term_memory WHERE expires_at IS NULL OR expires_at > \$1',
    parameters: [now],
  );
  final temporary = await db.execute(
    'SELECT id, content, created_at::text, expires_at::text FROM temporary_memory WHERE expires_at > \$1',
    parameters: [now],
  );

  final longTermList = longTerm.map((r) {
    final map = r.toColumnMap();
    return map.map((k, v) => MapEntry(k, v?.toString() ?? v));
  }).toList();

  final tempList = temporary.map((r) {
    final map = r.toColumnMap();
    return map.map((k, v) => MapEntry(k, v?.toString() ?? v));
  }).toList();

  return Response.ok(
    jsonEncode({
      'longTerm': longTermList,
      'temporary': tempList,
    }),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> cleanExpiredMemories(Request req) async {
  final now = DateTime.now().toIso8601String();
  await db.execute('DELETE FROM temporary_memory WHERE expires_at < \$1', parameters: [now]);
  await db.execute(
    'DELETE FROM long_term_memory WHERE expires_at IS NOT NULL AND expires_at < \$1',
    parameters: [now],
  );
  return Response.ok(jsonEncode({'status': 'cleaned'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> saveConversation(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await db.execute(
    'INSERT INTO conversation_history (user_message, jarvis_response) VALUES (\$1, \$2)',
    parameters: [body['userMessage'], body['jarvisResponse']],
  );
  return Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> getConversationHistory(Request req) async {
  final rows = await db.execute(
    'SELECT * FROM conversation_history ORDER BY timestamp DESC LIMIT 50',
  );
  return Response.ok(
    jsonEncode(rows.map((r) => r.toColumnMap()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getSettings(Request req) async {
  final rows = await db.execute('SELECT * FROM user_settings WHERE id = 1');
  return Response.ok(
    jsonEncode(rows.first.toColumnMap()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> updateSettings(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await db.execute(
    '''UPDATE user_settings SET 
      user_name = \$1, jarvis_name = \$2, 
      personality_prompt = \$3, voice_enabled = \$4 
    WHERE id = 1''',
    parameters: [
      body['userName'],
      body['jarvisName'],
      body['personalityPrompt'],
      body['voiceEnabled'],
    ],
  );
  return Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
}