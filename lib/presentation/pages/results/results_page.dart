import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/core/constants/app_constants.dart';
import 'package:assistment/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:assistment/presentation/pages/results/widgets/score_card.dart';
import 'package:assistment/presentation/pages/results/widgets/answer_review.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          }
        },
        builder: (context, state) {
          if (state.result == null) {
            return const Center(
              child: Text('No results available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreCard(result: state.result!),
                const SizedBox(height: 24),
                AnswerReview(
                  quiz: state.quiz!,
                  result: state.result!,
                ),
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<QuizBloc>().add(QuizReset());
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text('Start New Quiz'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            context.read<QuizBloc>().add(QuizReset());
            Navigator.of(context).pushReplacementNamed('/');
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          ),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}
