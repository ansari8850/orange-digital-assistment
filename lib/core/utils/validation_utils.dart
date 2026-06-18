
class ValidationUtils {
  static int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
  
  static int countCharacters(String text) {
    return text.length;
  }
  
  static bool isWithinWordLimit(String text, int limit) {
    return countWords(text) <= limit;
  }
  
  static bool isWithinCharacterLimit(String text, int limit) {
    return countCharacters(text) <= limit;
  }
  
  static String getWordCountMessage(String text, int maxWords) {
    final currentWords = countWords(text);
    return 'Current: $currentWords/$maxWords words';
  }
  
  static WordCountStatus getWordCountStatus(String text, int maxWords) {
    final currentWords = countWords(text);
    final percentage = (currentWords / maxWords) * 100;
    
    if (percentage <= 70) {
      return WordCountStatus.good;
    } else if (percentage <= 90) {
      return WordCountStatus.warning;
    } else if (percentage <= 100) {
      return WordCountStatus.critical;
    } else {
      return WordCountStatus.exceeded;
    }
  }
}

enum WordCountStatus {
  good,
  warning,
  critical,
  exceeded,
}
