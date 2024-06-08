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

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 10.0, 90.0, 0.0),
                child: Text(
                  "About Quizaic",
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      height: 2.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 0.0, 90.0, 5.0),
                child: Text(
                  '''Quizaic leverages the power of generative AI to create and play unlimited trivia quizzes and online surveys. Quizaic is a demonstration app to illustrate what's possible with the combination of Google Cloud services, Flutter, and Vertex AI. Quizaic is not an official Google product and should not be used for commercial purposes.''',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.primary,
                      //letterSpacing: 1.2,
                      height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 10.0, 90.0, 0.0),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      height: 2.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 0.0, 90.0, 0.0),
                child: Text(
                  '''Quizaic quizzes can be played anonymously, without logging in. Creating or hosting a quiz requires logging in with a Google account. When logging into Quizaic, Google will share your name, email address, language preference, and profile picture with the app developer. This information is used solely to identify returning users, to manage quiz ownership, and to provide feedback on your identity while logged in.''',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.primary,
                      //letterSpacing: 1.2,
                      height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 10.0, 90.0, 0.0),
                child: Text(
                  "Feedback",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      height: 2.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 0.0, 90.0, 0.0),
                child: Text(
                  '''Let us know by email to quizaic@google.com if you have any problems using Quizaic or suggestions about ways to improve it.''',
                  style: TextStyle(
                      fontSize: 20.0,
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
