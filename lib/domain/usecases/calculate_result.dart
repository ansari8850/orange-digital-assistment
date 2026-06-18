import '../entities/quiz.dart';
import '../entities/user_response.dart';
import '../entities/quiz_result.dart';
import '../entities/question.dart';
import '../../core/errors/failures.dart';

class CalculateResult {
  const CalculateResult();

  Future<QuizResult> call(CalculateResultParams params) async {
    try {
      final quiz = params.quiz;
      final responses = params.responses;
      
      final questionResults = <String, QuestionResult>{};
      int totalScore = 0;
      int correctAnswers = 0;
      int attemptedQuestions = 0;

      // Process all questions including sub-questions
      final allQuestions = quiz.allQuestions;

      for (final question in allQuestions) {
        final response = responses.firstWhere(
          (r) => r.questionId == question.id,
          orElse: () => UserResponse(
            questionId: question.id,
            selectedAnswerIds: [],
            timestamp: DateTime.now(),
          ),
        );

        final questionResult = _evaluateQuestion(question, response);
        questionResults[question.id] = questionResult;

        totalScore += questionResult.marksObtained.round();
        if (questionResult.isCorrect) correctAnswers++;
        if (response.hasAnswer) attemptedQuestions++;
      }

      final passed = totalScore >= quiz.passingMarks;
      final maxScore = quiz.totalMarks;

      final quizResult = QuizResult(
        totalScore: totalScore,
        maxScore: maxScore,
        passed: passed,
        timeTaken: params.timeTaken,
        totalQuestions: allQuestions.length,
        attemptedQuestions: attemptedQuestions,
        correctAnswers: correctAnswers,
        questionResults: questionResults,
      );

      return quizResult;
    } catch (e) {
      throw DataFailure('Failed to calculate result: $e');
    }
  }



  QuestionResult _evaluateQuestion(Question question, UserResponse response) {
    double marksObtained = 0;
    bool isCorrect = false;

    switch (question.type) {
      case QuestionType.objective:
      case QuestionType.trueFalse:
        if (response.selectedAnswerIds.isNotEmpty) {
          final selectedAnswer = question.options
              .where((opt) => opt.id == response.selectedAnswerIds.first)
              .firstOrNull;
          if (selectedAnswer != null && selectedAnswer.isCorrect) {
            marksObtained = question.positiveMarks;
            isCorrect = true;
          } else {
            marksObtained = -question.negativeMarks;
          }
        }
        break;

      case QuestionType.multiSelect:
        if (response.selectedAnswerIds.isNotEmpty) {
          final correctAnswers = question.options
              .where((opt) => opt.isCorrect)
              .map((opt) => opt.id)
              .toSet();
          final selectedAnswers = response.selectedAnswerIds.toSet();
          
          if (correctAnswers == selectedAnswers) {
            marksObtained = question.positiveMarks;
            isCorrect = true;
          } else {
            marksObtained = -question.negativeMarks;
          }
        }
        break;

      case QuestionType.subjective:
        // For subjective questions, we'll use a simple keyword matching
        // In a real app, this might involve AI evaluation
        if (response.textAnswer != null && response.textAnswer!.isNotEmpty) {
          // Simple evaluation - give partial marks based on answer length
          final wordCount = response.textAnswer!.split(' ').length;
          if (wordCount >= 10) {
            marksObtained = question.positiveMarks * 0.7; // 70% for attempting
            isCorrect = true;
          }
        }
        break;

      case QuestionType.comprehension:
        // Handle comprehension questions similar to objective/multi-select
        if (response.selectedAnswerIds.isNotEmpty) {
          final selectedAnswer = question.options
              .where((opt) => opt.id == response.selectedAnswerIds.first)
              .firstOrNull;
          if (selectedAnswer != null && selectedAnswer.isCorrect) {
            marksObtained = question.positiveMarks;
            isCorrect = true;
          } else {
            marksObtained = -question.negativeMarks;
          }
        }
        break;
    }

    return QuestionResult(
      questionId: question.id,
      isCorrect: isCorrect,
      marksObtained: marksObtained,
      totalMarks: question.positiveMarks,
      selectedAnswers: response.selectedAnswerIds,
      textAnswer: response.textAnswer,
    );
  }
}

class CalculateResultParams {
  final Quiz quiz;
  final List<UserResponse> responses;
  final int timeTaken;

  CalculateResultParams({
    required this.quiz,
    required this.responses,
    required this.timeTaken,
  });
}
