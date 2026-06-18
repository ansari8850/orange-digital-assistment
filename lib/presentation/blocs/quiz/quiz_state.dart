import 'package:equatable/equatable.dart';
import '../../../domain/entities/quiz.dart';
import '../../../domain/entities/user_response.dart';
import '../../../domain/entities/quiz_result.dart';

enum QuizStatus {
  initial,
  loading,
  ready,
  inProgress,
  completed,
  error,
}

class QuizState extends Equatable {
  final QuizStatus status;
  final Quiz? quiz;
  final int currentQuestionIndex;
  final List<UserResponse> responses;
  final QuizResult? result;
  final String errorMessage;
  final int startTime;
  final int endTime;

  const QuizState({
    required this.status,
    this.quiz,
    required this.currentQuestionIndex,
    required this.responses,
    this.result,
    required this.errorMessage,
    required this.startTime,
    required this.endTime,
  });

  QuizState copyWith({
    QuizStatus? status,
    Quiz? quiz,
    int? currentQuestionIndex,
    List<UserResponse>? responses,
    QuizResult? result,
    String? errorMessage,
    int? startTime,
    int? endTime,
  }) {
    return QuizState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      responses: responses ?? this.responses,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quiz,
        currentQuestionIndex,
        responses,
        result,
        errorMessage,
        startTime,
        endTime,
      ];

  bool get isFirstQuestion => currentQuestionIndex == 0;
  bool get isLastQuestion => quiz != null && currentQuestionIndex == _totalQuestions - 1;
  bool get canGoBack => currentQuestionIndex > 0;
  bool get canGoForward => quiz != null && currentQuestionIndex < _totalQuestions - 1;
  
  int get _totalQuestions {
    if (quiz == null) return 0;
    int count = quiz!.questions.length;
    for (final question in quiz!.questions) {
      if (question.hasSubQuestions) {
        count += question.subQuestions.length;
      }
    }
    return count;
  }
  
  int get totalQuestions => _totalQuestions;
  int get answeredQuestions => responses.length;
  double get progress => _totalQuestions > 0 ? answeredQuestions / _totalQuestions : 0;

  @override
  String toString() => 'QuizState(status: $status, currentQuestionIndex: $currentQuestionIndex, totalQuestions: $totalQuestions)';
}
