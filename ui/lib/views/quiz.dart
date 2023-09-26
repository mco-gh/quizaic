import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/views/helpers.dart';

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
        var quiz = jsonDecode(appState.playedQuiz.quiz?.qAndA! as String);
        var question = quiz[curQuestion]['question'];
        var correct = quiz[curQuestion]['correct'];
        var responses = quiz[curQuestion]['responses'];

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
                child: genText(theme, '${options[i]}. ${responses[i]}'),
              ));
            } else {
              Color color = Colors.red;
              if (responses[i] == correct) {
                color = Colors.green;
              }
              responseList.add(
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(formPadding),
                    child: genText(theme, '${options[i]}. ${responses[i]}',
                        color: color),
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
            genText(theme, 'Question $curQuestion: $question'),
            SizedBox(height: 10),
            SizedBox(
              width: 1000,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: genResponse(responses, enable),
                ),
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
