// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
import 'dart:math';

class UserData {
  String name = '';
  String hashedHmail = '';
  String photoUrl = '';
  String idToken = '';
}

class EditQuizData {
  String name = 'My new quiz';
  String answerFormat = 'multiple choice';
  String generator = '';
  String topic = 'Select generator to see topics';
  int numQuestions = 5;
  String difficulty = 'intermediate';
  String language = 'English';
  String imageUrl = '';
  String qAndA = '';
}

class EditSessionData {
  bool synchronous = true;
  int timeLimit = 30;
  bool anonymous = true;
  bool randomizeQuestions = false;
  bool randomizeAnswers = false;

  reset() {
    synchronous = true;
    timeLimit = 30;
    anonymous = true;
    randomizeQuestions = false;
    randomizeAnswers = false;
  }

  setFrom(src) {
    synchronous = src.synchronous;
    timeLimit = src.timeLimit;
    anonymous = src.anonymous;
    randomizeQuestions = src.randomizeQuestions;
    randomizeAnswers = src.randomizeAnswers;
  }

  Map toJson() => {
        'synchronous': synchronous,
        'timeLimit': timeLimit,
        'anonymous': anonymous,
        'randomizeQuestions': randomizeQuestions,
        'randomizeAnswers': randomizeAnswers,
      };
}

class PlayerData {
  bool registered = false;
  Quiz? quiz;
  String quizId = '';
  String sessionId = '';
  String pin = '';
  String playerName = '';

  int curQuestion = -1;
  int respondedQuestion = -1;
  String response = '';

  Timer? questionTimer;
  int timeLimit = -1;
  int timeLeft = -1;

  bool anonymous = true;
  bool randomizeQuestions = false;
  bool randomizeAnswers = false;
  bool synchronous = true;

  reset() {
    registered = false;
    quiz = null;
    quizId = '';
    sessionId = '';
    pin = '';
    playerName = '';

    curQuestion = -1;
    respondedQuestion = -1;
    response = '';

    questionTimer = null;
    timeLimit = -1;
    timeLeft = -1;

    anonymous = true;
    randomizeQuestions = false;
    randomizeAnswers = false;
    synchronous = true;
  }
}

class MyAppState extends ChangeNotifier {
  late Future<List<Quiz>> futureFetchQuizzes = fetchQuizzes();
  late Future<List<Generator>> futureFetchGenerators = fetchGenerators();

  final LocalStorage storage = LocalStorage(appName);

  int selectedIndex = 0;
  int selectedPageIndex = 0;
  bool sessionFound = false;
  bool revealed = false;

  List<Quiz> quizzes = [];
  List<Generator> generators = [];

  UserData userData = UserData();
  EditQuizData editQuizData = EditQuizData();
  EditSessionData editSessionData = EditSessionData();
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
    print('startQuestionTimer() with ${playerData.timeLimit} seconds');
    playerData.timeLeft = playerData.timeLimit;
    playerData.questionTimer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => decrQuestionTimer(),
    );
  }

  stopQuestionTimer() {
    print('stopQuestionTimer()');
    playerData.questionTimer?.cancel();
    playerData.timeLeft = 0;
  }

  decrQuestionTimer() {
    playerData.timeLeft--;
    print('timer fired, time left: ${playerData.timeLeft}');

    if (playerData.timeLeft == 0) {
      stopQuestionTimer();
      playerData.respondedQuestion = playerData.curQuestion;
      sendResponse(playerData.curQuestion, 0.0, -1);
    }
    notifyListeners();
  }

  getPlayerNameByPinFromLocal(pin) {
    print('getPlayerNameByPinFromLocal($pin)');
    String? playerName = storage.getItem(pin);
    if (playerName != null && playerName != playerData.playerName) {
      playerData.playerName = playerName;
      notifyListeners();
    }
  }

  Future<List<Quiz>> fetchQuizzes() async {
    print('fetchQuizzes using apiUrl: $apiUrl');
    final response = await http.get(Uri.parse('$apiUrl/quizzes'), headers: {
      'Authorization': 'Bearer ${userData.idToken}',
    });
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      quizzes = List<Quiz>.from(l.map((model) => Quiz.fromJson(model)));
    }
    notifyListeners();
    return quizzes;
  }

  Future<List<Generator>> fetchGenerators() async {
    print('fetchGenerators using apiUrl: $apiUrl');
    final response = await http.get(Uri.parse('$apiUrl/generators'));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
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
        editQuizData.name = quiz.name;
        editQuizData.answerFormat = quiz.answerFormat;
        editQuizData.generator = quiz.generator;
        editQuizData.topic = quiz.topic;
        editQuizData.numQuestions = quiz.numQuestions;
        editQuizData.difficulty = quiz.difficulty;
        editQuizData.language = quiz.language;
        editQuizData.qAndA = quiz.qAndA;
      }
    }
  }

  Future<bool> incQuestion(sessionId, curQuestion, numQuestions) async {
    print('incQuestion($sessionId, $curQuestion, $numQuestions)');
    if (curQuestion >= numQuestions - 1) {
      errorDialog('Reached end of quiz, stop quiz to proceed.');
      return true;
    }
    curQuestion++;
    String body = '{"curQuestion": $curQuestion}';
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
    print('setupStreams($sessionId)');
    sessionStream = FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .snapshots();
    resultsStream = FirebaseFirestore.instance
        .collection('results')
        .doc(sessionId)
        .snapshots();
  }

  startHosting(quizId, numQuestions) async {
    print('startHosting($quizId, $numQuestions)');
    print('timeLimit: ${editSessionData.timeLimit}');
    await resetSession(quizId, fromForm: true);
    await incQuestion(sessionData.id, -2, numQuestions);
    notifyListeners();
    return true;
  }

  resetSession(String quizId, {bool fromForm = false}) async {
    print('resetSession($quizId, $fromForm)');
    Map<dynamic, dynamic> json = {};

    if (quizId == '') {
      // no quiz id - we're stopping a quiz
      editSessionData.reset();
      json['quizId'] = '';
      json['curQuestion'] = -2;
    } else {
      // quiz id provided so we're starting a new quiz or resuming an existing quiz.
      if (fromForm) {
        json = editSessionData.toJson();
      }
      json['quizId'] = quizId;
      json['curQuestion'] = -2;
      json['finalists'] = [];
    }

    print('patching session data: $json');
    var response = await http.patch(
        Uri.parse('$apiUrl/sessions/${sessionData.id}'),
        body: jsonEncode(json),
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Reusable session ${sessionData.id} reset.');
    } else {
      errorDialog('Failed to reset reusable session ${sessionData.id}');
    }
  }

  setFinalists(leaderBoard) async {
    print('setFinalists($leaderBoard)');

    var leaders = leaderBoard.keys;
    print('leaders: $leaders, length: ${leaders.length}');
    Map<dynamic, dynamic> json = {
      'finalists': [],
    };
    for (int i = 0; i < min(leaders.length, 3); i++) {
      json['finalists'].add(leaders.elementAt(i));
    }
    print('json: ${jsonEncode(json)}');
    var response = await http.patch(
        Uri.parse('$apiUrl/sessions/${sessionData.id}'),
        body: jsonEncode(json),
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Reusable session ${sessionData.id} reset.');
    } else {
      errorDialog('Failed to reset reusable session ${sessionData.id}');
    }
  }

  resetResults(String quizId, {bool resetPlayers = false}) async {
    print('resetResults($quizId, $resetPlayers)');

    String players = '';
    if (resetPlayers) {
      players = ', "players": null';
    }
    String body = '{"quizId": "$quizId" $players}';
    var response = await http.patch(
        Uri.parse('$apiUrl/results/${sessionData.id}'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Results for session ${sessionData.id} reset.');
    } else {
      errorDialog('Failed to reset results for session ${sessionData.id}');
    }
  }

  Future<bool> createSession(quizId) async {
    print('createSession($quizId)');
    Map<dynamic, dynamic> json = editSessionData.toJson();
    json['quizId'] = quizId;
    json['curQuestion'] = -1;
    json['finalists'] = [];
    var response = await http
        .post(Uri.parse('$apiUrl/sessions'), body: jsonEncode(json), headers: {
      'Authorization': 'Bearer ${userData.idToken}',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> json = jsonDecode(response.body);
      sessionData = Session.fromJson(json);
      print('New session ${sessionData.id} created for hosting quiz $quizId.');
      return true;
    } else if (response.statusCode == 403) {
      errorDialog(
          'Failed to create session for hosting quiz $quizId due to authorization error, are you logged in?');
    } else {
      errorDialog('Failed to create session for hosting quiz $quizId');
    }
    return false;
  }

  Future<bool> getMySession() async {
    print('getMySession()');
    // call the special endpoint /sessions/me to see if this host already
    // has a session in progress.
    var response = await http.get(Uri.parse('$apiUrl/sessions/me'), headers: {
      'Authorization': 'Bearer ${userData.idToken}',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> json = jsonDecode(response.body);
      sessionData = Session.fromJson(json);
      return true;
    }
    return false;
  }

  Future<bool> createOrReuseSession(quizId, router) async {
    print('createOrReuseSession($quizId)');
    // If session in progress but quiz doesn't match the requested quiz,
    // switch host to the new quiz but alert the user.
    bool sessionFound = await getMySession();
    if (sessionFound) {
      // set editSessionData from sessionData so we reflect the current
      // session settings in the form.
      editSessionData.setFrom(sessionData);
      print('timeLimit: ${editSessionData.timeLimit}');
      if (sessionData.quizId == '') {
        // Idle session found, reuse it for new quiz.
        resetSession(quizId);
        print('Reusing idle session ${sessionData.id} for new quiz $quizId.');
      } else if (sessionData.quizId != quizId) {
        errorDialog(
            'Quiz already in progress, terminating it so you can host a new quiz.');
        stopQuiz();
        resetSession(quizId);
      } else {
        // Session found with same quiz id, so resume quiz in progress.
        print(
            'Resuming in progress quiz $quizId in progress on session ${sessionData.id}');
      }
    } else {
      // No session found for this host so create a new one.
      print('Creating a new session.');
      await createSession(quizId);
    }
    setupStreams(sessionData.id);
    notifyListeners();
    return true;
  }

  Future<bool> startQuiz(quizId, numQuestions) async {
    // start a quiz by setting curQuestion to 0
    await resetResults(quizId);
    await incQuestion(sessionData.id, -1, numQuestions);
    revealed = false;
    notifyListeners();
    return true;
  }

  Future<bool> stopQuiz() async {
    // stop a session by resetting the associated session and results but
    // leave the session record intact so the host can reuse it later.
    // Eventually we need to garbage collect stale sessions.
    await resetSession('');
    await resetResults('', resetPlayers: true);
    //sessionData.id = '';
    notifyListeners();
    return true;
  }

  Future<bool> createOrUpdateQuiz(context, quiz) async {
    print('createOrUpdateQuiz($quiz)');
    Quiz tmpQuiz = Quiz(
        name: editQuizData.name,
        generator: editQuizData.generator,
        answerFormat: editQuizData.answerFormat,
        topic: editQuizData.topic,
        numQuestions: editQuizData.numQuestions,
        difficulty: editQuizData.difficulty,
        language: editQuizData.language,
        qAndA: editQuizData.qAndA,
        imageUrl: 'assets/assets/images/quizaic_logo.png');

    if (quiz != null && quiz.id != '') {
      String json = jsonEncode(quiz.toJson());
      tmpQuiz = Quiz.fromJson(jsonDecode(json));
    }

    tmpQuiz.name = editQuizData.name;
    tmpQuiz.generator = editQuizData.generator;
    tmpQuiz.answerFormat = editQuizData.answerFormat;
    tmpQuiz.topic = editQuizData.topic;
    tmpQuiz.numQuestions = editQuizData.numQuestions;
    tmpQuiz.difficulty = editQuizData.difficulty;
    tmpQuiz.language = editQuizData.language;
    tmpQuiz.qAndA = editQuizData.qAndA;

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

    print('tmpQuiz: ${jsonEncode(tmpQuiz)}');
    var response =
        await method(Uri.parse(url), body: jsonEncode(tmpQuiz), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userData.idToken}'
    });

    // For UX responsiveness we create quizzes in two steps:
    // 1. Send a request to post quiz without generated artifacts.
    // 2. Send a request to patch the new quiz, with qAndA and
    //    imageUrl set to 'regen', which triggers artifact generation.
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(confirmation);
      if (method == http.post) {
        // Just created a new quiz, now send post for quiz and image gen.
        var quizData = jsonDecode(response.body);
        String genUrl = '$apiUrl/quizzes/${quizData['id']}';
        String json = '''{
              "generator": "${editQuizData.generator}",
              "topic": "${editQuizData.topic}",
              "numQuestions": ${editQuizData.numQuestions},
              "difficulty": "${editQuizData.difficulty}",
              "language": "${editQuizData.language}",
              "qAndA": "regen",
              "imageUrl": "regen"
            }''';
        print('json: $json');
        response = await http.patch(Uri.parse(genUrl), body: json, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userData.idToken}'
        });
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('successfully generated quiz content and image');
        } else if (response.statusCode == 403) {
          errorDialog(
              'failed to generate quiz content/image due to permission error, are you logged in?');
        } else {
          errorDialog('failed to generate quiz content/image');
        }
      }
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

  Future<bool> registerPlayer(String playerName, bool allowRereg,
      {router}) async {
    print('registerPlayer($playerName, $allowRereg, $router)');

    String key = 'players.$playerName';
    var body = '''{
      "$key.score": 0, "$key.results": {},
      "$key.score": 0, "$key.answers": {}
    }''';
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
      playerData.registered = true;
      storage.setItem(playerData.pin, playerData.playerName);
      print("Player ${playerData.playerName} registered, routing to quiz page");
      if (router != null) {
        router('/quiz');
      }
    } else if (response.statusCode == 409 && allowRereg) {
      print(
          'Player $playerName already registered for this quiz but rereg allowed.');
      playerData.registered = true;
      if (router != null) {
        router('/quiz');
      }
    } else if (response.statusCode == 409 && !allowRereg) {
      errorDialog(
          'Player $playerName already registered for this quiz and rereg not allowed.');
    } else {
      errorDialog('Failed to register player $playerName');
    }
    return true;
  }

  Future<bool> sendResponse(int curQuestion, double score, int answer) async {
    print('sendResponse($curQuestion, $score, $answer)');

    var body = '''{
          "players.${playerData.playerName}.results.$curQuestion": $score,
          "players.${playerData.playerName}.answers.$curQuestion": $answer
        }''';
    print('body: $body');
    final response = await http.patch(
        Uri.parse('$apiUrl/results/${playerData.sessionId}'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${userData.idToken}',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Sent response $curQuestion for player ${playerData.playerName}");
    } else {
      errorDialog(
          'Failed to send response number $curQuestion for player ${playerData.playerName}');
    }
    notifyListeners();
    return true;
  }

  favoriteQuiz(id) async {
    notifyListeners();
  }

  findSessionByPin(pin, failure) {
    print('findSessionByPin($pin)');

    sessionFound = false;
    FirebaseFirestore.instance
        .collection('sessions')
        .where('pin', isEqualTo: pin)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          playerData.reset();
          failure(pin);
        } else if (querySnapshot.docs.length > 1) {
          errorDialog(
              'Multiple sessions with pin $pin, using first one found.');
        }
        var session = querySnapshot.docs[0].data();
        playerData.sessionId = querySnapshot.docs[0].id;
        print('session: $session');
        playerData.quizId = session['quizId'];
        if (playerData.quizId != '') {
          playerData.quiz = getQuiz(playerData.quizId);
        }
        playerData.pin = session['pin'];
        playerData.curQuestion = session['curQuestion'];
        playerData.timeLimit = session['timeLimit'];
        playerData.timeLeft = playerData.timeLimit;
        playerData.anonymous = session['anonymous'];
        playerData.randomizeQuestions = session['randomizeQuestions'];
        playerData.randomizeAnswers = session['randomizeAnswers'];
        playerData.synchronous = session['synchronous'];
        print(
          'pin $pin led to session ${playerData.sessionId}, quiz ${playerData.quiz}',
        );

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
