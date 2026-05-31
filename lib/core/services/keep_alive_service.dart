import 'dart:async';
import 'package:http/http.dart' as http;

class KeepAliveService {
  static Timer? _timer;

  static void start() {
    // Pinga a cada 10 minutos para não deixar o Render dormir
    _timer = Timer.periodic(const Duration(minutes: 10), (_) async {
      try {
        await http.get(
          Uri.parse('https://api-render-bomf.onrender.com/settings'),
        ).timeout(const Duration(seconds: 10));
      } catch (_) {}
    });
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }
}