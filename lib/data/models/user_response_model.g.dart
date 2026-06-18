// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseModel _$UserResponseModelFromJson(Map<String, dynamic> json) =>
    UserResponseModel(
      questionId: json['question_id'] as String,
      selectedAnswerIds: (json['selected_answer_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      textAnswer: json['text_answer'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'selected_answer_ids': instance.selectedAnswerIds,
      'text_answer': instance.textAnswer,
      'timestamp': instance.timestamp.toIso8601String(),
    };
