import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:quizaic/const.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:quizaic/views/timer.dart';

Widget timerBar = TimerBar();
int lastQuestion = -1;

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

    return StreamBuilder<DocumentSnapshot>(
      stream: appState.playerSessionStream,
      builder: (context, snapshot) {
        if (snapshot.data?.data() == null) {
          return Center(child: genText(theme, 'Waiting for quiz to start...'));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['curQuestion'] == "-1") {
          return Center(child: genText(theme, 'Waiting for quiz to start...'));
        }

        int curQuestion = int.parse(data['curQuestion']);
        if (curQuestion != lastQuestion) {
          print('starting question number $curQuestion');
          appState.startQuestionTimer();
          appState.playQuiz.curQuestion = curQuestion;
          lastQuestion = curQuestion;
        }
        var quiz = jsonDecode(appState.playQuiz.quiz?.qAndA as String);
        var question = quiz[curQuestion]['question'];
        var correct = quiz[curQuestion]['correct'];
        var responses = quiz[curQuestion]['responses'];

        List<Widget> genResponse(responses, enable) {
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
              if (responses[i] == appState.playQuiz.response) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: horizontalSpaceWidth),
                grade,
                SizedBox(width: horizontalSpaceWidth / 2),
                ElevatedButton(
                  style: enable ? null : style,
                  onPressed: enable
                      ? () => {
                            appState.respondedQuestion = curQuestion,
                            appState.playQuiz.response = responses[i],
                            appState.stopQuestionTimer(),
                            (context as Element).markNeedsBuild(),
                            if (responses[i] == correct)
                              {
                                appState.sendResponse(curQuestion),
                              }
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
            'curQuestion: $curQuestion, respondedQuestion: ${appState.respondedQuestion}');
        bool enable = (curQuestion != appState.respondedQuestion);

        List<Widget> widgets = [
          SizedBox(height: verticalSpaceHeight * 2),
          timerBar,
          SizedBox(height: verticalSpaceHeight * 2),
          genText(theme, 'Question ${curQuestion + 1}: $question'),
          SizedBox(height: verticalSpaceHeight * 2),
        ];
        widgets.addAll(genResponse(responses, enable));
        if (!enable) {
          widgets.add(SizedBox(height: verticalSpaceHeight * 2));
          widgets.add(genText(theme, 'Waiting for next question...'));
        }
        return Column(children: widgets);
      },
    );
  }
}
