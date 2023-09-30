import 'package:flutter/material.dart';
import 'package:quizaic/views/helpers.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: genText(theme, 'Settings'),
    );
  }
}
