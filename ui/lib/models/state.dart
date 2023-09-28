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
import 'dart:async';

class UserData {
  String name = '';
  String hashedHmail = '';
  String photoUrl = '';
  String idToken = '';
}

class EditData {
  String name = '';
  String answerFormat = 'Select generator to see formats';
  String generator = '';
  String topic = 'Select generator to see topics';
  String numQuestions = '';
  String difficulty = '';
  String qAndA = '';
}

class PlayerData {
  Quiz? quiz;
  String quizId = '';
  String sessionId = '';
  String playerName = '';
  String pin = '';
  String response = '';
  int curQuestion = -1;
  int respondedQuestion = -1;
  int timeLimit = -1;
  int timeLeft = -1;
  Timer? questionTimer;
}

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  final LocalStorage storage = LocalStorage(appName);

  int selectedIndex = 0;
  int selectedPageIndex = 0;
  bool sessionFound = false;

  List<Quiz> quizzes = [];
  List<Generator> generators = [];

  UserData userData = UserData();
  EditData editData = EditData();
  Session sessionData = Session();
  PlayerData playerData = PlayerData();

  final Stream<QuerySnapshot> quizzesStream =
      FirebaseFirestore.instance.collection('quizzes').snapshots();
  final Stream<QuerySnapshot> generatorsStream =
      FirebaseFirestore.instance.collection('generators').snapshots();

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

    generatorsStream.listen((event) {
      print("generators changed!");
      fetchGenerators();
    });
  }

  startQuestionTimer() {
    playerData.timeLeft = playerData.timeLimit;
    playerData.questionTimer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => decrQuestionTimer(),
    );
    notifyListeners();
  }

  stopQuestionTimer() {
    playerData.questionTimer?.cancel();
    playerData.timeLeft = 0;
    notifyListeners();
  }

  decrQuestionTimer() {
    playerData.timeLeft--;
    print('timer fired, time left: ${playerData.timeLeft}');

    if (playerData.timeLeft == 0) {
      stopQuestionTimer();
      playerData.respondedQuestion = playerData.curQuestion;
    }
    notifyListeners();
  }

  String? getPlayerNameByPinFromLocal(pin) {
    String? playerName = storage.getItem(pin);

    if (playerName != null) {
      playerData.playerName = playerName;
    }
    return playerName;
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
        editData.name = quiz.name;
        editData.answerFormat = quiz.answerFormat;
        editData.generator = quiz.generator;
        editData.topic = quiz.topic;
        editData.numQuestions = quiz.numQuestions;
        editData.difficulty = difficultyLevel[int.parse(quiz.difficulty) - 1];
        editData.qAndA = quiz.qAndA;
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
      'Authorization': 'Bearer ${userData.idToken}',
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

  setupStreams(sessionId) {
    sessionStream = FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .snapshots();
    resultsStream = FirebaseFirestore.instance
        .collection('results')
        .doc(sessionId)
        .snapshots();
  }

  Future<bool> createOrReuseSession(quizId) async {
    // No session found for this host so create a new one.
    Session session = Session(
      state: 'starting',
      quizId: quizId,
      curQuestion: '-1',
      pin: '',
      synchronous: sessionData.synchronous,
      timeLimit: sessionData.timeLimit,
      survey: false,
      anonymous: sessionData.anonymous,
      randomizeQuestions: sessionData.randomizeQuestions,
      randomizeAnswers: sessionData.randomizeAnswers,
    );

    // call the special /sessions/me endpoint to see if this host already
    // has a session in progress.
    var response = await http.get(Uri.parse('$apiUrl/sessions/me'), headers: {
      'Authorization': 'Bearer ${userData.idToken}',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      // session already available for this user, set sessionId accordingly.
      var resp = json.decode(response.body);
      sessionData.sessionId = resp["hostId"];
      sessionData.quizId = resp["quizId"];

      // If session in progress but quiz doesn't match the requested quiz,
      // alert the user.
      if (sessionData.quizId != '' && sessionData.quizId != quizId) {
        errorDialog(
            'Session already in progress for quiz ${sessionData.quizId}, stop it to start a new one.');
        return false;
      }

      // Session is resumable but update its settings to match the host's request
      // and reset corresponding results object.
      print(
          'Resuming session already in progress for this host: ${sessionData.sessionId}.');
      response = await http.patch(
          Uri.parse('$apiUrl/sessions/${sessionData.sessionId}'),
          body: jsonEncode(session),
          headers: {
            'Authorization': 'Bearer ${userData.idToken}',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Session ${sessionData.sessionId} updated.');
      } else {
        errorDialog('Failed to update session ${sessionData.sessionId}');
      }

/*
      String body = '{"players": null, "quizId": quizId}';
      response = await http
          .patch(Uri.parse('$apiUrl/results/${sessionData.sessionId}'), body: body, headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Results ${sessionData.sessionId} updated.');
      } else {
        errorDialog('Failed to update results ${sessionData.sessionId}');
      }
*/

      setupStreams(sessionData.sessionId);
      notifyListeners();
      return true;
    }

    // No session available for this host so create a new one.
    response = await http.post(Uri.parse('$apiUrl/sessions'),
        body: jsonEncode(session),
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var resp = json.decode(response.body);
      sessionData.sessionId = resp["id"];
      sessionData.quizId = quizId;
      setupStreams(sessionData.sessionId);
      print('New session created: ${sessionData.sessionId}.');
    } else if (response.statusCode == 403) {
      errorDialog(
          'Failed to create session for quiz $quizId due to authorization error, are you logged in?');
    } else {
      errorDialog('Failed to create session for quiz $quizId');
    }

    notifyListeners();
    return true;
  }

  Future<bool> stopSession() async {
    // stop a session by deleting the associated results but leave the session
    // record intact so the host can reuse it later. Eventually we need to
    // garbage collect stale sessions.
    var response = await http.delete(
        Uri.parse('$apiUrl/results/${sessionData.sessionId}'),
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
        });
    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Quiz ${sessionData.quizId} stopped.");
    } else {
      errorDialog('Failed to stop quiz ${sessionData.quizId}');
    }

    // Reset quizid and current question in session record so that
    // it can be resued later for another quiz.
    var body = '{"quizId": "", "curQuestion": "-1"}';
    response = await http.patch(
        Uri.parse('$apiUrl/sessions/${sessionData.sessionId}'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      sessionData.sessionId = '';
      sessionData.quizId = '';
      print("Quiz ${sessionData.quizId} reset.");
    } else {
      errorDialog('Failed to reset session ${sessionData.sessionId}');
    }
    sessionData.sessionId = '';
    sessionData.quizId = '';
    notifyListeners();
    return true;
  }

  Future<bool> createOrUpdateQuiz(context, quiz) async {
    int dnum = difficultyLevel.indexOf(editData.difficulty);
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

    tmpQuiz.name = editData.name;
    tmpQuiz.generator = editData.generator;
    tmpQuiz.answerFormat = editData.answerFormat;
    tmpQuiz.topic = editData.topic;
    tmpQuiz.numQuestions = editData.numQuestions;
    tmpQuiz.difficulty = dstr;
    tmpQuiz.qAndA = editData.qAndA;

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

    final response =
        await method(Uri.parse(url), body: jsonEncode(tmpQuiz), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userData.idToken}'
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
        headers: {'Authorization': 'Bearer ${userData.idToken}'});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Quiz id $id deleted.");
    } else {
      errorDialog('Failed to delete quiz $id');
    }
    notifyListeners();
    return true;
  }

  Future<bool> registerPlayer(playerName) async {
    var body = '{"players.$playerName.score": 0}';
    print('name: $playerName, body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/${playerData.sessionId}'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      playerData.playerName = playerName;
      storage.setItem(playerData.pin, playerData.playerName);
      print("Player ${playerData.playerName} registered.");
    } else {
      if (response.statusCode == 409) {
        errorDialog('Player $playerName already registered for this quiz.');
      } else {
        errorDialog('Failed to register player $playerName');
      }
    }
    notifyListeners();
    return true;
  }

  Future<bool> sendResponse(i) async {
    var body = '{"players.${playerData.playerName}.score": 1}';
    print('body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/${playerData.sessionId}'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Sent response $i for player ${playerData.playerName}");
    } else {
      errorDialog(
          'Failed to send response number $i for player ${playerData.playerName}');
    }
    notifyListeners();
    return true;
  }

  favoriteQuiz(id) async {
    notifyListeners();
  }

  clearPlayQuiz() {
    playerData.quiz = null;
    playerData.pin = '';
    playerData.playerName = '';
    playerData.curQuestion = 0;
    playerData.timeLimit = 0;
    playerData.timeLeft = 0;
  }

  findSessionByPin(pin, failure) {
    sessionFound = false;
    FirebaseFirestore.instance
        .collection('sessions')
        .where('pin', isEqualTo: pin)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          clearPlayQuiz();
          failure(pin);
        } else if (querySnapshot.docs.length > 1) {
          errorDialog(
              'Multiple sessions with pin $pin, using first one found.');
        }
        var session = querySnapshot.docs[0].data();
        playerData.sessionId = session['hostId'];
        print('pin $pin led to session ${playerData.sessionId}');
        playerData.quiz = getQuiz(session['quizId']);
        playerData.pin = session['pin'];
        playerData.curQuestion = int.parse(session['curQuestion']);
        playerData.timeLimit = int.parse(session['timeLimit']);
        playerData.timeLeft = playerData.timeLimit;
        print('session led to quiz ${playerData.quiz?.name}');
        // Start listening on this session for updates from host.
        playerSessionStream = FirebaseFirestore.instance
            .collection('sessions')
            .doc(playerData.sessionId)
            .snapshots();
        sessionFound = true;
        notifyListeners();
      },
      onError: (e) => errorDialog("Error completing: $e"),
    );
    return;
  }
}
