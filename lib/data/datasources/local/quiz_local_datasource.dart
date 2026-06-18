import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart';
import '../../models/quiz_model.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';

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
