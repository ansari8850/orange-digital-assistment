import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerCompleted extends TimerEvent {}
