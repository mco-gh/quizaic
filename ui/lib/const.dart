import 'package:flutter_layout_grid/flutter_layout_grid.dart';

const String appName = 'Quizaic';

const apiUrl =
    bool.hasEnvironment('API_URL') ? String.fromEnvironment('API_URL') : null;
const redirectUri = bool.hasEnvironment('REDIRECT_URI')
    ? String.fromEnvironment('REDIRECT_URI')
    : null;
const clientId = bool.hasEnvironment('CLIENT_ID')
    ? String.fromEnvironment('CLIENT_ID')
    : null;

const double kDefaultPadding = 20.0;
const double rowWidth = 700.0;
const double horizontalSpaceWidth = 40.0;
const double verticalSpaceHeight = 10.0;
const double cardPadding = 10.0;
const double logoHeight = 100.0;
const double formPadding = 6.0;
const double formColumnWidth = 400.0;
const double formRowHeight = 52.0;
const double gridColWidth = 400.0;
const double buttonTextSize = 12;
const IntrinsicContentTrackSize gridRowSize = auto;
const FixedTrackSize gridColSize = FixedTrackSize(gridColWidth * .70);
const String appBarTitle = 'Quizaic';
const String appBarTitleExtended = '$appBarTitle | AI Powered Infinite Trivia';

const List<String> difficultyLevel = [
  'Trivial',
  'Easy',
  'Medium',
  'Hard',
  'Killer'
];
const List<String> synchronousOrAsynchronous = ['Synchronous', 'Asynchronous'];
const List<String> anonymousOrAuthenticated = ['Anonymous', 'Autheticated'];
const List<String> yesOrNo = ['Yes', 'No'];
const List<String> options = ['A', 'B', 'C', 'D'];
