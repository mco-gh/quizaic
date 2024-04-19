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

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page as double;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(height: verticalSpaceHeight * 5),
              Image.asset(
                "assets/images/quizaic.png",
                fit: BoxFit.contain,
                width: 600.0,
                alignment: Alignment.topCenter,
              ),
              Text(
                "AI Powered Infinitrivia",
                style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    height: 2.0),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  '''Quizaic combines the power of generative AI and Google Cloud services to support creating and playing trivia quizzes and online surveys. Quizaic is not an official Google project. Let us know (via quizaic@google.com) if you have any problems or suggestions.''',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Theme.of(context).colorScheme.primary,
                      //letterSpacing: 1.2,
                      height: 1.3),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
