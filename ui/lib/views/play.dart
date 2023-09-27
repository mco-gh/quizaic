import 'package:flutter/material.dart';
import 'package:quizaic/const.dart';
import 'package:pinput/pinput.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:bad_words/bad_words.dart';
import 'package:quizaic/views/quiz.dart';

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color(0xfff68d2d)),
    borderRadius: BorderRadius.circular(20),
  ),
);

class PlayPage extends StatelessWidget {
  final _controller = TextEditingController();
  final filter = Filter();
  final String? pin;

  PlayPage({this.pin});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    checkAndRegisterPlayerName(name) async {
      bool profane = filter.isProfane(name);
      if (profane) {
        errorDialog('Invalid name, please try again.');
        _controller.setText('');
        return;
      }
      appState.registerPlayer(name);
    }

    if (pin != null && pin != '') {
      appState.playQuiz.pin = pin as String;
    }

    if (appState.playQuiz.pin != '' && appState.playQuiz.pin != '') {
      if (playQuiz.playerName != '') {
        return QuizPage();
      }
      appState.findQuizByPin(appState.playQuiz.pin);
      String? name =
          appState.getPlayerNameByPinFromLocal(appState.playQuiz.pin);
      if (name != null) {
        return QuizPage();
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: verticalSpaceHeight * 2),
                    genText(theme, 'Enter a PIN to play a quiz:'),
                    SizedBox(height: verticalSpaceHeight * 2),
                    Pinput(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: TextEditingController(),
                      length: 3,
                      defaultPinTheme: defaultPinTheme,
                      validator: (s) {
                        appState.findQuizByPin(s);
                        return;
                      },
                    ),
                    SizedBox(height: verticalSpaceHeight * 3),
                    if (appState.playQuiz.quiz != null)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                SizedBox(height: verticalSpaceHeight * 3),
                                Image.network(
                                  appState.playQuiz.quiz?.imageUrl as String,
                                  height: logoHeight,
                                ),
                                SizedBox(width: horizontalSpaceWidth),
                                genText(
                                  theme,
                                  'Quiz Name:',
                                ),
                              ]),
                              SizedBox(width: 20),
                              genText(
                                theme,
                                '${appState.playQuiz.quiz?.name}',
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpaceHeight * 3),
                          SizedBox(
                            width: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(formPadding),
                              child: TextField(
                                controller: _controller,
                                onSubmitted: (name) =>
                                    checkAndRegisterPlayerName(name),
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpaceHeight),
                          ElevatedButton(
                              onPressed: () => {
                                    if (_controller.value.text.isEmpty)
                                      {
                                        errorDialog(
                                          'Please enter a name to play the quiz.',
                                        ),
                                      }
                                    else
                                      {
                                        checkAndRegisterPlayerName(
                                          _controller.value.text,
                                        )
                                      }
                                  },
                              child: genText(theme, 'Play Quiz')),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
