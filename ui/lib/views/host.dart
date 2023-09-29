import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    super.initState();

    print('initState - quiz id: ${widget.quizId}');
  }

  genLeaderBoard(theme, leaderBoard) {
    return Column(children: [
      SizedBox(height: formRowHeight),
      SizedBox(
        width: formColumnWidth,
        child: ExpansionTile(
          title: genText(theme, 'Registered Players:'),
          children: [
            Table(children: [
              for (var e in leaderBoard.entries)
                TableRow(children: [
                  TableCell(child: genText(theme, e.key)),
                  TableCell(child: genText(theme, e.value.toString())),
                ]),
            ]),
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);

    print(
        'hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'}: ${widget.quizId}');

    // Build a Form widget using the _formKey created

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
        appState.editSessionData.timeLimit = value;
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

    if (appState.sessionData.id != '') {
      return StreamBuilder<DocumentSnapshot>(
          stream: appState.sessionStream,
          builder: (context, snapshot) {
            if (snapshot.data?.data() == null) {
              return genText(theme,
                  'Hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'}...');
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;
            var curQuestion = data['curQuestion'];
            var question = '';
            if (curQuestion >= 0) {
              question = jsonDecode(quiz.qAndA)[curQuestion]['question'];
            }

            return StreamBuilder<DocumentSnapshot>(
                stream: appState.resultsStream,
                builder: (context, snapshot) {
                  var leaderBoard = {};
                  print('snapshot.data: ${snapshot.data}');
                  if (snapshot.data?.data() != null) {
                    var results = snapshot.data!.data() as Map<String, dynamic>;
                    if (results['players'] != null) {
                      Map players = results['players'];
                      Map playerScores = {};
                      players.forEach((k, v) {
                        print('k: $k, v: $v');
                        playerScores[k] = v['score'];
                      });
                      print('playerScores: $playerScores');
                      leaderBoard = Map.fromEntries(
                          playerScores.entries.toList()
                            ..sort((e1, e2) => e2.value.compareTo(e1.value)));
                      print('leaderBoard: $leaderBoard');
                    }
                  }
                  if (curQuestion == -1) {
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
                            genLeaderBoard(theme, leaderBoard),
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
                  }
                  return Column(
                    children: [
                      genText(theme,
                          'Hosting ${appState.sessionData.survey ? 'Survey' : 'Quiz'} "${quiz.name}"',
                          size: 30, weight: FontWeight.bold),
                      genText(theme,
                          'URL: quizaic.com/play/${data["pin"]}  (pin ${data["pin"]})',
                          size: 24, weight: FontWeight.bold),
                      SizedBox(height: formRowHeight),
                      genCard(
                          theme,
                          genText(
                              theme, 'Question ${curQuestion + 1}: $question')),
                      SizedBox(height: formRowHeight),
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
                              },
                              child: genText(theme, 'Stop Quiz'),
                            ),
                          ],
                        ),
                      ),
                      genLeaderBoard(theme, leaderBoard),
                    ],
                  );
                });
          });
    }

    return Center(
      child: Form(
          key: _formKey,
          child: SizedBox(
            width: rowWidth,
            child: ListView(children: [
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
                  SizedBox(width: horizontalSpaceWidth / 2),
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
                  appState.sessionData.synchronous ? 'Synch' : 'Asynch',
                  () => synchronousOrAsynchronous,
                  setHostSynch),
              SizedBox(height: verticalSpaceHeight),

              // Time Limit
              genTextFormField(theme, 'Per Question Time Limit (seconds)',
                  intValidator, getHostTimeLimit, setHostTimeLimit),
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
                  appState.sessionData.randomizeQuestions ? 'Yes' : 'No',
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
                        appState.createOrReuseSession(quiz.id);
                      }
                    },
                    child: genText(theme, 'Start Hosting'),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
