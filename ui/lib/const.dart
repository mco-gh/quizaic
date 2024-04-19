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

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';

const String appName = 'Quizaic';

const apiUrl = bool.hasEnvironment('API_URL')
    ? String.fromEnvironment('API_URL')
    : 'http://localhost:8081';
const redirectUri = bool.hasEnvironment('REDIRECT_URI')
    ? String.fromEnvironment('REDIRECT_URI')
    : 'http://localhost:8080/callback';
const clientId =
    bool.hasEnvironment('CLIENT_ID') ? String.fromEnvironment('CLIENT_ID') : '';

const primaryGradient = LinearGradient(
  colors: [Color.fromRGBO(243, 223, 210, 1), Color(0xfff68d2d)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double defaultPadding = 20.0;
const double rowWidth = 700.0;
const double horizontalSpaceWidth = 40.0;
const double verticalSpaceHeight = 10.0;
const double cardPadding = 10.0;
const double logoHeight = 100.0;
const double formPadding = 6.0;
const double formColumnWidth = 375.0;
const double formRowHeight = 52.0;
const double gridColWidth = 375.0;
const double buttonTextSize = 12;
const IntrinsicContentTrackSize gridRowSize = auto;
const FixedTrackSize gridColSize = FixedTrackSize(gridColWidth * .75);
const String appBarTitle = '';
const String appBarTitleExtended = '$appBarTitle  AI Powered Infinitrivia';

const List<String> placeWords = ['1st', '2nd', '3rd'];

const List<String> difficultyLevel = [
  'easy',
  'intermediate',
  'hard',
];
const List<String> synchronousOrAsynchronous = ['Synchronous', 'Asynchronous'];
const List<String> anonymousOrAuthenticated = ['Anonymous', 'Authenticated'];
const List<String> yesOrNo = ['Yes', 'No'];
const List<String> options = ['A', 'B', 'C', 'D'];
