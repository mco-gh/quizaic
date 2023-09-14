import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/models/generator.dart';
import 'package:quizaic/models/results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> difficulty = ["Trivial", "Easy", "Medium", "Hard", "Killer"];

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();
  static const apiUrl =
      bool.hasEnvironment('API_URL') ? String.fromEnvironment('API_URL') : null;
  static const redirectUri = bool.hasEnvironment('REDIRECT_URI')
      ? String.fromEnvironment('REDIRECT_URI')
      : null;
  static const clientId = bool.hasEnvironment('CLIENT_ID')
      ? String.fromEnvironment('CLIENT_ID')
      : null;
  var photoUrl = '';
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
    print("apiUrl: $apiUrl");
    print("redirectUri: $redirectUri");
    print("clientId: $clientId");
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

  Future<bool> startQuiz(quiz) async {
    print('startQuiz: $quiz');
    Results results = Results(
      synchronous: hostSynch == 'Synchronous' ? true : false,
      timeLimit: hostTimeLimit,
      survey: false,
      anonymous: hostAnonymous == 'Anonymous' ? true : false,
      randomizeQuestions: hostRandomizeQuestions == 'Yes' ? true : false,
      randomizeAnswers: hostRandomizeAnswers == 'Yes' ? true : false,
    );

    final response = await http.post(Uri.parse('$apiUrl/results'),
        body: jsonEncode(results),
        headers: {'Authorization': 'Bearer $idToken'});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Quiz id ${quiz.id} started.");
    } else {
      throw Exception('Failed to start quiz ${quiz.id}');
    }
    notifyListeners();
    return true;
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
    print('fetchQuizzes using apiUrl: $apiUrl');

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
    print('fetchGenerators using apiUrl: $apiUrl');
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
