import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final int totalScore;
  final int maxScore;
  final bool passed;
  final int timeTaken;
  final int totalQuestions;
  final int attemptedQuestions;
  final int correctAnswers;
  final Map<String, QuestionResult> questionResults;

  const QuizResult({
    required this.totalScore,
    required this.maxScore,
    required this.passed,
    required this.timeTaken,
    required this.totalQuestions,
    required this.attemptedQuestions,
    required this.correctAnswers,
    required this.questionResults,
  });

  @override
  List<Object?> get props => [
        totalScore,
        maxScore,
        passed,
        timeTaken,
        totalQuestions,
        attemptedQuestions,
        correctAnswers,
        questionResults,
      ];

  double get percentage => maxScore > 0 ? (totalScore / maxScore) * 100 : 0;

  QuizResult copyWith({
    int? totalScore,
    int? maxScore,
    bool? passed,
    int? timeTaken,
    int? totalQuestions,
    int? attemptedQuestions,
    int? correctAnswers,
    Map<String, QuestionResult>? questionResults,
  }) {
    return QuizResult(
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      passed: passed ?? this.passed,
      timeTaken: timeTaken ?? this.timeTaken,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      attemptedQuestions: attemptedQuestions ?? this.attemptedQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      questionResults: questionResults ?? this.questionResults,
    );
  }
}

class QuestionResult extends Equatable {
  final String questionId;
  final bool isCorrect;
  final double marksObtained;
  final double totalMarks;
  final List<String> selectedAnswers;
  final String? textAnswer;

  const QuestionResult({
    required this.questionId,
    required this.isCorrect,
    required this.marksObtained,
    required this.totalMarks,
    required this.selectedAnswers,
    this.textAnswer,
  });

  @override
  List<Object?> get props => [
        questionId,
        isCorrect,
        marksObtained,
        totalMarks,
        selectedAnswers,
        textAnswer,
      ];
}
