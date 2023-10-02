import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

class HostPage extends StatefulWidget {
  final String? quizId;

  @override
  State<HostPage> createState() => _HostPageState();

  HostPage({this.quizId});
}

final _formKey = GlobalKey<FormState>();

class _HostPageState extends State<HostPage> {
  _HostPageState();

  @override
  void initState() {
    print('initState - quiz id: ${widget.quizId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);

    print(
        'hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'}: ${widget.quizId}');

    void setHostSynch(value) {
      return setState(() {
        print('value: $value');
        appState.editSessionData.synchronous = (value == 'Synchronous');
      });
    }

    String getHostTimeLimit() {
      return appState.editSessionData.timeLimit.toString();
    }

    void setHostTimeLimit(value) {
      return setState(() {
        appState.editSessionData.timeLimit = int.parse(value);
      });
    }

    void setHostSurvey(value) {
      return setState(() {
        appState.editSessionData.survey = value == "Survey";
      });
    }

    void setHostAnonymous(value) {
      return setState(() {
        appState.editSessionData.anonymous = (value == "Anonymous");
      });
    }

    void setHostRandomizeQuestions(value) {
      return setState(() {
        appState.editSessionData.randomizeQuestions = (value == "Yes");
      });
    }

    void setHostRandomizeAnswers(value) {
      return setState(() {
        appState.editSessionData.randomizeAnswers = (value == "Yes");
      });
    }

    if (quiz == null) {
      return Center(
        child: genText(theme, 'No quiz selected for hosting'),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: appState.sessionStream,
        builder: (context, snapshot) {
          if (snapshot.data?.data() == null) {
            return genText(theme,
                'Hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'}...');
          }

          var leaderBoard = {};
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var curQuestion = data['curQuestion'];
          var question = '';

          if (curQuestion == -2) {
            // Give host opportunity to reset session settings.
            return Center(
              child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: rowWidth,
                    child: ListView(children: [
                      SizedBox(height: verticalSpaceHeight * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: quiz.id as String,
                            child: Image.network(
                              quiz.imageUrl as String,
                              height: logoHeight,
                            ),
                          ),
                          SizedBox(width: horizontalSpaceWidth),
                          genText(theme, 'Host Settings for "${quiz.name}"',
                              size: 30, weight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(height: verticalSpaceHeight * 2),

                      // Synch or Asynch
                      genDropdownMenu(
                          theme,
                          'Synch or Asynch',
                          _formKey,
                          formColumnWidth,
                          appState.sessionData.synchronous
                              ? 'Synchronous'
                              : 'Asynchronous',
                          () => synchronousOrAsynchronous,
                          setHostSynch),
                      SizedBox(height: verticalSpaceHeight),

                      // Time Limit
                      genTextFormField(
                          theme,
                          'Per Question Time Limit (seconds)',
                          intValidator,
                          getHostTimeLimit,
                          setHostTimeLimit),
                      SizedBox(height: verticalSpaceHeight),

                      // Quiz/Survey
                      genDropdownMenu(
                          theme,
                          'Quiz or Survey',
                          _formKey,
                          formColumnWidth,
                          appState.sessionData.survey ? 'Survey' : 'Quiz',
                          () => quizOrSurvey,
                          setHostSurvey),
                      SizedBox(height: verticalSpaceHeight),

                      // Anonymous or Authenticated
                      genDropdownMenu(
                          theme,
                          'Anonymous or Authenticated',
                          _formKey,
                          formColumnWidth,
                          appState.sessionData.anonymous
                              ? 'Anonymous'
                              : 'Authenticated',
                          () => anonymousOrAuthenticated,
                          setHostAnonymous),
                      SizedBox(height: verticalSpaceHeight),

                      // Randomize Questions
                      genDropdownMenu(
                          theme,
                          'Randomize Questions',
                          _formKey,
                          formColumnWidth,
                          appState.sessionData.randomizeQuestions
                              ? 'Yes'
                              : 'No',
                          () => yesOrNo,
                          setHostRandomizeQuestions),
                      SizedBox(height: verticalSpaceHeight),

                      // Randomize Answers
                      genDropdownMenu(
                          theme,
                          'Randomize Answers',
                          _formKey,
                          formColumnWidth,
                          appState.sessionData.randomizeAnswers ? 'Yes' : 'No',
                          () => yesOrNo,
                          setHostRandomizeAnswers),
                      SizedBox(height: verticalSpaceHeight),

                      // Submit button
                      Padding(
                        padding: const EdgeInsets.all(formPadding),
                        child: Align(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                appState.startHosting(
                                    quiz.id, quiz.numQuestions);
                              }
                            },
                            child: genText(theme, 'Start Hosting'),
                          ),
                        ),
                      ),
                    ]),
                  )),
            );
          } else if (curQuestion == -1) {
            // Quiz is paused before starting, show QR code and wait for
            // players to register.
            return StreamBuilder<DocumentSnapshot>(
                stream: appState.resultsStream,
                builder: (context, snapshot) {
                  print('1: results stream: snapshot.data: ${snapshot.data}');
                  if (snapshot.data?.data() != null) {
                    var results = snapshot.data!.data() as Map<String, dynamic>;
                    if (results['players'] != null) {
                      Map players = results['players'];
                      Map playerScores = {};
                      players.forEach((k, v) {
                        print('k: $k, v: $v');
                        playerScores[k] = v['score'];
                      });
                      leaderBoard = Map.fromEntries(
                          playerScores.entries.toList()
                            ..sort((e1, e2) => e2.value.compareTo(e1.value)));
                    }
                  }

                  return Column(children: [
                    SizedBox(height: verticalSpaceHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: quiz.id as String,
                          child: Image.network(
                            quiz.imageUrl as String,
                            height: logoHeight,
                          ),
                        ),
                        SizedBox(width: horizontalSpaceWidth),
                        Column(
                          children: [
                            genText(theme,
                                'Waiting for players to join quiz "${quiz.name}"...',
                                size: 30, weight: FontWeight.bold),
                            genText(theme,
                                'URL: quizaic.com/play/${data["pin"]}  (pin ${data["pin"]})',
                                size: 24, weight: FontWeight.bold),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpaceHeight * 2),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(width: horizontalSpaceWidth * 3),
                          genLeaderBoard(theme, leaderBoard, showScores: false),
                          SizedBox(width: horizontalSpaceWidth * 3),
                          QrImageView(
                            data: 'https://quizaic.com/play/${data["pin"]}',
                            version: QrVersions.auto,
                            size: 400.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpaceHeight * 3),
                    ElevatedButton(
                      onPressed: () {
                        appState.startQuiz(quiz.id, quiz.numQuestions);
                      },
                      child: genText(theme,
                          'Start ${appState.sessionData.survey ? 'Survey' : 'Quiz'}'),
                    ),
                    SizedBox(height: verticalSpaceHeight),
                  ]);
                });
          }

          // Quiz is running, show next question, leaderboard, etc.
          if (quiz.qAndA == '') {
            return Center(
              child: genText(theme, 'No questions for quiz "${quiz.name}"'),
            );
          }
          question = jsonDecode(quiz.qAndA)[curQuestion]['question'];
          return StreamBuilder<DocumentSnapshot>(
              stream: appState.resultsStream,
              builder: (context, snapshot) {
                print('2: results stream: snapshot.data: ${snapshot.data}');
                int respondents = 0;
                Map<int, int> hist = {
                  0: 0,
                  1: 0,
                  2: 0,
                  3: 0,
                };
                if (snapshot.data?.data() != null) {
                  var results = snapshot.data!.data() as Map<String, dynamic>;
                  if (results['players'] != null) {
                    Map players = results['players'];
                    Map playerScores = {};
                    players.forEach((k, v) {
                      print('k: $k, v: $v');
                      if (v.containsKey('score')) {
                        playerScores[k] = v['score'];
                      }
                      if (v.containsKey('answers') &&
                          v['answers'].containsKey(curQuestion.toString())) {
                        int answer = v['answers'][curQuestion.toString()];
                        hist.update(
                          answer,
                          (value) => ++value,
                          ifAbsent: () => 1,
                        );
                      }
                      print('hist: $hist');
                      if (v.containsKey('results') &&
                          v['results'].containsKey(curQuestion.toString())) {
                        respondents++;
                      }
                    });
                    print('respondents: $respondents, hist: $hist');
                    leaderBoard = Map.fromEntries(playerScores.entries.toList()
                      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
                  }
                }

                return Column(
                  children: [
                    genText(theme,
                        'Hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'} "${quiz.name}"',
                        size: 30, weight: FontWeight.bold),
                    genText(theme,
                        'URL: quizaic.com/play/${data["pin"]}  (pin ${data["pin"]})',
                        size: 24, weight: FontWeight.bold),
                    genText(theme,
                        '($respondents of ${leaderBoard.length} players have responded so far)'),
                    SizedBox(height: formRowHeight),
                    genCard(
                        theme,
                        genText(
                            theme, 'Question ${curQuestion + 1}: $question')),
                    SizedBox(height: formRowHeight),
                    if (curQuestion >= 0)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var answer
                                in jsonDecode(quiz.qAndA)[curQuestion]
                                    ['responses'])
                              genCard(theme, genText(theme, answer)),
                          ]),
                    SizedBox(height: formRowHeight),
                    SizedBox(
                      width: rowWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              appState.incQuestion(appState.sessionData.id,
                                  curQuestion, quiz.numQuestions);
                            },
                            child: genText(theme, 'Next Question'),
                          ),
                          SizedBox(width: horizontalSpaceWidth),
                          ElevatedButton(
                            onPressed: () {
                              appState.stopQuiz();
                              GoRouter.of(context).go('/browse');
                            },
                            child: genText(theme, 'Stop Quiz'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpaceHeight * 2),
                    Row(children: [
                      SizedBox(width: horizontalSpaceWidth),
                      genBarChart(theme, hist,
                          jsonDecode(quiz.qAndA)[curQuestion]['responses']),
                      SizedBox(width: horizontalSpaceWidth * 1),
                      genLeaderBoard(theme, leaderBoard, showScores: true),
                    ]),
                  ],
                );
              });
        });
  }
}
