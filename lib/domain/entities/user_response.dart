import 'package:equatable/equatable.dart';

class UserResponse extends Equatable {
  final String questionId;
  final List<String> selectedAnswerIds;
  final String? textAnswer;
  final DateTime timestamp;

  const UserResponse({
    required this.questionId,
    required this.selectedAnswerIds,
    this.textAnswer,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        questionId,
        selectedAnswerIds,
        textAnswer,
        timestamp,
      ];

  bool get hasAnswer => selectedAnswerIds.isNotEmpty || textAnswer != null;

  UserResponse copyWith({
    String? questionId,
    List<String>? selectedAnswerIds,
    String? textAnswer,
    DateTime? timestamp,
  }) {
    return UserResponse(
      questionId: questionId ?? this.questionId,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      textAnswer: textAnswer ?? this.textAnswer,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
