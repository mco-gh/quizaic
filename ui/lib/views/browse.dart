import 'package:flutter/material.dart';
import 'package:quizrd/models/state.dart';
import 'package:quizrd/models/quiz.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    Text genText(String text, {size = 14, weight = FontWeight.normal}) {
      return Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: size, fontWeight: weight, color: theme.primaryColor));
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

              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // Make better use of wide windows with a grid.
                      child: GridView(
                        //padding: const EdgeInsets.all(0),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          childAspectRatio: 400 / 400,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        ),
                        children: [
                          for (var quiz in appState.quizzes)
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: theme.colorScheme.primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(quiz.name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Hero(
                                        tag: quiz.id!,
                                        child: Image.network(
                                            quiz.imageUrl as String,
                                            height: 220)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            child: Icon(Icons.play_circle,
                                                semanticLabel: 'Host'),
                                            onPressed: () {
                                              setState(() {
                                                appState.getQuiz(quiz.id);
                                                appState.hostQuizId = quiz.id!;
                                              });
                                              GoRouter.of(context)
                                                  .push('/host');
                                            }),
                                        TextButton(
                                            child: Icon(Icons.edit,
                                                semanticLabel: 'Edit'),
                                            onPressed: () {
                                              setState(() {
                                                appState.getQuiz(quiz.id);
                                                appState.editQuizId = quiz.id!;
                                              });
                                              GoRouter.of(context)
                                                  .push('/edit');
                                            }),
                                        TextButton(
                                            child: Icon(Icons.content_copy,
                                                semanticLabel: 'Clone'),
                                            onPressed: () {
                                              setState(() {
                                                appState.getQuiz(quiz.id);
                                                appState.cloneQuizId = quiz.id!;
                                              });
                                              GoRouter.of(context)
                                                  .push('/clone');
                                            }),
                                        TextButton(
                                            child: Icon(Icons.delete,
                                                semanticLabel: 'Delete'),
                                            onPressed: () {
                                              appState.deleteQuiz(quiz.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                content:
                                                    genText('Deleting quiz...'),
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
