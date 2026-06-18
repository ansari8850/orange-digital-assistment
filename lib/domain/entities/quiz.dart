import 'package:equatable/equatable.dart';
import 'question.dart';

class Quiz extends Equatable {
  final String title;
  final int duration;
  final int totalMarks;
  final int passingMarks;
  final String instructions;
  final List<Question> questions;

  const Quiz({
    required this.title,
    required this.duration,
    required this.totalMarks,
    required this.passingMarks,
    required this.instructions,
    required this.questions,
  });

  List<Question> get allQuestions {
    final list = <Question>[];
    for (final question in questions) {
      if (question.hasSubQuestions) {
        for (final subQ in question.subQuestions) {
          list.add(subQ.copyWith(
            passage: question.passage,
          ));
        }
      } else {
        list.add(question);
      }
    }
    return list;
  }

  @override
  List<Object?> get props => [
        title,
        duration,
        totalMarks,
        passingMarks,
        instructions,
        questions,
      ];

  Quiz copyWith({
    String? title,
    int? duration,
    int? totalMarks,
    int? passingMarks,
    String? instructions,
    List<Question>? questions,
  }) {
    return Quiz(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      totalMarks: totalMarks ?? this.totalMarks,
      passingMarks: passingMarks ?? this.passingMarks,
      instructions: instructions ?? this.instructions,
      questions: questions ?? this.questions,
    );
  }
}
