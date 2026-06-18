import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:assistment/presentation/blocs/timer/timer_bloc.dart';
import 'package:assistment/services/service_locator.dart';
import 'package:assistment/presentation/pages/quiz_home/quiz_home_page.dart';
import 'package:assistment/presentation/pages/question/question_page.dart';
import 'package:assistment/presentation/pages/results/results_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizBloc>(
          create: (context) => sl<QuizBloc>(),
        ),
        BlocProvider<TimerBloc>(
          create: (context) => sl<TimerBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const QuizHomePage(),
          '/question': (context) => const QuestionPage(),
          '/results': (context) => const ResultsPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
