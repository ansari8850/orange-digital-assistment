// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) => QuizModel(
  title: json['quiz_title'] as String,
  duration: (json['quiz_duration'] as num).toInt(),
  totalMarks: (json['total_marks'] as num).toInt(),
  passingMarks: (json['passing_marks'] as num).toInt(),
  instructions: json['instructions'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizModelToJson(QuizModel instance) => <String, dynamic>{
  'quiz_title': instance.title,
  'quiz_duration': instance.duration,
  'total_marks': instance.totalMarks,
  'passing_marks': instance.passingMarks,
  'instructions': instance.instructions,
  'questions': instance.questions,
};
