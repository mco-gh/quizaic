const apiUrl =
    bool.hasEnvironment('API_URL') ? String.fromEnvironment('API_URL') : null;
const redirectUri = bool.hasEnvironment('REDIRECT_URI')
    ? String.fromEnvironment('REDIRECT_URI')
    : null;
const clientId = bool.hasEnvironment('CLIENT_ID')
    ? String.fromEnvironment('CLIENT_ID')
    : null;

const double kDefaultPadding = 20.0;

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
