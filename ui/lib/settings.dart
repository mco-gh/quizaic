import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    //print('play: $theme $appState');
    return Center(
      child: Text('Settings'),
    );
  }
}
