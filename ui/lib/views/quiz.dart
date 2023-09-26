import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:quizaic/const.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

    return StreamBuilder<DocumentSnapshot>(
      stream: appState.playerSessionStream,
      builder: (context, snapshot) {
        if (snapshot.data?.data() == null) {
          return Center(child: Text('Waiting for quiz to start...'));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['curQuestion'] == "-1") {
          GoRouter.of(context).go('/play');
          //return Center(child: Text('Waiting for quiz to start...'));
        }

        int curQuestion = int.parse(data['curQuestion']);
        print('curQuestion: $curQuestion');
        var quiz = jsonDecode(appState.playedQuiz.quiz?.qAndA! as String);
        var question = quiz[curQuestion]['question'];
        var correct = quiz[curQuestion]['correct'];
        var responses = quiz[curQuestion]['responses'];
        print('quiz: $quiz');

        Card genCard(text) {
          return Card(
              //shape:
              //RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(text),
              ));
        }

        List<Widget> genResponse(responses, enable) {
          List<Widget> responseList = [];
          for (var i = 0; i < responses.length; i++) {
            if (enable) {
              responseList.add(ElevatedButton(
                onPressed: () => {
                  appState.respondedQuestion = curQuestion,
                  (context as Element).markNeedsBuild(),
                  if (responses[i] == correct)
                    {appState.sendResponse(curQuestion)}
                },
                child: Text('${options[i]}. ${responses[i]}'),
              ));
            } else {
              Color color = Colors.red;
              if (responses[i] == correct) {
                color = Colors.green;
              }
              responseList.add(
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: color),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${options[i]}. ${responses[i]}',
                        style: TextStyle(color: color)),
                  ),
                ),
              );
            }
            if (i < responses.length - 1) {
              responseList.add(SizedBox(height: 10));
            }
          }

          return responseList;
        }

        bool enable = (curQuestion != appState.respondedQuestion);

        return Column(
          children: [
            SizedBox(height: 10),
            genCard('Question $curQuestion: $question'),
            SizedBox(height: 10),
            SizedBox(
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: genResponse(responses, enable),
              ),
            ),
            if (!enable) SizedBox(height: 20),
            if (!enable) Text('Waiting for next question...')
          ],
        );
      },
    );
  }

  QuizPage();
}
