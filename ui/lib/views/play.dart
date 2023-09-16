import 'package:flutter/material.dart';

class PlayPage extends StatelessWidget {
  final String? quizId;

  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    //var appState = context.watch<AppState>();

    return Center(
      child: Text('Playing quiz $quizId'),
    );
  }

  PlayPage({this.quizId});
}
