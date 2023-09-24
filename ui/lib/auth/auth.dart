import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          appState.idToken = '';
          appState.photoUrl = '';
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                GoRouter.of(context).go('/browse');
              }),
            ],
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                // Mete: This should really be not hardcoded
                clientId:
                    '290550417489-r1h6obgomelnpgsv1csdh8hknblvbgfs.apps.googleusercontent.com',
                scopes: ['email', 'profile'],
              )
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/quizaic_logo.png',
                    height: 40,
                  ),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to Quizaic, please sign in!')
                    : const Text('Welcome to Quizaic, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/quizaic_logo.png',
                    height: 20,
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Image.asset(
                  'assets/images/quizaic_logo.png',
                  height: 100,
                ),
                SizedBox(height: 40),
                Text(
                  'Welcome to Quizaic!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  child: SizedBox(
                    width: 75,
                    child: Row(children: [
                      Icon(Icons.logout, semanticLabel: 'Signout'),
                      genText(theme, 'Signout'),
                    ]),
                  ),
                  onPressed: () => {
                    appState.idToken = '',
                    appState.photoUrl = '',
                    FirebaseAuth.instance.signOut(),
                    GoRouter.of(context).go('/browse'),
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
