import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/models/generator.dart';
import 'package:quizaic/models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizaic/views/home.dart';
import 'package:quizaic/const.dart';
import 'package:localstorage/localstorage.dart';

class SelectedQuiz {
  String name = '';
  String answerFormat = 'Select generator to see formats';
  String generator = '';
  String topic = 'Select generator to see topics';
  String numQuestions = '';
  String difficulty = '';
}

class HostedQuiz {
  String synch = 'Synchronous';
  String timeLimit = '30';
  String type = 'Quiz';
  String anonymous = 'Anonymous';
  String randomizeQuestions = 'Yes';
  String randomizeAnswers = 'Yes';
}

class PlayedQuiz {
  Quiz? quiz;
  String name = '';
  String pin = '';
}

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  final LocalStorage storage = LocalStorage(appName);

  var photoUrl = '';
  var selectedIndex = 0;
  var selectedPageIndex = 0;
  String? idToken = '';
  List<Quiz> quizzes = [];
  List<Generator> generators = [];

  SelectedQuiz selectedQuiz = SelectedQuiz();
  HostedQuiz hostedQuiz = HostedQuiz();
  PlayedQuiz playedQuiz = PlayedQuiz();

  int curQuestion = 0;
  String playerSessionId = '';
  String sessionId = '';
  String runningQuizId = '';
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
    });
  }

  String? getNameByPin(pin) {
    return storage.getItem(pin);
  }

  Future<List<Quiz>> fetchQuizzes() async {
    print('fetchQuizzes using apiUrl: $apiUrl');
    final response = await http.get(Uri.parse('$apiUrl/quizzes'));
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      quizzes = List<Quiz>.from(l.map((model) => Quiz.fromJson(model)));
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
    }
    return generators;
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
        selectedQuiz.name = quiz.name;
        selectedQuiz.answerFormat = quiz.answerFormat;
        selectedQuiz.generator = quiz.generator;
        selectedQuiz.topic = quiz.topic;
        selectedQuiz.numQuestions = quiz.numQuestions;
        selectedQuiz.difficulty =
            difficultyLevel[int.parse(quiz.difficulty) - 1];
      }
    }
  }

  Future<bool> incQuestion(sessionId, curQuestion, numQuestions) async {
    if (curQuestion >= numQuestions - 1) {
      errorDialog('Reached end of quiz, stop quiz to proceed.');
      return true;
    }
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
      synchronous: hostedQuiz.synch == 'Synchronous' ? true : false,
      timeLimit: hostedQuiz.timeLimit,
      survey: false,
      anonymous: hostedQuiz.anonymous == 'Anonymous' ? true : false,
      randomizeQuestions: hostedQuiz.randomizeQuestions == 'Yes' ? true : false,
      randomizeAnswers: hostedQuiz.randomizeAnswers == 'Yes' ? true : false,
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
    int dnum = difficultyLevel.indexOf(selectedQuiz.difficulty);
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

    tmpQuiz.name = selectedQuiz.name;
    tmpQuiz.generator = selectedQuiz.generator;
    tmpQuiz.answerFormat = selectedQuiz.answerFormat;
    tmpQuiz.topic = selectedQuiz.topic;
    tmpQuiz.numQuestions = selectedQuiz.numQuestions;
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

  Future<bool> registerPlayer(name, router) async {
    var body = '{"players.$name.score": 0}';
    print('name: $name, body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/$playerSessionId'),
        body: body,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      playedQuiz.name = name;
      storage.setItem(playedQuiz.pin, playedQuiz.name);
      print("Player ${playedQuiz.name} registered.");
      router.go('/quiz');
    } else {
      if (response.statusCode == 409) {
        errorDialog('Player $name already registered for this quiz.');
      } else {
        errorDialog('Failed to register player $name');
      }
    }
    notifyListeners();
    return true;
  }

  Future<bool> sendResponse(i) async {
    var body = '{"players.${playedQuiz.name}.score": 1}';
    print('body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/$playerSessionId'),
        body: body,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Sent response $i for player ${playedQuiz.name}");
    } else {
      errorDialog(
          'Failed to send response number $i for player ${playedQuiz.name}');
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
        print('querySnapshot.docs: ${querySnapshot.docs}');
        if (querySnapshot.docs.isEmpty) {
          errorDialog('No session found with pin $pin.');
          playedQuiz.quiz = null;
          playedQuiz.pin = '';
          playedQuiz.name = '';
          notifyListeners();
          return null;
        } else if (querySnapshot.docs.length > 1) {
          errorDialog(
              'Multiple sessions with pin $pin, using first one found.');
        }
        var session = querySnapshot.docs[0].data();
        playerSessionId = session['hostId'];
        print('pin $pin led to session $playerSessionId');
        playedQuiz.quiz = getQuiz(session['quizId']);
        print('session led to quiz ${playedQuiz.quiz?.name}');
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
}
