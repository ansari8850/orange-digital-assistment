import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:assistment/data/models/quiz_model.dart';
import 'package:assistment/core/errors/exceptions.dart';

abstract class QuizLocalDataSource {
  Future<QuizModel> getQuiz();
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  const QuizLocalDataSourceImpl();

  @override
  Future<QuizModel> getQuiz() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/task.json',
      );
      final Map<String, dynamic> jsonMap =
          json.decode(jsonString) as Map<String, dynamic>;

      return QuizModel.fromJson(jsonMap);
    } on FormatException catch (e) {
      throw QuizJsonParsingException('Failed to parse JSON: ${e.message}');
    } catch (e) {
      throw QuizDataException('Unexpected error loading quiz data: $e');
    }
  }
}
