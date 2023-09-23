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

const padding = 6.0;
const columnWidth = 325.0;
const rowHeight = 52.0;

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
        appState.hostedQuiz.synch = value.toString();
      });
    }

    String getHostTimeLimit() {
      return appState.hostedQuiz.timeLimit;
    }

    void setHostTimeLimit(value) {
      return setState(() {
        appState.hostedQuiz.timeLimit = value.toString();
      });
    }

    void setHostType(value) {
      return setState(() {
        appState.hostedQuiz.type = value.toString();
      });
    }

    void setHostAnonymous(value) {
      return setState(() {
        appState.hostedQuiz.anonymous = value.toString();
      });
    }

    void setHostRandomizeQuestions(value) {
      return setState(() {
        appState.hostedQuiz.randomizeQuestions = value.toString();
      });
    }

    void setHostRandomizeAnswers(value) {
      return setState(() {
        appState.hostedQuiz.randomizeAnswers = value.toString();
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
            var question = jsonDecode(quiz.qAndA!)[curQuestion]['question'];

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
                      SizedBox(height: 20),
                      genCard(theme,
                          genText(theme, 'Question $curQuestion: $question')),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var answer
                                in jsonDecode(quiz.qAndA!)[curQuestion]
                                    ['responses'])
                              genCard(theme, genText(theme, answer)),
                          ]),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
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
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                appState.stopHostQuiz();
                              },
                              child: genText(theme, 'Stop Quiz'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
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
            width: 700,
            child: ListView(children: [
              // Page title
              Padding(
                padding: const EdgeInsets.all(padding * 3),
                child: genText(theme, title, size: 30, weight: FontWeight.bold),
              ),
              Hero(
                tag: quiz.id as String,
                child: Image.network(quiz.imageUrl as String, height: 170),
              ),
              SizedBox(height: 20),
              // Synch or Asynch and Time Limit
              Row(
                children: [
                  // Sync/Async
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          theme,
                          'Synch or Asynch',
                          _formKey,
                          columnWidth,
                          appState.hostedQuiz.synch,
                          () => synchronousOrAsynchronous,
                          setHostSynch),
                    ),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  // Quiz Generator
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genTextFormField(
                          theme,
                          'Per Question Time Limit (seconds)',
                          intValidator,
                          getHostTimeLimit,
                          setHostTimeLimit),
                    ),
                  ),
                ],
              ),

              // Quiz/Survey and Anonymous
              Row(
                children: [
                  // Quiz or Survey
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          theme,
                          'Quiz or Survey',
                          _formKey,
                          columnWidth,
                          appState.hostedQuiz.type,
                          () => ['Quiz', 'Survey'],
                          setHostType),
                    ),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          theme,
                          'Anonymous or Authenticated',
                          _formKey,
                          columnWidth,
                          appState.hostedQuiz.anonymous,
                          () => anonymousOrAuthenticated,
                          setHostAnonymous),
                    ),
                  ),
                ],
              ),

              // Randomize Questions and Answers
              Row(
                children: [
                  // Randomize Questions
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          theme,
                          'Randomize Questions',
                          _formKey,
                          columnWidth,
                          appState.hostedQuiz.randomizeQuestions,
                          () => yesOrNo,
                          setHostRandomizeQuestions),
                    ),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  // Randomize Answers
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          theme,
                          'Randomize Answers',
                          _formKey,
                          columnWidth,
                          appState.hostedQuiz.randomizeAnswers,
                          () => yesOrNo,
                          setHostRandomizeAnswers),
                    ),
                  ),
                ],
              ),

              // Submit button
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(padding),
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
                    child: genText(theme, 'Start ${appState.hostedQuiz.type}'),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
