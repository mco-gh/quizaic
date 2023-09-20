import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/models/generator.dart';
import 'package:quizaic/models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizaic/views/home.dart';

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
  int curQuestion = 0;
  String playerSessionId = '';
  String sessionId = '';
  String runningQuizId = '';
  Quiz? playQuiz;
  String? playerName;
  bool revertToPlayPage = false;
  int respondedQuestion = -1;

  final Stream<QuerySnapshot> quizzesStream =
      FirebaseFirestore.instance.collection('quizzes').snapshots();
  Stream<DocumentSnapshot<Map<String, dynamic>>>? sessionStream;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? playerSessionStream;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? resultsStream;

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
        return quiz;
      }
    }
    return null;
  }

  void selectQuizData(id) {
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

  Future<bool> incQuestion(sessionId, curQuestion) async {
    curQuestion++;
    String body = '{"curQuestion": "$curQuestion"}';
    final response = await http
        .patch(Uri.parse('$apiUrl/sessions/$sessionId'), body: body, headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Question incremented.");
    } else {
      errorDialog('Failed to increment question.');
    }
    notifyListeners();
    return true;
  }

  void setPlayerName(name) {
    playerName = name;
    notifyListeners();
  }

  Future<bool> checkForSession() async {
    // check whether this person is already hosting a quiz.
    print('checkForSession()');
    final response = await http.get(Uri.parse('$apiUrl/sessions/me'), headers: {
      'Authorization': 'Bearer $idToken',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      // session already running for this user, set sessionId accordingly.
      var resp = json.decode(response.body);
      sessionId = resp["hostId"];
      runningQuizId = resp["quizId"];
      sessionStream = FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .snapshots();
      resultsStream = FirebaseFirestore.instance
          .collection('results')
          .doc(sessionId)
          .snapshots();

      print('Resuming session already in progress for this host: $sessionId.');
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> createSession(quizId) async {
    // Create a new session for this user.
    print('createSession($quizId)');
    Session session = Session(
      state: 'starting',
      quizId: quizId,
      synchronous: hostSynch == 'Synchronous' ? true : false,
      timeLimit: hostTimeLimit,
      survey: false,
      anonymous: hostAnonymous == 'Anonymous' ? true : false,
      randomizeQuestions: hostRandomizeQuestions == 'Yes' ? true : false,
      randomizeAnswers: hostRandomizeAnswers == 'Yes' ? true : false,
    );

    final response = await http.post(Uri.parse('$apiUrl/sessions'),
        body: jsonEncode(session),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var resp = json.decode(response.body);
      sessionId = resp["id"];
      runningQuizId = quizId;
      sessionStream = FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .snapshots();
      //Future.delayed(Duration(seconds: 1)).then((_) {
      resultsStream = FirebaseFirestore.instance
          .collection('results')
          .doc(sessionId)
          .snapshots();
      //});
      print('New session created: $sessionId.');
    } else if (response.statusCode == 403) {
      errorDialog(
          'Failed to create session for quiz $quizId due to authorization error, are you logged in?');
    } else {
      errorDialog('Failed to create session for quiz $quizId');
    }

    notifyListeners();
    return true;
  }

  Future<bool> stopHostQuiz() async {
    print('stopHostQuiz()');

    final response =
        await http.delete(Uri.parse('$apiUrl/sessions/$sessionId'), headers: {
      'Authorization': 'Bearer $idToken',
    });

    if (response.statusCode == 200 || response.statusCode == 204) {
      sessionId = '';
      runningQuizId = '';
      print("Quiz $runningQuizId stopped.");
    } else {
      errorDialog('Failed to stop quiz $runningQuizId');
    }
    notifyListeners();
    return true;
  }

  Future<bool> createOrUpdateQuiz(context, quiz) async {
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
    } else if (response.statusCode == 403) {
      errorDialog('$error due to permission error, are you logged in?');
    } else {
      errorDialog(error);
    }
    notifyListeners();
    return true;
  }

  Future<bool> deleteQuiz(context, id) async {
    final response = await http.delete(Uri.parse('$apiUrl/quizzes/$id'),
        headers: {'Authorization': 'Bearer $idToken'});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Quiz id $id deleted.");
    } else {
      errorDialog('Failed to delete quiz $id');
    }
    notifyListeners();
    return true;
  }

  Future<bool> registerPlayer() async {
    var body = '{"players.$playerName.score": 0}';
    print('body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/$playerSessionId'),
        body: body,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Player $playerName registered.");
    } else {
      if (response.statusCode == 409) {
        errorDialog('Player $playerName already registered for this quiz.');
      } else {
        errorDialog('Failed to register player $playerName');
      }
      revertToPlayPage = true;
    }
    notifyListeners();
    return true;
  }

  Future<bool> sendResponse(i) async {
    var body = '{"players.$playerName.score": 1}';
    print('body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/$playerSessionId'),
        body: body,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Sent response $i for player $playerName");
    } else {
      errorDialog('Failed to send response number $i for player $playerName');
    }
    notifyListeners();
    return true;
  }

  favoriteQuiz(id) async {
    notifyListeners();
  }

  Quiz? findQuizByPin(pin) {
    print('findSessionByPin($pin)');
    FirebaseFirestore.instance
        .collection('sessions')
        .where('pin', isEqualTo: pin)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          errorDialog('No session found with pin $pin.');
          playQuiz = null;
          notifyListeners();
          return null;
        } else if (querySnapshot.docs.length > 1) {
          errorDialog(
              'Multiple sessions with pin $pin, using first one found.');
        }
        var session = querySnapshot.docs[0].data();
        playerSessionId = session['hostId'];
        print('pin $pin led to session $playerSessionId');
        playQuiz = getQuiz(session['quizId']);
        print('session led to quiz ${playQuiz?.name}');
        playerSessionStream = FirebaseFirestore.instance
            .collection('sessions')
            .doc(playerSessionId)
            .snapshots();
        notifyListeners();
      },
      onError: (e) => errorDialog("Error completing: $e"),
    );
    return null;
  }

  Future<List<Quiz>> fetchQuizzes() async {
    print('fetchQuizzes using apiUrl: $apiUrl');

    final response = await http.get(Uri.parse('$apiUrl/quizzes'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      quizzes = List<Quiz>.from(l.map((model) => Quiz.fromJson(model)));
    } else {
      //errorDialog(context, 'Failed to fetch quizzes');
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
      //errorDialog(context, 'Failed to fetch generators');
    }
    notifyListeners();
    return generators;
  }
}
