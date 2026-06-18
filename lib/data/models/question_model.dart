import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/question.dart';
import 'answer_model.dart';

part 'question_model.g.dart';

enum QuestionTypeModel {
  @JsonValue('objective')
  objective,
  @JsonValue('subjective')
  subjective,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('true_false')
  trueFalse,
  @JsonValue('comprehension')
  comprehension,
}

@JsonSerializable()
class QuestionModel {
  @JsonKey(name: 'question_id')
  final String id;
  
  @JsonKey(name: 'question_type')
  final QuestionTypeModel type;
  
  @JsonKey(name: 'question_text')
  final String text;
  
  @JsonKey(name: 'options')
  final List<AnswerModel> options;
  
  @JsonKey(name: 'positive_marks')
  final double positiveMarks;
  
  @JsonKey(name: 'negative_marks')
  final double negativeMarks;
  
  @JsonKey(name: 'has_sub_questions')
  final bool hasSubQuestions;
  
  @JsonKey(name: 'sub_questions')
  final List<QuestionModel> subQuestions;
  
  @JsonKey(name: 'passage')
  final String? passage;
  
  @JsonKey(name: 'word_limit')
  final int? wordLimit;
  
  @JsonKey(name: 'answer_key')
  final String? answerKey;

  const QuestionModel({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    required this.positiveMarks,
    required this.negativeMarks,
    required this.hasSubQuestions,
    required this.subQuestions,
    this.passage,
    this.wordLimit,
    this.answerKey,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  Question toDomain() {
    return Question(
      id: id,
      type: _mapQuestionTypeModelToDomain(type),
      text: text,
      options: options.map((a) => a.toDomain()).toList(),
      positiveMarks: positiveMarks,
      negativeMarks: negativeMarks,
      hasSubQuestions: hasSubQuestions,
      subQuestions: subQuestions.map((q) => q.toDomain()).toList(),
      passage: passage,
      wordLimit: wordLimit,
      answerKey: answerKey,
    );
  }

  static QuestionModel fromDomain(Question question) {
    return QuestionModel(
      id: question.id,
      type: _mapQuestionTypeDomainToModel(question.type),
      text: question.text,
      options: question.options
          .map((a) => AnswerModel.fromDomain(a))
          .toList(),
      positiveMarks: question.positiveMarks,
      negativeMarks: question.negativeMarks,
      hasSubQuestions: question.hasSubQuestions,
      subQuestions: question.subQuestions
          .map((q) => QuestionModel.fromDomain(q))
          .toList(),
      passage: question.passage,
      wordLimit: question.wordLimit,
      answerKey: question.answerKey,
    );
  }

  static QuestionType _mapQuestionTypeModelToDomain(QuestionTypeModel type) {
    switch (type) {
      case QuestionTypeModel.objective:
        return QuestionType.objective;
      case QuestionTypeModel.subjective:
        return QuestionType.subjective;
      case QuestionTypeModel.multiSelect:
        return QuestionType.multiSelect;
      case QuestionTypeModel.trueFalse:
        return QuestionType.trueFalse;
      case QuestionTypeModel.comprehension:
        return QuestionType.comprehension;
    }
  }

  static QuestionTypeModel _mapQuestionTypeDomainToModel(QuestionType type) {
    switch (type) {
      case QuestionType.objective:
        return QuestionTypeModel.objective;
      case QuestionType.subjective:
        return QuestionTypeModel.subjective;
      case QuestionType.multiSelect:
        return QuestionTypeModel.multiSelect;
      case QuestionType.trueFalse:
        return QuestionTypeModel.trueFalse;
      case QuestionType.comprehension:
        return QuestionTypeModel.comprehension;
    }
  }
}
