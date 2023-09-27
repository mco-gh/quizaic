import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    print('hosting quiz: ${widget.quizId}');
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);

    // Build a Form widget using the _formKey created

    void setHostSynch(value) {
      return setState(() {
        appState.hostQuiz.synch = value.toString();
      });
    }

    String getHostTimeLimit() {
      return appState.hostQuiz.timeLimit;
    }

    void setHostTimeLimit(value) {
      return setState(() {
        appState.hostQuiz.timeLimit = value.toString();
      });
    }

    void setHostType(value) {
      return setState(() {
        appState.hostQuiz.type = value.toString();
      });
    }

    void setHostAnonymous(value) {
      return setState(() {
        appState.hostQuiz.anonymous = value.toString();
      });
    }

    void setHostRandomizeQuestions(value) {
      return setState(() {
        appState.hostQuiz.randomizeQuestions = value.toString();
      });
    }

    void setHostRandomizeAnswers(value) {
      return setState(() {
        appState.hostQuiz.randomizeAnswers = value.toString();
      });
    }

    if (quiz == null) {
      return Center(
        child: genText(theme, 'No quiz selected for hosting'),
      );
    }

    String title = 'Hosting Quiz "${quiz.name}"';
    if (appState.sessionId != '') {
      print('appState.sessionId: ${appState.sessionId}');
      return StreamBuilder<DocumentSnapshot>(
          stream: appState.sessionStream,
          builder: (context, snapshot) {
            if (snapshot.data?.data() == null) {
              return genText(theme, 'Hosting Quiz...');
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;
            var curQuestion = int.parse(data['curQuestion']);
            var question = jsonDecode(quiz.qAndA)[curQuestion]['question'];

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
                  return Column(
                    children: [
                      genText(theme,
                          'Hosting Quiz "${quiz.name}", Pin: ${data["pin"]}'),
                      SizedBox(height: formRowHeight),
                      genCard(theme,
                          genText(theme, 'Question $curQuestion: $question')),
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
                                appState.incQuestion(appState.sessionId,
                                    curQuestion, int.parse(quiz.numQuestions));
                              },
                              child: genText(theme, 'Next Question'),
                            ),
                            SizedBox(width: horizontalSpaceWidth),
                            ElevatedButton(
                              onPressed: () {
                                appState.stopHostQuiz();
                              },
                              child: genText(theme, 'Stop Quiz'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: formRowHeight),
                      SizedBox(
                        width: rowWidth,
                        child: ExpansionTile(
                          title: genText(theme, 'Registered Players:'),
                          children: [
                            Table(children: [
                              for (var e in leaderBoard.entries)
                                TableRow(children: [
                                  TableCell(child: genText(theme, e.key)),
                                  TableCell(
                                      child:
                                          genText(theme, e.value.toString())),
                                ]),
                            ]),
                            //for (var e in leaderBoard.entries)
                            //genText('${e.key} ${e.value}'),
                          ],
                        ),
                      ),
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
                  genText(theme, title, size: 30, weight: FontWeight.bold),
                ],
              ),
              SizedBox(height: verticalSpaceHeight * 2),

              // Synch or Asynch
              genDropdownMenu(
                  theme,
                  'Synch or Asynch',
                  _formKey,
                  formColumnWidth,
                  appState.hostQuiz.synch,
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
                  appState.hostQuiz.type,
                  () => ['Quiz', 'Survey'],
                  setHostType),
              SizedBox(height: verticalSpaceHeight),

              // Anonymous or Authenticated
              genDropdownMenu(
                  theme,
                  'Anonymous or Authenticated',
                  _formKey,
                  formColumnWidth,
                  appState.hostQuiz.anonymous,
                  () => anonymousOrAuthenticated,
                  setHostAnonymous),
              SizedBox(height: verticalSpaceHeight),

              // Randomize Questions
              genDropdownMenu(
                  theme,
                  'Randomize Questions',
                  _formKey,
                  formColumnWidth,
                  appState.hostQuiz.randomizeQuestions,
                  () => yesOrNo,
                  setHostRandomizeQuestions),
              SizedBox(height: verticalSpaceHeight),

              // Randomize Answers
              genDropdownMenu(
                  theme,
                  'Randomize Answers',
                  _formKey,
                  formColumnWidth,
                  appState.hostQuiz.randomizeAnswers,
                  () => yesOrNo,
                  setHostRandomizeAnswers),
              SizedBox(height: verticalSpaceHeight),

              // Submit button
              Padding(
                padding: const EdgeInsets.all(formPadding),
                child: Align(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: genText(theme, 'Hosting quiz...')),
                        );
                        print('creating session...');
                        appState.createSession(quiz.id);
                      }
                    },
                    child: genText(theme, 'Start ${appState.hostQuiz.type}'),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
