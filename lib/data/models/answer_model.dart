import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/answer.dart';

part 'answer_model.g.dart';

@JsonSerializable()
class AnswerModel {
  @JsonKey(name: 'option_text')
  final String text;
  
  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  const AnswerModel({
    required this.text,
    required this.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);

  Answer toDomain() {
    return Answer(
      id: text.hashCode.toString(), // Generate ID from text hash
      text: text,
      isCorrect: isCorrect,
    );
  }

  static AnswerModel fromDomain(Answer answer) {
    return AnswerModel(
      text: answer.text,
      isCorrect: answer.isCorrect,
    );
  }
}
