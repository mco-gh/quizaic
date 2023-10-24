// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
