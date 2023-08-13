import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizrd/models/quiz.dart';

class AppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  var photoUrl = '';
  var apiUrl = 'https://content-api-754gexfiiq-uc.a.run.app/quizzes';
  List<Quiz> quizzes = [];

  createQuiz(id) async {
    notifyListeners();
  }

  cloneQuiz(quiz) async {
    notifyListeners();
  }

  updateQuiz(quiz) async {
    notifyListeners();
  }

  deleteQuiz(id) async {
    notifyListeners();
  }

  Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      quizzes = List<Quiz>.from(l.map((model) => Quiz.fromJson(model)));
    } else {
      throw Exception('Failed to fetch quizzes');
    }
    notifyListeners();
    return quizzes;
  }
}
