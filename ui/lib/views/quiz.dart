import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

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

    return StreamBuilder<DocumentSnapshot>(
      stream: appState.playerSessionStream,
      builder: (context, snapshot) {
        if (snapshot.data?.data() == null) {
          return Text('Waiting for quiz to start...');
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;
        int curQuestion = int.parse(data['curQuestion']);
        print('curQuestion: $curQuestion');
        var quiz = jsonDecode(appState.playQuiz?.qAndA! as String);
        var question = quiz[curQuestion]['question'];
        var correct = quiz[curQuestion]['correct'];
        var responses = quiz[curQuestion]['responses'];

        List<Widget> genResponse(responses) {
          List<Widget> responseList = [];
          var letters = ['A', 'B', 'C', 'D'];
          for (var i = 0; i < responses.length; i++) {
            responseList.add(ElevatedButton(
              onPressed: () => {
                if (responses[i] == correct)
                  {appState.sendResponse(curQuestion)}
              },
              child: Text('${letters[i]}. ${responses[i]}'),
            ));
            if (i < responses.length - 1) {
              responseList.add(SizedBox(width: 20));
            }
          }
          return responseList;
        }

        return Column(
          children: [
            SizedBox(height: 40),
            genCard('Question: $question'),
            SizedBox(height: 40),
            SizedBox(
              width: 1000,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: genResponse(responses),
              ),
            )
          ],
        );
      },
    );
  }

  QuizPage();
}
