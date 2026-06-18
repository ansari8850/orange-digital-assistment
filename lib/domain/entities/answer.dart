import 'package:equatable/equatable.dart';

class Answer extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;

  const Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [id, text, isCorrect];

  Answer copyWith({
    String? id,
    String? text,
    bool? isCorrect,
  }) {
    return Answer(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
