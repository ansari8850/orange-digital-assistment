// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['question_id'] as String,
      type: $enumDecode(_$QuestionTypeModelEnumMap, json['question_type']),
      text: json['question_text'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      positiveMarks: (json['positive_marks'] as num).toDouble(),
      negativeMarks: (json['negative_marks'] as num).toDouble(),
      hasSubQuestions: json['has_sub_questions'] as bool? ?? false,
      subQuestions: (json['sub_questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      passage: json['passage'] as String?,
      wordLimit: (json['word_limit'] as num?)?.toInt(),
      answerKey: json['answer_key'] as String?,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'question_id': instance.id,
      'question_type': _$QuestionTypeModelEnumMap[instance.type]!,
      'question_text': instance.text,
      'options': instance.options,
      'positive_marks': instance.positiveMarks,
      'negative_marks': instance.negativeMarks,
      'has_sub_questions': instance.hasSubQuestions,
      'sub_questions': instance.subQuestions,
      'passage': instance.passage,
      'word_limit': instance.wordLimit,
      'answer_key': instance.answerKey,
    };

const _$QuestionTypeModelEnumMap = {
  QuestionTypeModel.objective: 'objective',
  QuestionTypeModel.subjective: 'subjective',
  QuestionTypeModel.multiSelect: 'multi_select',
  QuestionTypeModel.trueFalse: 'true_false',
  QuestionTypeModel.comprehension: 'comprehension',
};
