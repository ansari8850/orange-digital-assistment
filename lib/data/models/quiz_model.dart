import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/quiz.dart';
import 'question_model.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
class QuizModel {
  @JsonKey(name: 'quiz_title')
  final String title;
  
  @JsonKey(name: 'quiz_duration')
  final int duration;
  
  @JsonKey(name: 'total_marks')
  final int totalMarks;
  
  @JsonKey(name: 'passing_marks')
  final int passingMarks;
  
  @JsonKey(name: 'instructions')
  final String instructions;
  
  @JsonKey(name: 'questions')
  final List<QuestionModel> questions;

  const QuizModel({
    required this.title,
    required this.duration,
    required this.totalMarks,
    required this.passingMarks,
    required this.instructions,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizModelToJson(this);

  Quiz toDomain() {
    return Quiz(
      title: title,
      duration: duration,
      totalMarks: totalMarks,
      passingMarks: passingMarks,
      instructions: instructions,
      questions: questions.map((q) => q.toDomain()).toList(),
    );
  }

  static QuizModel fromDomain(Quiz quiz) {
    return QuizModel(
      title: quiz.title,
      duration: quiz.duration,
      totalMarks: quiz.totalMarks,
      passingMarks: quiz.passingMarks,
      instructions: quiz.instructions,
      questions: quiz.questions
          .map((q) => QuestionModel.fromDomain(q))
          .toList(),
    );
  }
}
