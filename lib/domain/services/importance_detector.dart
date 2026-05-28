class ImportanceDetector {
  
  static const List<String> highImportanceKeywords = [
    'odeio', 'preciso', 'importante', 'sempre', 'nunca', 'meta', 'objetivo',
    'medo', 'sonho', 'problema', 'decisão', 'compromisso', 'rotina', 'hábito',
    'faculdade', 'trabalho', 'saúde', 'dinheiro', 'família', 'vou tentar',
    'quero melhorar', 'difícil', 'desafio'
  ];

  /// Detecção simples offline
  bool isImportant(String userMessage, {String jarvisResponse = ''}) {
    final fullText = (userMessage + " " + jarvisResponse).toLowerCase();

    return highImportanceKeywords.any((word) => fullText.contains(word)) ||
           fullText.contains('vou tentar') ||
           fullText.contains('preciso mudar') ||
           fullText.contains('quero conseguir');
  }
}