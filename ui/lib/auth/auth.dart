import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:provider/provider.dart';
import 'package:quizrd/models/state.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If user is not signed in, show the sign in screen.
        //if (appState.idToken == 'null' || !snapshot.hasData) {
        if (!snapshot.hasData) {
          print('user not logged in');
          appState.idToken = '';
          appState.photoUrl = '';
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId:
                    '338739261213-fcueeb1c9rthjjklu7aj58n3vjetsnrg.apps.googleusercontent.com',
                scopes: ['email', 'profile'],
              )
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/quizrd_logo.png',
                    height: 40,
                  ),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to Quizrd, please sign in!')
                    : const Text('Welcome to Quizrd, please sign up!'),
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
                    'assets/images/quizrd_logo.png',
                    height: 20,
                  ),
                ),
              );
            },
          );
        }
        print('user logged in');

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          user.getIdTokenResult().then((result) {
            appState.idToken = result.token;
          });
        }
        if ((user != null) && (user.photoURL != null)) {
          appState.photoUrl = user.photoURL as String;
        }

        // Otherwise, the user is signed in, so show the signout option.
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/quizrd_logo.png',
                  height: 40,
                ),
                Text(
                  'Welcome to Quizrd!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SignOutButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
