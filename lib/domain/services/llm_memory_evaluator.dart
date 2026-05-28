import 'importance_detector.dart';

class LLMMemoryEvaluator {
  final ImportanceDetector detector;

  LLMMemoryEvaluator(this.detector);

  /// Decisão avançada usando LLM (quando estiver online)
  Future<bool> shouldAskToSaveLongTerm({
    required String userMessage,
    String jarvisResponse = '',
  }) async {
    // Primeiro faz a verificação rápida offline
    if (!detector.isImportant(userMessage, jarvisResponse: jarvisResponse)) {
      return false;
    }

    // Aqui virá a chamada para o LLM (vamos implementar depois)
    // Por enquanto vamos retornar true para testar
    return true;

    /* 
    Exemplo futuro com LLM:
    final prompt = """
      Analise se esta conversa é importante o suficiente para salvar na memória de longo prazo.
      Responda apenas com SIM ou NÃO.
      
      Conversa: $userMessage
      Resposta do Jarvis: $jarvisResponse
    """;
    
    // Chamar API do LLM...
    */
  }
}