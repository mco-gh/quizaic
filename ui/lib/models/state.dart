import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizrd/models/quiz.dart';
import 'package:quizrd/models/generator.dart';

enum Difficulty { trivial, easy, medium, hard, killer }

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  var photoUrl = '';
  var apiUrl = 'https://content-api-754gexfiiq-uc.a.run.app';
  List<Quiz> quizzes = [];
  List<Generator> generators = [];
  String selectedQuizName = '';
  String selectedGenerator = '';
  String selectedTopic = '';
  int? selectedNumQuestions;
  String selectedDifficulty = '';

  MyAppState() {
    futureFetchQuizzes = fetchQuizzes();
    futureFetchGenerators = fetchGenerators();
  }

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

  Future<List<Generator>> fetchGenerators() async {
    final response = await http.get(Uri.parse('$apiUrl/generators'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      generators =
          List<Generator>.from(l.map((model) => Generator.fromJson(model)));
    } else {
      throw Exception('Failed to fetch generators');
    }
    notifyListeners();
    return generators;
  }
}
