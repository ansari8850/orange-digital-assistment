import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'timer_event.dart';
import 'timer_state.dart';

export 'timer_event.dart';
export 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerState(duration: 0, status: TimerStatus.initial)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerCompleted>(_onCompleted);
  }

  static const int _tickInterval = 1;
  StreamSubscription<int>? _timerSubscription;

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _timerSubscription?.cancel();
    emit(state.copyWith(duration: event.duration, status: TimerStatus.running));
    
    _timerSubscription = Stream.periodic(
      const Duration(seconds: _tickInterval),
      (count) => event.duration - count - 1,
    ).listen(
      (duration) {
        add(TimerTicked(duration));
      },
    );
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(state.copyWith(duration: event.duration));
    } else {
      _timerSubscription?.cancel();
      emit(state.copyWith(duration: 0, status: TimerStatus.completed));
      add(TimerCompleted());
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _timerSubscription?.pause();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    _timerSubscription?.resume();
    emit(state.copyWith(status: TimerStatus.running));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _timerSubscription?.cancel();
    emit(const TimerState(duration: 0, status: TimerStatus.reset));
  }

  void _onCompleted(TimerCompleted event, Emitter<TimerState> emit) {
    _timerSubscription?.cancel();
    emit(state.copyWith(status: TimerStatus.completed));
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
