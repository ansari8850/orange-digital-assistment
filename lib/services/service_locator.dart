import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../data/datasources/local/quiz_local_datasource.dart';
import '../data/repositories/quiz_repository_impl.dart';
import '../domain/repositories/quiz_repository.dart';
import '../domain/usecases/get_quiz.dart';
import '../domain/usecases/calculate_result.dart';
import '../presentation/blocs/quiz/quiz_bloc.dart';
import '../presentation/blocs/timer/timer_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      localDataSource: sl(),
      calculateResult: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetQuiz>(
    () => GetQuiz(sl()),
  );

  sl.registerLazySingleton<CalculateResult>(
    () => const CalculateResult(),
  );

  // BLoCs
  sl.registerFactory<QuizBloc>(
    () => QuizBloc(
      repository: sl(),
      getQuiz: sl(),
      calculateResult: sl(),
    ),
  );

  sl.registerFactory<TimerBloc>(
    () => TimerBloc(),
  );
}
