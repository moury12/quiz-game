import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quiz_game/models/quiz_model.dart';
class QuizService{
  static Future<List<QuizModel>> getQuestionAnswerData() async {
    final response = await http.get(Uri.parse('https://herosapp.nyc3.digitaloceanspaces.com/quiz.json'));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> quizDataJson = jsonData['questions'];
      List<QuizModel> questions = quizDataJson.map((json) =>
          QuizModel.fromJson(json)).toList();
      questions.shuffle();
      return questions;
    } else {
      throw Exception('Failed to load quiz data');
    }
  }
}