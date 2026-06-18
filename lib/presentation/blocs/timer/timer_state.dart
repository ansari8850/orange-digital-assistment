import 'package:equatable/equatable.dart';

enum TimerStatus {
  initial,
  running,
  paused,
  completed,
  reset,
}

class TimerState extends Equatable {
  final int duration;
  final TimerStatus status;

  const TimerState({
    required this.duration,
    required this.status,
  });

  TimerState copyWith({
    int? duration,
    TimerStatus? status,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [duration, status];

  @override
  String toString() => 'TimerState(duration: $duration, status: $status)';
}
