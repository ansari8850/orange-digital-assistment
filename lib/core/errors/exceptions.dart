abstract class QuizException implements Exception {
  final String message;
  
  const QuizException(this.message);
  
  @override
  String toString() => message;
}

class QuizDataException extends QuizException {
  const QuizDataException(String message) : super(message);
}

class QuizJsonParsingException extends QuizException {
  const QuizJsonParsingException(String message) : super(message);
}

class QuizAssetException extends QuizException {
  const QuizAssetException(String message) : super(message);
}

class QuizTimerException extends QuizException {
  const QuizTimerException(String message) : super(message);
}

class QuizValidationException extends QuizException {
  const QuizValidationException(String message) : super(message);
}
