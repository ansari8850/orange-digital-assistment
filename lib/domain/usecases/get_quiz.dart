import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuiz {
  final QuizRepository repository;

  GetQuiz(this.repository);

  Future<Quiz> call() async {
    return await repository.getQuiz();
  }
}
