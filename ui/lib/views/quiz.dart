import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:quizaic/const.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:quizaic/views/timer.dart';

Widget timerBar = TimerBar();
int lastQuestion = -2;

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

    return StreamBuilder<DocumentSnapshot>(
      stream: appState.playerSessionStream,
      builder: (context, snapshot) {
        if (snapshot.data?.data() == null) {
          return Center(
            child: genText(theme, 'Waiting for next quiz to start...'),
          );
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        var quizId = data['quizId'];
        if (quizId == '' || data['curQuestion'] < 0) {
          if (data['curQuestion'] == -1) {
            print('new quiz starting so reregistering player');
            appState.registerPlayer(appState.playerData.playerName, true);
          }
          return Center(
              child: genText(theme, 'Waiting for next quiz to start...'));
        }

        var quiz = appState.getQuiz(quizId);
        var qAndA = jsonDecode(quiz?.qAndA as String);
        var numQuestions = qAndA.length;

        int curQuestion = data['curQuestion'];
        print('curQuestion: $curQuestion, lastQuestion: $lastQuestion');
        if (curQuestion != lastQuestion) {
          if (curQuestion >= 0) {
            print('playing question number $curQuestion');
            appState.stopQuestionTimer();
            appState.startQuestionTimer();
          }
          appState.playerData.curQuestion = curQuestion;
          lastQuestion = curQuestion;
        }
        var question = qAndA[curQuestion]['question'];
        var correct = qAndA[curQuestion]['correct'];
        var responses = qAndA[curQuestion]['responses'];

        List<Widget> genResponses(responses, enable) {
          List<Widget> responseList = [SizedBox(height: verticalSpaceHeight)];
          for (var i = 0; i < responses.length; i++) {
            var yes = Icon(Icons.check_circle, color: Colors.green);
            var no = Icon(Icons.close, color: Colors.red);
            var na = Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(Icons.check_box_outline_blank),
            );
            Widget grade = na;

            if (!enable) {
              if (responses[i] == appState.playerData.response) {
                if (responses[i] == correct) {
                  grade = yes;
                } else {
                  grade = no;
                }
              }
            }
            ButtonStyle? style;
            if (responses[i] == correct) {
              style = ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.green);
            }
            responseList.add(Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: horizontalSpaceWidth),
                grade,
                SizedBox(width: horizontalSpaceWidth / 2),
                ElevatedButton(
                  style: enable ? null : style,
                  onPressed: enable
                      ? () => {
                            appState.playerData.respondedQuestion = curQuestion,
                            appState.playerData.response = responses[i],
                            appState.stopQuestionTimer(),
                            (context as Element).markNeedsBuild(),
                            correct = (responses[i] == correct),
                            appState.sendResponse(curQuestion, correct),
                          }
                      : null,
                  child: genText(theme, '${options[i]}. ${responses[i]}'),
                ),
              ],
            ));
            if (i < responses.length - 1) {
              responseList.add(SizedBox(height: verticalSpaceHeight * 2));
            }
          }
          return responseList;
        }

        print(
            'curQuestion: $curQuestion, respondedQuestion: ${appState.playerData.respondedQuestion}');
        bool enable = (curQuestion != appState.playerData.respondedQuestion);

        List<Widget> widgets = [
          SizedBox(height: verticalSpaceHeight * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: quiz?.id as String,
                child: Image.network(
                  quiz?.imageUrl as String,
                  height: logoHeight,
                ),
              ),
              SizedBox(width: horizontalSpaceWidth),
              genText(theme, 'Playing "${quiz?.name}"',
                  size: 30, weight: FontWeight.bold),
            ],
          ),
          SizedBox(height: verticalSpaceHeight * 2),
          timerBar,
          SizedBox(height: verticalSpaceHeight * 2),
          genText(theme,
              'Question ${curQuestion + 1} (of $numQuestions): $question'),
          SizedBox(height: verticalSpaceHeight * 2),
        ];
        widgets.addAll(genResponses(responses, enable));
        if (!enable) {
          widgets.add(SizedBox(height: verticalSpaceHeight * 2));
          if (curQuestion < numQuestions - 1) {
            widgets.add(genText(theme, 'Waiting for next question...'));
          } else {
            widgets.add(genText(theme, 'Quiz completed.'));
          }
        }
        return Column(
          children: widgets,
        );
      },
    );
  }
}
