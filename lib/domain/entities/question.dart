import 'package:equatable/equatable.dart';
import 'answer.dart';

enum QuestionType {
  objective,
  subjective,
  multiSelect,
  trueFalse,
  comprehension,
}

class Question extends Equatable {
  final String id;
  final QuestionType type;
  final String text;
  final List<Answer> options;
  final double positiveMarks;
  final double negativeMarks;
  final bool hasSubQuestions;
  final List<Question> subQuestions;
  final String? passage;
  final int? wordLimit;
  final String? answerKey;

  const Question({
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

  @override
  List<Object?> get props => [
        id,
        type,
        text,
        options,
        positiveMarks,
        negativeMarks,
        hasSubQuestions,
        subQuestions,
        passage,
        wordLimit,
        answerKey,
      ];

  bool get isSubjective => type == QuestionType.subjective;
  bool get isObjective => type == QuestionType.objective;
  bool get isMultiSelect => type == QuestionType.multiSelect;
  bool get isTrueFalse => type == QuestionType.trueFalse;
  bool get isComprehension => type == QuestionType.comprehension;

  Question copyWith({
    String? id,
    QuestionType? type,
    String? text,
    List<Answer>? options,
    double? positiveMarks,
    double? negativeMarks,
    bool? hasSubQuestions,
    List<Question>? subQuestions,
    String? passage,
    int? wordLimit,
    String? answerKey,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      options: options ?? this.options,
      positiveMarks: positiveMarks ?? this.positiveMarks,
      negativeMarks: negativeMarks ?? this.negativeMarks,
      hasSubQuestions: hasSubQuestions ?? this.hasSubQuestions,
      subQuestions: subQuestions ?? this.subQuestions,
      passage: passage ?? this.passage,
      wordLimit: wordLimit ?? this.wordLimit,
      answerKey: answerKey ?? this.answerKey,
    );
  }
}
