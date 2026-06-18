import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_response.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  @JsonKey(name: 'question_id')
  final String questionId;
  
  @JsonKey(name: 'selected_answer_ids')
  final List<String> selectedAnswerIds;
  
  @JsonKey(name: 'text_answer')
  final String? textAnswer;
  
  @JsonKey(name: 'timestamp')
  final DateTime timestamp;

  const UserResponseModel({
    required this.questionId,
    required this.selectedAnswerIds,
    this.textAnswer,
    required this.timestamp,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);

  UserResponse toDomain() {
    return UserResponse(
      questionId: questionId,
      selectedAnswerIds: selectedAnswerIds,
      textAnswer: textAnswer,
      timestamp: timestamp,
    );
  }

  static UserResponseModel fromDomain(UserResponse response) {
    return UserResponseModel(
      questionId: response.questionId,
      selectedAnswerIds: response.selectedAnswerIds,
      textAnswer: response.textAnswer,
      timestamp: response.timestamp,
    );
  }
}
