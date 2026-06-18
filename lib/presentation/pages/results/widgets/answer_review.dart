import 'package:flutter/material.dart';
import 'package:assistment/core/constants/app_constants.dart';
import 'package:assistment/domain/entities/quiz.dart';
import 'package:assistment/domain/entities/quiz_result.dart';

class AnswerReview extends StatelessWidget {
  final Quiz quiz;
  final QuizResult result;

  const AnswerReview({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answer Review',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildQuestionReviews(context),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionReviews(BuildContext context) {
    final allQuestions = _getAllQuestions(quiz.questions);
    final widgets = <Widget>[];

    for (int i = 0; i < allQuestions.length; i++) {
      final question = allQuestions[i];
      final questionResult = result.questionResults[question.id];

      if (questionResult != null) {
        widgets.add(_buildQuestionReview(context, question, questionResult, i + 1));
        if (i < allQuestions.length - 1) {
          widgets.add(const SizedBox(height: 12));
        }
      }
    }

    return widgets;
  }

  Widget _buildQuestionReview(
    BuildContext context,
    dynamic question,
    dynamic questionResult,
    int questionNumber,
  ) {
    final isCorrect = questionResult.isCorrect;
    final marksObtained = questionResult.marksObtained;
    final totalMarks = questionResult.totalMarks;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
                child: Text(
                  questionNumber.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
                size: 20,
              ),
              const Spacer(),
              Text(
                '${marksObtained.toStringAsFixed(1)}/$totalMarks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (questionResult.selectedAnswers.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Your answer: ${_formatSelectedAnswers(questionResult.selectedAnswers, question)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
          if (questionResult.textAnswer != null) ...[
            const SizedBox(height: 8),
            Text(
              'Your answer: ${questionResult.textAnswer}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatSelectedAnswers(List<String> selectedAnswerIds, dynamic question) {
    if (selectedAnswerIds.isEmpty) return 'Not answered';
    
    final selectedTexts = selectedAnswerIds.map((id) {
      final option = (question.options as Iterable)
          .where((opt) => opt.id == id)
          .firstOrNull;
      return option?.text ?? id;
    }).toList();
    
    return selectedTexts.join(', ');
  }

  List<dynamic> _getAllQuestions(List<dynamic> questions) {
    final allQuestions = <dynamic>[];
    
    for (final question in questions) {
      allQuestions.add(question);
      if (question.hasSubQuestions) {
        allQuestions.addAll(question.subQuestions);
      }
    }
    
    return allQuestions;
  }
}
