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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'views/home.dart';
import 'models/state.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        ColorScheme.fromSeed(seedColor: Color(0xff4F87ED));
    TextTheme textTheme = GoogleFonts.robotoTextTheme();
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Quizaic',
          routerConfig: HomePage().router,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: colorScheme,
              textTheme: textTheme,
              scaffoldBackgroundColor: colorScheme.secondaryContainer),
        ));
  }
}
