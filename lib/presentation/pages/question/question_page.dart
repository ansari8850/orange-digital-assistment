import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/core/constants/app_constants.dart';
import 'package:assistment/domain/entities/question.dart';
import 'package:assistment/domain/entities/user_response.dart';
import 'package:assistment/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:assistment/presentation/blocs/timer/timer_bloc.dart';
import 'package:assistment/presentation/pages/question/widgets/timer_widget.dart';
import 'package:assistment/presentation/pages/question/widgets/question_card.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state.status == QuizStatus.completed) {
              Navigator.of(context).pushReplacementNamed('/results');
            }
          },
        ),
        BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state.status == TimerStatus.completed) {
              context.read<QuizBloc>().add(TimerExpired());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          actions: const [
            TimerWidget(),
          ],
        ),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state.quiz == null) {
              return const Center(child: Text('No quiz loaded'));
            }

            final allQuestions = state.quiz!.allQuestions;
            if (state.currentQuestionIndex >= allQuestions.length) {
              return const Center(child: Text('Invalid question index'));
            }

            final currentQuestion = allQuestions[state.currentQuestionIndex];
            final currentResponse = state.responses.firstWhere(
              (response) => response.questionId == currentQuestion.id,
              orElse: () => UserResponse(
                questionId: currentQuestion.id,
                selectedAnswerIds: [],
                timestamp: DateTime.now(),
              ),
            );

            return Column(
              children: [
                _buildProgressBar(context, state),
                Expanded(
                  child: QuestionCard(
                    key: ValueKey(currentQuestion.id),
                    question: currentQuestion,
                    response: currentResponse,
                    onAnswerChanged: (selectedAnswerIds, textAnswer) {
                      context.read<QuizBloc>().add(
                        AnswerSubmitted(
                          questionId: currentQuestion.id,
                          selectedAnswerIds: selectedAnswerIds,
                          textAnswer: textAnswer,
                        ),
                      );
                    },
                  ),
                ),
                _buildNavigationButtons(context, state, currentQuestion),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, QuizState state) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Question ${state.currentQuestionIndex + 1} of ${state.totalQuestions}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${state.answeredQuestions} answered',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, QuizState state, Question currentQuestion) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          if (state.canGoBack)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.read<QuizBloc>().add(
                    QuestionNavigated(state.currentQuestionIndex - 1),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (state.canGoBack) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: state.canGoForward
                  ? () {
                      context.read<QuizBloc>().add(
                        QuestionNavigated(state.currentQuestionIndex + 1),
                      );
                    }
                  : () {
                      _submitQuiz(context, state);
                    },
              child: Text(state.canGoForward ? 'Next' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitQuiz(BuildContext context, QuizState state) {
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final timeTaken = ((endTime - state.startTime) / 1000).round();

    context.read<QuizBloc>().add(
      QuizSubmitted(
        responses: state.responses,
        timeTaken: timeTaken,
      ),
    );
  }


}
