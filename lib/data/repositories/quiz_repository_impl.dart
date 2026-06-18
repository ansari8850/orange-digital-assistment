import '../../domain/entities/quiz.dart';
import '../../domain/entities/user_response.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local/quiz_local_datasource.dart';
import '../models/quiz_model.dart';
import '../models/user_response_model.dart';
import '../../domain/usecases/calculate_result.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource localDataSource;
  final CalculateResult calculateResult;

  QuizRepositoryImpl({
    required this.localDataSource,
    required this.calculateResult,
  });

  @override
  Future<Quiz> getQuiz() async {
    try {
      final quizModel = await localDataSource.getQuiz();
      return quizModel.toDomain();
    } on QuizJsonParsingException catch (e) {
      throw JsonParsingFailure(e.message);
    } on QuizAssetException catch (e) {
      throw AssetFailure(e.message);
    } on QuizDataException catch (e) {
      throw DataFailure(e.message);
    } catch (e) {
      throw DataFailure('Unexpected error: $e');
    }
  }

  @override
  Future<QuizResult> submitQuiz(List<UserResponse> responses) async {
    try {
      final quiz = await getQuiz();
      final result = await calculateResult.call(
        CalculateResultParams(
          quiz: quiz,
          responses: responses,
        ),
      );
      return result;
    } catch (e) {
      throw DataFailure('Unexpected error submitting quiz: $e');
    }
  }

  @override
  Future<void> saveProgress(List<UserResponse> responses) async {
    try {
      // For now, we'll implement a simple local storage
      // In a real app, you might use SharedPreferences or a local database
    } catch (e) {
      throw DataFailure('Failed to save progress: $e');
    }
  }

  @override
  Future<List<UserResponse>> getProgress() async {
    try {
      // For now, return empty list
      // In a real app, you'd retrieve saved progress from local storage
      return [];
    } catch (e) {
      throw DataFailure('Failed to get progress: $e');
    }
  }
}
