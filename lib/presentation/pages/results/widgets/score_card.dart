import 'package:flutter/material.dart';
import 'package:assistment/core/constants/app_constants.dart';
import 'package:assistment/core/utils/quiz_date_utils.dart';
import 'package:assistment/domain/entities/quiz_result.dart';

class ScoreCard extends StatelessWidget {
  final QuizResult result;

  const ScoreCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: result.passed
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                result.passed ? Icons.check_circle : Icons.cancel,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                result.passed ? 'PASSED' : 'FAILED',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
            child: Column(
              children: [
                _buildScoreRow(
                  context,
                  'Your Score',
                  '${result.totalScore}/${result.maxScore}',
                  Icons.star,
                ),
                const Divider(height: 24),
                _buildScoreRow(
                  context,
                  'Percentage',
                  '${result.percentage.toStringAsFixed(1)}%',
                  Icons.percent,
                ),
                const Divider(height: 24),
                _buildScoreRow(
                  context,
                  'Time Taken',
                  QuizDateUtils.formatTimeTaken(result.timeTaken),
                  Icons.timer,
                ),
                const Divider(height: 24),
                _buildScoreRow(
                  context,
                  'Questions Attempted',
                  '${result.attemptedQuestions}/${result.totalQuestions}',
                  Icons.help_outline,
                ),
                const Divider(height: 24),
                _buildScoreRow(
                  context,
                  'Correct Answers',
                  '${result.correctAnswers}',
                  Icons.check_circle_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: result.passed ? Colors.green.shade700 : Colors.red.shade700,
        ),
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
            color: result.passed ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}
