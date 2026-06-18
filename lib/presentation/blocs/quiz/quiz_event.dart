import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_response.dart';
import '../../../domain/entities/quiz_result.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class QuizStarted extends QuizEvent {}

class QuizLoaded extends QuizEvent {
  final String quizTitle;
  final int totalQuestions;
  final int duration;

  QuizLoaded({
    required this.quizTitle,
    required this.totalQuestions,
    required this.duration,
  });

  @override
  List<Object> get props => [quizTitle, totalQuestions, duration];
}

class QuestionNavigated extends QuizEvent {
  final int questionIndex;

  QuestionNavigated(this.questionIndex);

  @override
  List<Object> get props => [questionIndex];
}

class AnswerSubmitted extends QuizEvent {
  final String questionId;
  final List<String> selectedAnswerIds;
  final String? textAnswer;

  AnswerSubmitted({
    required this.questionId,
    required this.selectedAnswerIds,
    this.textAnswer,
  });

  @override
  List<Object> get props => [questionId, selectedAnswerIds, textAnswer];
}

class QuizSubmitted extends QuizEvent {
  final List<UserResponse> responses;
  final int timeTaken;

  QuizSubmitted({
    required this.responses,
    required this.timeTaken,
  });

  @override
  List<Object> get props => [responses, timeTaken];
}

class QuizCompleted extends QuizEvent {
  final QuizResult result;

  QuizCompleted(this.result);

  @override
  List<Object> get props => [result];
}

class QuizReset extends QuizEvent {}

class TimerExpired extends QuizEvent {}
