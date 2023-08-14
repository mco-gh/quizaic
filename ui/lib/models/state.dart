import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizrd/models/quiz.dart';

class AppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  var photoUrl = '';
  var apiUrl = 'https://content-api-754gexfiiq-uc.a.run.app';
  List<Quiz> quizzes = [];

  createQuiz(id) async {
    notifyListeners();
  }

  cloneQuiz(quiz) async {
    notifyListeners();
  }

  editQuiz(quiz) async {
    notifyListeners();
  }

  updateQuiz(quiz) async {
    notifyListeners();
  }

  Future<bool> deleteQuiz(id) async {
    final response = await http.post(Uri.parse('$apiUrl/quizzes/$id/delete'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      quizzes = List<Quiz>.from(l.map((model) => Quiz.fromJson(model)));
    } else {
      throw Exception('Failed to delete quiz $id');
    }
    notifyListeners();
    return true;
  }

  favoriteQuiz(id) async {
    notifyListeners();
  }

  hostQuiz(id) async {
    notifyListeners();
  }

  playQuiz(id) async {
    notifyListeners();
  }

/*
  @override
  void initState() {
    super.initState();
    futureQuiz = fetchQuiz();
  }
*/

  Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse('$apiUrl/quizzes'));

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
