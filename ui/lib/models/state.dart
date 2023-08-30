import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizrd/models/quiz.dart';
import 'package:quizrd/models/generator.dart';

List<String> difficulty = ["Trivial", "Easy", "Medium", "Hard", "Killer"];

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  var photoUrl = '';
  //var apiUrl = 'https://content-api-754gexfiiq-uc.a.run.app';
  var apiUrl = 'http://localhost:8081';

  String? idToken = '';
  List<Quiz> quizzes = [];
  List<Generator> generators = [];
  String selectedQuizName = '';
  String selectedAnswerFormat = 'Select generator to see formats';
  String selectedGenerator = '';
  String selectedTopic = 'Select generator to see topics';
  String selectedNumQuestions = '';
  String selectedDifficulty = '';
  String editQuizId = '';

  MyAppState() {
    futureFetchQuizzes = fetchQuizzes();
    futureFetchGenerators = fetchGenerators();
  }

  void getQuiz(id) {
    for (var quiz in quizzes) {
      if (quiz.id == id) {
        selectedQuizName = quiz.name;
        selectedAnswerFormat = quiz.answerFormat;
        selectedGenerator = quiz.generator;
        selectedTopic = quiz.topic;
        selectedNumQuestions = quiz.numQuestions;
        selectedDifficulty = difficulty[int.parse(quiz.difficulty) - 1];
      }
    }
  }

  Future<bool> createQuiz() async {
    var quiz = jsonEncode(Quiz(
        // provided by quiz creator (in order of appearance on create quiz form)
        name: selectedQuizName,
        generator: selectedGenerator,
        answerFormat: selectedAnswerFormat,
        topic: selectedTopic,
        numQuestions: selectedNumQuestions,
        difficulty: selectedDifficulty));

    final response = await http.post(Uri.parse('$apiUrl/quizzes'),
        body: quiz,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Quiz created.");
    } else {
      throw Exception('Failed to create quiz');
    }
    notifyListeners();
    return true;
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
    final response = await http.delete(Uri.parse('$apiUrl/quizzes/$id'),
        headers: {'Authorization': 'Bearer $idToken'});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Quiz id $id deleted.");
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
