import 'package:flutter/material.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Center(
      child: genText(theme, 'Settings $appState'),
    );
  }
}
