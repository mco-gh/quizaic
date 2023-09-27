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

class _BrowsePageState extends State<BrowsePage> {
  @override
  void initState() {
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.idToken == null || appState.idToken == '') {
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
                                Card(
                                  elevation: 5,
                                  //color: Color.fromRGBO(246, 141, 45, 1),
                                  color: theme.colorScheme.secondaryContainer,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2,
                                        color: Colors.orange,
                                      ),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(formPadding),
                                    child: Column(
                                      children: [
                                        genText(theme, quiz.name,
                                            size: 22, weight: FontWeight.bold),
                                        SizedBox(height: 15),
                                        Hero(
                                            tag: quiz.id!,
                                            child: Image.network(
                                                quiz.imageUrl as String,
                                                height: 150)),
                                        SizedBox(height: 15),
                                        if (appState.idToken == null ||
                                            appState.idToken == '')
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
                                                          color: Colors.white),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    GoRouter.of(context)
                                                        .go('/view/${quiz.id}');
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
                                                  GoRouter.of(context)
                                                      .go('/host/${quiz.id}');
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
                                                    GoRouter.of(context)
                                                        .go('/edit/${quiz.id}');
                                                  }),
                                              TextButton(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.content_copy,
                                                        semanticLabel: 'Clone',
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
                                                    GoRouter.of(context)
                                                        .go('/clone');
                                                  }),
                                              TextButton(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        semanticLabel: 'Delete',
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
                                                        .showSnackBar(SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 500),
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
