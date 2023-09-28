import 'package:flutter/material.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/models/state.dart';
import 'package:provider/provider.dart';

class TimerBar extends StatelessWidget {
  const TimerBar() : super();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    print('timeLeft: ${appState.playerData.timeLeft}');
    if (appState.playerData.timeLeft == 0) {
      return Container();
    }

    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF3F4768), width: 3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  width:
                      (constraints.maxWidth / appState.playerData.timeLimit) *
                          appState.playerData.timeLeft,
                  decoration: BoxDecoration(
                    gradient: primaryGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${appState.playerData.timeLeft.round()} seconds"),
                      Icon(Icons.timer),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
