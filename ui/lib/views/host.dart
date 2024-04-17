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
import 'package:flutter/rendering.dart';
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

  final ExpansionTileController resultsController = ExpansionTileController();
  final ExpansionTileController leaderBoardController =
      ExpansionTileController();
  bool lastRevealed = false;

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

    print('hosting Quiz}: ${widget.quizId}');

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
            return genText(theme, 'Hosting Quiz...');
          }

          var leaderBoard = {};
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var curQuestion = data['curQuestion'];

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
                        if (v.containsKey('score')) {
                          playerScores[k] = v['score'];
                        }
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
                            Row(
                              children: [
                                //genText(theme,
                                SelectableText(
                                  'https://quizaic.com/play/${data["pin"]}  (pin ${data["pin"]})',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: horizontalSpaceWidth),
                                ElevatedButton(
                                  onPressed: () {
                                    appState.startQuiz(
                                        quiz.id, quiz.numQuestions);
                                  },
                                  child: genText(theme, 'Start Quiz'),
                                ),
                              ],
                            ),
                            SizedBox(height: verticalSpaceHeight),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpaceHeight * 2),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(width: horizontalSpaceWidth * 3),
                          genLeaderBoard(theme, null, leaderBoard,
                              showScores: false),
                          SizedBox(width: horizontalSpaceWidth * 3),
                          QrImageView(
                            data: 'https://quizaic.com/play/${data["pin"]}',
                            version: QrVersions.auto,
                            size: 400.0,
                          ),
                        ],
                      ),
                    ),
                  ]);
                });
          }

          // Quiz is running, show next question, leaderboard, etc.
          if (quiz.qAndA == '') {
            return Center(
              child: genText(theme, 'No questions for quiz "${quiz.name}"'),
            );
          }
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
                        if (answer != -1) {
                          hist.update(
                            answer,
                            (value) => ++value,
                            ifAbsent: () => 1,
                          );
                        }
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
                    print(
                        'curQuestion: $curQuestion, numQuestions: ${quiz.numQuestions}');
                  }
                }

                var qAndA = jsonDecode(quiz.qAndA)[curQuestion];
                var question = qAndA['question'];
                var responses = qAndA['responses'];
                var correct = qAndA['correct'];

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        genText(theme, 'Hosting Quiz "${quiz.name}"',
                            size: 30, weight: FontWeight.bold),
                        genText(theme,
                            '($respondents of ${leaderBoard.length} players have responded so far)',
                            size: 24),
                        QrImageView(
                          data: 'https://quizaic.com/play/${data["pin"]}',
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        SizedBox(height: formRowHeight),
                        genCard(
                            theme,
                            genText(theme,
                                'Question ${curQuestion + 1}: $question')),
                        SizedBox(height: formRowHeight),
                        if (curQuestion >= 0)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var answer in responses)
                                  if (appState.revealed && answer == correct)
                                    genCard(theme, genText(theme, answer),
                                        highlight: true)
                                  else
                                    genCard(theme, genText(theme, answer))
                              ]),
                        SizedBox(height: formRowHeight),
                        SizedBox(
                          width: rowWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  appState.revealed = !appState.revealed;
                                  if (appState.revealed != lastRevealed) {
                                    if (appState.revealed) {
                                      resultsController.expand();
                                      if (correct != '') {
                                        leaderBoardController.expand();
                                      }
                                      if (curQuestion ==
                                          quiz.numQuestions - 1) {
                                        if (correct != '') {
                                          appState.setFinalists(leaderBoard);
                                        }
                                      }
                                    } else {
                                      resultsController.collapse();
                                      if (correct != '') {
                                        leaderBoardController.collapse();
                                      }
                                      appState.incQuestion(
                                          appState.sessionData.id,
                                          curQuestion,
                                          quiz.numQuestions);
                                    }
                                  }
                                  lastRevealed = appState.revealed;
                                  setState(() {});
                                },
                                child: genText(
                                    theme,
                                    appState.revealed
                                        ? 'Next Question'
                                        : 'Show Results'),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: horizontalSpaceWidth),
                              genBarChart(
                                  theme, resultsController, hist, responses),
                              SizedBox(width: horizontalSpaceWidth),
                              if (correct != '')
                                genLeaderBoard(
                                    theme, leaderBoardController, leaderBoard,
                                    showScores: true),
                            ]),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
