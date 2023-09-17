import 'package:flutter/material.dart';
import 'package:quizaic/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:quizaic/models/state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
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
                        appState.playQuiz = null;
                        appState.findQuizByPin(s);
                        return;
                      },
                    ),
                    SizedBox(height: space),
                    if (appState.playQuiz != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Quiz Name:',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '${appState.playQuiz?.name}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    SizedBox(height: space),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        onChanged: (name) => appState.setPlayerName(name),
                        decoration: InputDecoration(
                          filled: true,
                          //fillColor: Color(0xFF1C2341),
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: space),
                    ElevatedButton(
                        onPressed: () {
                          appState.registerPlayer();
                          GoRouter.of(context).go('/quiz');
                        },
                        child: Text('Play Quiz')),
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
