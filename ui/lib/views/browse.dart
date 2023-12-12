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
import 'package:quizaic/models/state.dart';
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:quizaic/const.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  (List<IntrinsicContentTrackSize>, List<FixedTrackSize>) configGrid(
      double width, int numQuizzes) {
    List<IntrinsicContentTrackSize> rows = [];
    List<FixedTrackSize> cols = [];
    var numColumns = (width / gridColWidth).floor();

    for (var i = 0; i < (numQuizzes / numColumns).ceil(); i++) {
      rows.add(gridRowSize);
    }
    for (var i = 0; i < numColumns; i++) {
      cols.add(gridColSize);
    }
    return (rows, cols);
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    var router = GoRouter.of(context).go;

    if (appState.userData.idToken == '') {
      return Center(
          child: genText(theme,
              'Please sign in, by clicking the person icon at upper right, to create quizzes.'));
    }
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Quiz>>(
          future: appState.futureFetchQuizzes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (appState.quizzes.isEmpty) {
                return Text('No quizzes yet.');
              }
              var (rows, cols) = configGrid(
                  MediaQuery.of(context).size.width, appState.quizzes.length);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        genText(theme, "All quizzes"),
                        Switch(
                            // This bool value toggles the switch.
                            value: appState.myQuizzesOnly,
                            activeColor: Colors.red,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                appState.myQuizzesOnly = value;
                                print(
                                    "appState.myQuizzesOnly: ${appState.myQuizzesOnly}");
                              });
                            }),
                        genText(theme, "My Quizzes"),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: LayoutGrid(
                            autoPlacement: AutoPlacement.rowSparse,
                            rowSizes: rows,
                            columnSizes: cols,
                            rowGap: 15,
                            columnGap: 15,
                            children: [
                              for (var quiz in appState.quizzes)
                                if (!appState.myQuizzesOnly ||
                                    quiz.creator ==
                                        appState.userData.hashedEmail)
                                  Card(
                                    elevation: 5,
                                    //color: Color.fromRGBO(246, 141, 45, 1),
                                    color: theme.colorScheme.secondaryContainer,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.orange,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(formPadding),
                                      child: Column(
                                        children: [
                                          genText(theme, quiz.name,
                                              size: 22,
                                              weight: FontWeight.bold),
                                          SizedBox(height: 5),
                                          if (quiz.imageUrl ==
                                              'assets/assets/images/quizaic_logo.png')
                                            SizedBox(
                                              height: 150,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: controller.value,
                                                  semanticsLabel:
                                                      'Circular progress indicator',
                                                ),
                                              ),
                                            )
                                          else
                                            Hero(
                                                tag: quiz.id!,
                                                child: Image.network(
                                                    quiz.imageUrl as String,
                                                    height: 150)),
                                          SizedBox(height: 10),
                                          if (appState.userData.idToken == '')
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons.view_list,
                                                            color: Colors.white,
                                                            semanticLabel:
                                                                'View'),
                                                        genText(theme, 'View',
                                                            color:
                                                                Colors.white),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      router(
                                                          '/view/${quiz.id}');
                                                    },
                                                  ),
                                                ])
                                          else
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.play_circle,
                                                        semanticLabel: 'Host',
                                                      ),
                                                      genText(
                                                        theme,
                                                        'Host',
                                                        size: buttonTextSize,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    appState
                                                        .createOrReuseSession(
                                                            quiz.id, router);
                                                    router('/host/${quiz.id}');
                                                  },
                                                ),
                                                TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          semanticLabel: 'Edit',
                                                        ),
                                                        genText(
                                                          theme,
                                                          'Edit',
                                                          size: buttonTextSize,
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      appState.selectQuizData(
                                                          quiz.id);
                                                      router(
                                                          '/edit/${quiz.id}');
                                                    }),
                                                TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.content_copy,
                                                          semanticLabel:
                                                              'Clone',
                                                        ),
                                                        genText(
                                                          theme,
                                                          'Clone',
                                                          size: buttonTextSize,
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      appState.getQuiz(quiz.id);
                                                      appState.selectQuizData(
                                                          quiz.id);
                                                      router('/clone');
                                                    }),
                                                TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          semanticLabel:
                                                              'Delete',
                                                        ),
                                                        genText(
                                                          theme,
                                                          'Delete',
                                                          size: buttonTextSize,
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      appState.deleteQuiz(
                                                          context, quiz.id);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration: Duration(
                                                            milliseconds: 1000),
                                                        content: genText(
                                                          theme,
                                                          'Deleting quiz...',
                                                        ),
                                                      ));
                                                    }),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
