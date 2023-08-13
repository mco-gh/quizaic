import 'package:flutter/material.dart';
import 'package:quizrd/models/state.dart';
import 'package:quizrd/models/quiz.dart';
import 'package:provider/provider.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  /*
  @override
  void initState() {
    super.initState();
    futureQuiz = fetchQuiz();
  }
  */

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<AppState>();

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Quiz>>(
          future: appState.futureFetchQuizzes,
          builder: (context, snapshot) {
            //print("snapshot: $snapshot");
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Text('No quizzes yet.');
              }
              var s = '';
              for (var quiz in snapshot.data!) {
                s += '${quiz.name}\n';
              }
              return Text(s);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
    /*
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${quizzes.length} quizzes:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var quiz in quizzes)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.deleteQuiz(quiz.id);
                    },
                  ),
                  title: Text(
                    quiz.name,
                    semanticsLabel: quiz.name,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    */
  }
}
