import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api-render-bomf.onrender.com';
  static const Duration _timeout = Duration(seconds: 15);

  // ===== HEALTH CHECK =====
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/settings'))
          .timeout(const Duration(seconds: 8));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ===== MEMÓRIAS =====
  Future<bool> savePermanentMemory(String content, String category) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/memory/permanent'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'content': content, 'category': category}),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] savePermanentMemory error: $e');
      return false;
    }
  }

  Future<bool> saveLongTermMemory(String content, {String category = 'general'}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/memory/longterm'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'content': content, 'category': category}),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] saveLongTermMemory error: $e');
      return false;
    }
  }

  Future<bool> saveTemporaryMemory(String content) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/memory/temporary'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'content': content}),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] saveTemporaryMemory error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getAllMemories() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/memory/all'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('[ApiService] getAllMemories error: $e');
    }
    return {'longTerm': [], 'temporary': []};
  }

  Future<bool> cleanExpiredMemories() async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl/memory/cleanup'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] cleanExpiredMemories error: $e');
      return false;
    }
  }

  // ===== CONVERSAS =====
  Future<bool> saveConversation(String userMsg, String jarvisResponse) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/conversation'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userMessage': userMsg,
              'jarvisResponse': jarvisResponse,
            }),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] saveConversation error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getConversationHistory() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/conversation/history'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      debugPrint('[ApiService] getConversationHistory error: $e');
    }
    return [];
  }

  // ===== SETTINGS =====
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/settings'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('[ApiService] getSettings error: $e');
    }
    return {};
  }
}
