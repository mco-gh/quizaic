// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:quizaic/views/helpers.dart';
import 'package:quizaic/const.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

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
          appState.userData.name = '';
          appState.userData.hashedEmail = '';
          appState.userData.photoUrl = '';
          appState.userData.idToken = '';
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  user.getIdTokenResult().then((result) {
                    print('home page setting idToken, user: $user');
                    appState.userData.idToken = result.token as String;
                    if (user.photoURL != null) {
                      print('home page setting photoUrl');
                      appState.userData.photoUrl = user.photoURL as String;
                    }
                    if (user.displayName != null) {
                      print('home page setting displayName');
                      appState.userData.name = user.displayName as String;
                    }
                    if (user.email != null) {
                      print('home page setting email and hashedEmail');
                      appState.userData.email = user.email as String;
                      var data =
                          utf8.encode('${user.email}'); // data being hashed
                      var hashedEmail = sha256.convert(data).toString();
                      appState.userData.hashedEmail = hashedEmail;
                    }
                    GoRouter.of(context).go('/browse');
                  });
                }
              }),
            ],
            providers: [
              //EmailAuthProvider(),
              GoogleProvider(
                clientId: clientId,
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
                    appState.userData.name = '',
                    appState.userData.hashedEmail = '',
                    appState.userData.photoUrl = '',
                    appState.userData.idToken = '',
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
