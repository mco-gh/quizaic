import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:quizaic/const.dart';

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
          appState.userData.idToken = '';
          appState.userData.photoUrl = '';
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  user.getIdTokenResult().then((result) {
                    print('home page setting idToken');
                    appState.userData.idToken = result.token as String;
                    GoRouter.of(context).go('/browse');
                  });
                }
                if ((user != null) && (user.photoURL != null)) {
                  appState.userData.photoUrl = user.photoURL as String;
                }
              }),
            ],
            providers: [
              //EmailAuthProvider(),
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
                    height: formRowHeight,
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
                    height: formRowHeight,
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
                SizedBox(height: formRowHeight),
                Image.asset(
                  'assets/images/quizaic_logo.png',
                  height: logoHeight,
                ),
                SizedBox(height: formRowHeight),
                ElevatedButton(
                  child: SizedBox(
                    width: 'Signout'.length * 15,
                    child: Row(children: [
                      Icon(Icons.logout, semanticLabel: 'Signout'),
                      genText(theme, 'Signout'),
                    ]),
                  ),
                  onPressed: () => {
                    appState.userData.idToken = '',
                    appState.userData.photoUrl = '',
                    FirebaseAuth.instance.signOut(),
                    GoRouter.of(context).go('/'),
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
