import '../entities/quiz.dart';
import '../entities/user_response.dart';
import '../entities/quiz_result.dart';
import '../../core/errors/failures.dart';

abstract class QuizRepository {
  Future<Quiz> getQuiz();
  Future<QuizResult> submitQuiz(List<UserResponse> responses);
  Future<void> saveProgress(List<UserResponse> responses);
  Future<List<UserResponse>> getProgress();
}
