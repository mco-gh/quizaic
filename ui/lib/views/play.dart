import 'package:flutter/material.dart';
import 'package:quizaic/const.dart';
import 'package:pinput/pinput.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:bad_words/bad_words.dart';

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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    enterPlayerName(name) {
      bool profane = filter.isProfane(name);
      if (profane) {
        errorDialog('Invalid name, please try again.');
        _controller.setText('');
        return;
      }
      appState.registerPlayer();
      GoRouter.of(context).go('/quiz');
    }

    var space = 40.0;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: space),
                    Pinput(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: TextEditingController(),
                      length: 3,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (value) => print('value: $value'),
                      onCompleted: (pin) => print('Completed: $pin'),
                      validator: (s) {
                        appState.playedQuiz.quiz = null;
                        appState.findQuizByPin(s);
                        return;
                      },
                    ),
                    SizedBox(height: space),
                    if (appState.playedQuiz.quiz != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          genText(
                            theme,
                            'Quiz Name:',
                          ),
                          SizedBox(width: 20),
                          genText(
                            theme,
                            '${appState.playedQuiz.quiz?.name}',
                          ),
                        ],
                      ),
                    SizedBox(height: space),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (name) => enterPlayerName(name),
                        onChanged: (name) => appState.setPlayerName(name),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: space),
                    ElevatedButton(
                        onPressed: () =>
                            enterPlayerName(_controller.value.text),
                        child: genText(theme, 'Play Quiz')),
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
