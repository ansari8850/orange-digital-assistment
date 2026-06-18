abstract class Failure {
  final String message;
  
  const Failure(this.message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  String toString() => message;
}

class DataFailure extends Failure {
  const DataFailure(String message) : super(message);
}

class JsonParsingFailure extends Failure {
  const JsonParsingFailure(String message) : super(message);
}

class AssetFailure extends Failure {
  const AssetFailure(String message) : super(message);
}

class TimerFailure extends Failure {
  const TimerFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}
