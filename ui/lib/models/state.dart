import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/models/generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> difficulty = ["Trivial", "Easy", "Medium", "Hard", "Killer"];

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  var photoUrl = '';
  //var apiUrl = 'https://content-api-754gexfiiq-uc.a.run.app';
  var apiUrl = 'http://localhost:8081';

  var selectedIndex = 0;
  var selectedPageIndex = 0;

  String? idToken = '';
  List<Quiz> quizzes = [];
  List<Generator> generators = [];
  String selectedQuizName = '';
  String selectedAnswerFormat = 'Select generator to see formats';
  String selectedGenerator = '';
  String selectedTopic = 'Select generator to see topics';
  String selectedNumQuestions = '';
  String selectedDifficulty = '';

  String hostSynch = 'Synchronous';
  String hostTimeLimit = '30';
  String hostType = 'Quiz';
  String hostAnonymous = 'Anonymous';
  String hostRandomizeQuestions = 'Yes';
  String hostRandomizeAnswers = 'Yes';

  final Stream<QuerySnapshot> quizzesStream =
      FirebaseFirestore.instance.collection('quizzes').snapshots();

  MyAppState() {
    futureFetchQuizzes = fetchQuizzes();
    futureFetchGenerators = fetchGenerators();
    quizzesStream.listen((event) {
      print("quizzes changed!");
      fetchQuizzes();
      notifyListeners();
    });
  }

  Quiz? getQuiz(id) {
    for (var quiz in quizzes) {
      if (quiz.id == id) {
        selectedQuizName = quiz.name;
        selectedAnswerFormat = quiz.answerFormat;
        selectedGenerator = quiz.generator;
        selectedTopic = quiz.topic;
        selectedNumQuestions = quiz.numQuestions;
        selectedDifficulty = difficulty[int.parse(quiz.difficulty) - 1];
        return quiz;
      }
    }
    return null;
  }

  Future<bool> createOrUpdateQuiz(quiz) async {
    int dnum = difficulty.indexOf(selectedDifficulty);
    String dstr = (dnum + 1).toString();
    Quiz tmpQuiz = Quiz(
        name: '',
        generator: '',
        answerFormat: '',
        topic: '',
        numQuestions: '0',
        difficulty: '1');

    if (quiz != null && quiz.id != '') {
      String json = jsonEncode(quiz.toJson());
      tmpQuiz = Quiz.fromJson(jsonDecode(json));
    }

    tmpQuiz.name = selectedQuizName;
    tmpQuiz.generator = selectedGenerator;
    tmpQuiz.answerFormat = selectedAnswerFormat;
    tmpQuiz.topic = selectedTopic;
    tmpQuiz.numQuestions = selectedNumQuestions;
    tmpQuiz.difficulty = dstr;

    print('quiz: $tmpQuiz');
    String url = '';
    String confirmation = '';
    String error = '';
    var method = http.post;

    if (quiz == null) {
      url = '$apiUrl/quizzes';
      confirmation = 'Quiz created.';
      error = 'Failed to create quiz.';
      method = http.post;
    } else if (quiz.id == '') {
      url = '$apiUrl/quizzes';
      confirmation = 'Quiz cloned.';
      error = 'Failed to clone quiz.';
      method = http.post;
    } else {
      url = '$apiUrl/quizzes/${quiz.id}';
      confirmation = 'Quiz updated.';
      error = 'Failed to update quiz.';
      method = http.patch;
    }
    final response = await method(Uri.parse(url),
        body: jsonEncode(tmpQuiz),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(confirmation);
    } else {
      throw Exception(error);
    }
    notifyListeners();
    return true;
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
