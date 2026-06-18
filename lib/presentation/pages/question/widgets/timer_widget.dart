import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/core/utils/quiz_date_utils.dart';
import 'package:assistment/presentation/blocs/timer/timer_bloc.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final timeString = QuizDateUtils.formatDuration(state.duration);
        final isRunning = state.status == TimerStatus.running;
        final isCompleted = state.status == TimerStatus.completed;
        final isCritical = state.duration <= 300 && state.duration > 0; // 5 minutes or less

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isCompleted 
                ? Colors.red.shade100
                : isCritical 
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCompleted 
                  ? Colors.red.shade300
                  : isCritical 
                      ? Colors.orange.shade300
                      : Colors.green.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCompleted 
                    ? Icons.timer_off
                    : isRunning 
                        ? Icons.timer
                        : Icons.hourglass_empty,
                size: 20,
                color: isCompleted 
                    ? Colors.red.shade700
                    : isCritical 
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                timeString,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted 
                      ? Colors.red.shade700
                      : isCritical 
                          ? Colors.orange.shade700
                          : Colors.green.shade700,
                ),
              ),
              if (isCompleted) ...[
                const SizedBox(width: 8),
                Text(
                  'TIME\'S UP!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
