import 'package:get_it/get_it.dart';
import 'package:assistment/data/datasources/local/quiz_local_datasource.dart';
import 'package:assistment/data/repositories/quiz_repository_impl.dart';
import 'package:assistment/domain/repositories/quiz_repository.dart';
import 'package:assistment/domain/usecases/get_quiz.dart';
import 'package:assistment/domain/usecases/calculate_result.dart';
import 'package:assistment/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:assistment/presentation/blocs/timer/timer_bloc.dart';

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
