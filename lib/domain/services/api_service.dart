import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api-render-bomf.onrender.com';

  // ===== MEMÓRIAS =====
  Future<void> savePermanentMemory(String content, String category) async {
    await http.post(
      Uri.parse('$_baseUrl/memory/permanent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content, 'category': category}),
    );
  }

  Future<void> saveLongTermMemory(String content, {String category = 'general'}) async {
    await http.post(
      Uri.parse('$_baseUrl/memory/longterm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content, 'category': category}),
    );
  }

  Future<void> saveTemporaryMemory(String content) async {
    await http.post(
      Uri.parse('$_baseUrl/memory/temporary'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content}),
    );
  }

  Future<Map<String, dynamic>> getAllMemories() async {
    final response = await http.get(Uri.parse('$_baseUrl/memory/all'));
    return jsonDecode(response.body);
  }

  Future<void> cleanExpiredMemories() async {
    await http.delete(
      Uri.parse('$_baseUrl/memory/cleanup'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // ===== CONVERSAS =====
  Future<void> saveConversation(String userMsg, String jarvisResponse) async {
    await http.post(
      Uri.parse('$_baseUrl/conversation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userMessage': userMsg, 'jarvisResponse': jarvisResponse}),
    );
  }

  Future<List<dynamic>> getConversationHistory() async {
    final response = await http.get(Uri.parse('$_baseUrl/conversation/history'));
    return jsonDecode(response.body);
  }

  // ===== SETTINGS =====
  Future<Map<String, dynamic>> getSettings() async {
    final response = await http.get(Uri.parse('$_baseUrl/settings'));
    return jsonDecode(response.body);
  }
}