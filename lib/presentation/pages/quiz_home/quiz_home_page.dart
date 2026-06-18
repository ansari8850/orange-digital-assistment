import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/core/constants/app_constants.dart';
import 'package:assistment/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:assistment/presentation/blocs/timer/timer_bloc.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state.status == QuizStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == QuizStatus.inProgress) {
            Navigator.of(context).pushReplacementNamed('/question');
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case QuizStatus.initial:
              return _buildInitialContent(context);
            case QuizStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case QuizStatus.ready:
              return _buildReadyContent(context, state);
            case QuizStatus.inProgress:
            case QuizStatus.completed:
              return const Center(child: CircularProgressIndicator());
            case QuizStatus.error:
              return _buildErrorContent(context, state);
          }
        },
      ),
    );
  }

  Widget _buildInitialContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz,
            size: 120,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to Quiz App',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Test your knowledge with our interactive quiz system',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => context.read<QuizBloc>().add(QuizStarted()),
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyContent(BuildContext context, QuizState state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.quiz!.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.quiz!.instructions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildQuizInfo(context, state),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              final quiz = state.quiz!;
              context.read<TimerBloc>().add(TimerStarted(quiz.duration));
              context.read<QuizBloc>().add(QuizLoaded(
                quizTitle: quiz.title,
                totalQuestions: quiz.allQuestions.length,
                duration: quiz.duration,
              ));
            },
            child: const Text('Begin Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfo(BuildContext context, QuizState state) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          'Total Questions',
          '${state.totalQuestions}',
          Icons.help_outline,
        ),
        _buildInfoRow(
          context,
          'Duration',
          '${(state.quiz!.duration / 60).round()} minutes',
          Icons.timer_outlined,
        ),
        _buildInfoRow(
          context,
          'Total Marks',
          '${state.quiz!.totalMarks}',
          Icons.star_outline,
        ),
        _buildInfoRow(
          context,
          'Passing Marks',
          '${state.quiz!.passingMarks}',
          Icons.check_circle_outline,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, QuizState state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.read<QuizBloc>().add(QuizStarted()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }


}
