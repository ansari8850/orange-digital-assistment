import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistment/domain/entities/user_response.dart';
import 'package:assistment/domain/repositories/quiz_repository.dart';
import 'package:assistment/domain/usecases/get_quiz.dart';
import 'package:assistment/domain/usecases/calculate_result.dart';
import 'package:assistment/core/errors/failures.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

export 'quiz_event.dart';
export 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository repository;
  final GetQuiz getQuiz;
  final CalculateResult calculateResult;

  QuizBloc({
    required this.repository,
    required this.getQuiz,
    required this.calculateResult,
  }) : super(const QuizState(
          status: QuizStatus.initial,
          currentQuestionIndex: 0,
          responses: [],
          errorMessage: '',
          startTime: 0,
          endTime: 0,
        )) {
    on<QuizStarted>(_onQuizStarted);
    on<QuizLoaded>(_onQuizLoaded);
    on<QuestionNavigated>(_onQuestionNavigated);
    on<AnswerSubmitted>(_onAnswerSubmitted);
    on<QuizSubmitted>(_onQuizSubmitted);
    on<QuizCompleted>(_onQuizCompleted);
    on<QuizReset>(_onQuizReset);
    on<TimerExpired>(_onTimerExpired);
  }

  Future<void> _onQuizStarted(QuizStarted event, Emitter<QuizState> emit) async {
    emit(state.copyWith(status: QuizStatus.loading));
    
    try {
      final quiz = await getQuiz();
      emit(state.copyWith(
        status: QuizStatus.ready,
        quiz: quiz,
        currentQuestionIndex: 0,
        responses: [],
        startTime: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: _mapFailureToMessage(e),
      ));
    }
  }

  void _onQuizLoaded(QuizLoaded event, Emitter<QuizState> emit) {
    emit(state.copyWith(
      status: QuizStatus.inProgress,
      startTime: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _onQuestionNavigated(QuestionNavigated event, Emitter<QuizState> emit) {
    if (state.quiz != null) {
      final totalQuestions = state.quiz!.allQuestions.length;
      if (event.questionIndex >= 0 && event.questionIndex < totalQuestions) {
        emit(state.copyWith(currentQuestionIndex: event.questionIndex));
      }
    }
  }

  void _onAnswerSubmitted(AnswerSubmitted event, Emitter<QuizState> emit) {
    final existingResponseIndex = state.responses.indexWhere(
      (response) => response.questionId == event.questionId,
    );

    final newResponse = UserResponse(
      questionId: event.questionId,
      selectedAnswerIds: event.selectedAnswerIds,
      textAnswer: event.textAnswer,
      timestamp: DateTime.now(),
    );

    final updatedResponses = List<UserResponse>.from(state.responses);
    
    if (existingResponseIndex != -1) {
      updatedResponses[existingResponseIndex] = newResponse;
    } else {
      updatedResponses.add(newResponse);
    }

    emit(state.copyWith(responses: updatedResponses));
  }

  Future<void> _onQuizSubmitted(QuizSubmitted event, Emitter<QuizState> emit) async {
    if (state.quiz == null) return;

    emit(state.copyWith(status: QuizStatus.loading));
    
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final timeTaken = ((endTime - state.startTime) / 1000).round();

    try {
      final quizResult = await calculateResult(
        CalculateResultParams(
          quiz: state.quiz!,
          responses: event.responses,
          timeTaken: timeTaken,
        ),
      );

      emit(state.copyWith(
        status: QuizStatus.completed,
        result: quizResult,
        endTime: endTime,
      ));
      add(QuizCompleted(quizResult));
    } catch (e) {
      emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: _mapFailureToMessage(e),
      ));
    }
  }

  void _onQuizCompleted(QuizCompleted event, Emitter<QuizState> emit) {
    // State already updated in _onQuizSubmitted
  }

  void _onQuizReset(QuizReset event, Emitter<QuizState> emit) {
    emit(const QuizState(
      status: QuizStatus.initial,
      currentQuestionIndex: 0,
      responses: [],
      errorMessage: '',
      startTime: 0,
      endTime: 0,
    ));
  }

  void _onTimerExpired(TimerExpired event, Emitter<QuizState> emit) {
    if (state.status == QuizStatus.inProgress) {
      add(QuizSubmitted(
        responses: state.responses,
        timeTaken: state.quiz?.duration ?? 0,
      ));
    }
  }



  String _mapFailureToMessage(dynamic error) {
    if (error is Failure) {
      switch (error.runtimeType) {
        case DataFailure:
          return error.message;
        case JsonParsingFailure:
          return 'Failed to parse quiz data';
        case AssetFailure:
          return 'Failed to load quiz file';
        case NetworkFailure:
          return 'Network error occurred';
        case ServerFailure:
          return 'Server error occurred';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred: $error';
  }
}
