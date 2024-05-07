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

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:quizaic/const.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

Widget genText(ThemeData theme, String text,
    {size = 20,
    weight = FontWeight.normal,
    align = TextAlign.center,
    width = formColumnWidth,
    color}) {
  Color textColor = theme.primaryColor;
  if (color != null) {
    textColor = color;
  }
  return Padding(
    padding: const EdgeInsets.all(formPadding),
    child: Text(text,
        textAlign: align,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: textColor,
        )),
  );
}

genLabelValue(theme, label, value) {
  return Padding(
    padding: const EdgeInsets.all(formPadding),
    child: Row(
      children: [
        genText(theme, label, weight: FontWeight.bold, width: 200),
        SizedBox(width: horizontalSpaceWidth),
        genText(theme, value),
      ],
    ),
  );
}

Widget genTextFormField(
    ThemeData theme, String label, validator, getter, setter,
    {width = formColumnWidth}) {
  List<String> hints = [];
  if (label == 'Number of Questions') {
    hints = [AutofillHints.oneTimeCode];
  } else if (label == 'Quiz Language') {
    hints = [AutofillHints.language];
  } else if (label == 'Quiz Name') {
    hints = [AutofillHints.oneTimeCode];
  } else if (label.startsWith('Enter free-form text for')) {
    hints = [AutofillHints.oneTimeCode];
  }
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(formPadding),
      child: SizedBox(
        width: width,
        height: formRowHeight,
        child: TextFormField(
          autofillHints: hints,
          initialValue: getter(),
          onChanged: setter,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
          ),
          validator: validator,
        ),
      ),
    ),
  );
}

Widget genDropdownMenu(ThemeData theme, String text, key, formColumnWidth,
    current, getter, setter, controller) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(formPadding),
      child: SizedBox(
        width: formColumnWidth,
        height: formRowHeight,
        child: DropdownMenu<String>(
            textStyle: TextStyle(color: theme.primaryColor),
            key: ValueKey(key),
            controller: controller,
            initialSelection: current,
            onSelected: setter,
            width: formColumnWidth,
            label: genText(theme, text),
            dropdownMenuEntries: [
              for (var type in getter())
                if (text == 'Quiz Generator' && type == 'Palm')
                  DropdownMenuEntry(
                    label: 'Google Pathways Language Model (PaLM)',
                    value: type,
                    enabled: false,
                  )
                else if (text == 'Quiz Generator' && type == 'OpenTrivia')
                  DropdownMenuEntry(
                    label:
                        'OpenTrivia (Open Source Trivia Question Repository)',
                    value: type,
                  )
                else if (text == 'Quiz Generator' && type == 'Jeopardy')
                  DropdownMenuEntry(
                    label: 'Jeopardy (US TV Program Archives)',
                    value: type,
                    enabled: false,
                  )
                else if (text == 'Quiz Generator' && type == 'Gemini-Pro')
                  DropdownMenuEntry(
                    label: 'Gemini Pro',
                    value: type,
                  )
                else if (text == 'Quiz Generator' && type == 'Gemini-Ultra')
                  DropdownMenuEntry(
                    label: 'Gemini Ultra',
                    value: type,
                  )
                else if (text == 'Quiz Generator' && type == "Custom")
                  DropdownMenuEntry(
                    label: 'Custom (provide a URL)',
                    value: 'Custom',
                  )
                else if (text == 'Quiz Generator' && type == "Manual")
                  DropdownMenuEntry(
                    label: 'Manual (enter a quiz from scratch)',
                    value: 'Manual',
                  )
                else
                  DropdownMenuEntry(
                    label: type,
                    value: type,
                  )
            ]),
      ),
    ),
  );
}

String? urlValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Missing value';
  }
  if (!Uri.parse(value).isAbsolute) {
    return 'Must be a properly formatted URL';
  }
  return null;
}

String? intValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Missing value';
  }
  if (int.tryParse(value) == null) {
    return 'Must be an integer';
  }
  if (int.parse(value) <= 0) {
    return 'Must be an integer greater than zero';
  }
  return null;
}

String? strValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Missing value';
  }
  return null;
}

Widget genCard(theme, widget, {highlight = false}) {
  var color = theme.colorScheme.primaryContainer;
  if (highlight) {
    color = Colors.green;
  }
  return Padding(
    padding: const EdgeInsets.all(formPadding / 2),
    child: Card(
        //shape:
        //RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: widget,
        )),
  );
}

Widget genQuestionList(
    ThemeData theme, appState, getQuizContent, setQuizContent, controller) {
  List<Widget> widgets = [];
  List<Widget> subwidgets = [];

  int i = 0;
  List<int> questionKeys = [];

  String quizContent = getQuizContent();
  if (quizContent == '') {
    return genText(
        theme, 'Quiz generation appears to have failed for this quiz.');
  }

  var qAndA = jsonDecode(quizContent);
  print('qAndA: $qAndA');
  for (var question in qAndA) {
    getQuestion() {
      return question['question'];
    }

    setQuestion(s) {
      question['question'] = s;
      appState.editQuizData.qAndA = jsonEncode(qAndA);
    }

    getResponses() {
      return question["responses"];
    }

    setCorrect(s) {
      question['correct'] = s;
      appState.editQuizData.qAndA = jsonEncode(qAndA);
      print(
          's: $s, appState.editQuizData.qAndA: ${appState.editQuizData.qAndA}');
    }

    subwidgets = [];

    widgets.add(Row(
      children: [
        genTextFormField(theme, '${i + 1}', null, getQuestion, setQuestion,
            width: formColumnWidth * 1.4),
        SizedBox(width: horizontalSpaceWidth),
        ElevatedButton(
            onPressed: () => {
                  qAndA.remove(question),
                  setQuizContent(qAndA),
                  print('appState.EditQuizData: ${appState.editQuizData}'),
                },
            child: Icon(Icons.delete)),
      ],
    ));
    questionKeys.add(0);

    if (appState.editQuizData.answerFormat == "multiple choice") {
      for (var j = 0; j < question["responses"].length; j++) {
        getResponse() {
          return question["responses"][j];
        }

        mkSetResponse(i) {
          return (s) => {
                question['responses'][j] = s,
                appState.editQuizData.qAndA = jsonEncode(qAndA),
                questionKeys[i]++
              };
        }

        subwidgets.add(genTextFormField(
            theme, options[j], null, getResponse, mkSetResponse(i)));
      }
      subwidgets.add(genDropdownMenu(
          theme,
          'CorrectAnswer',
          questionKeys[i],
          formColumnWidth,
          question["correct"],
          getResponses,
          setCorrect,
          controller));
    } else {
      subwidgets.add(genText(theme, 'Answer: ${question["correct"]}'));
    }
    widgets.add(Padding(
      padding: const EdgeInsets.all(formPadding),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: subwidgets),
    ));
    i++;
  }

  Map emptyQuestion = {
    'question': '',
    'responses': ['', '', '', ''],
    'correct': ''
  };
  widgets.add(Padding(
    padding: const EdgeInsets.all(formPadding),
    child: ElevatedButton(
        onPressed: () => {
              qAndA.add(emptyQuestion),
              setQuizContent(qAndA),
              print('appState.EditQuizData: ${appState.editQuizData}'),
            },
        child: Icon(Icons.add)),
  ));

  return Padding(
    padding: const EdgeInsets.all(formPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    ),
  );
}

Widget genQuizNameWidget(theme, readOnly, quiz, getQuizName, setQuizName) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Name:', quiz.name);
  } else {
    widget = genTextFormField(
        theme, 'Quiz Name', strValidator, getQuizName, setQuizName);
  }
  return widget;
}

Widget genQuizGeneratorWidget(theme, readOnly, quiz, key, appState,
    getGenerators, setGenerator, controller) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Quiz Generator:', quiz.generator);
  } else {
    widget = genDropdownMenu(
        theme,
        'Quiz Generator',
        key,
        formColumnWidth,
        appState.editQuizData.generator,
        getGenerators,
        setGenerator,
        controller);
  }
  return widget;
}

Widget genQuizTopicWidget(
    theme, readOnly, quiz, key, appState, getTopics, setTopic, controller) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Quiz Topic:', quiz.topic);
  } else {
    widget = genDropdownMenu(theme, 'Quiz Topic', key, formColumnWidth,
        appState.editQuizData.topic, getTopics, setTopic, controller);
  }
  return widget;
}

Widget genQuizAnswerFormatWidget(theme, readOnly, quiz, key, appState,
    getAnswerFormats, setAnswerFormat, controller) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Answer Format:', quiz.answerFormat);
  } else {
    widget = genDropdownMenu(
        theme,
        'Answer Format',
        key,
        formColumnWidth,
        appState.editQuizData.answerFormat,
        getAnswerFormats,
        setAnswerFormat,
        controller);
  }
  return widget;
}

Widget genQuizNumQuestionsWidget(
    theme, readOnly, quiz, getNumQuestions, setNumQuestions) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Number of Questions:', quiz.numQuestions);
  } else {
    widget = genTextFormField(theme, 'Number of Questions', intValidator,
        getNumQuestions, setNumQuestions);
  }
  return widget;
}

Widget genQuizDifficultyWidget(theme, readOnly, quiz, key, appState,
    getDifficulties, setDifficulty, controller) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget =
        genLabelValue(theme, 'Difficulty:', 'intermediate'); //quiz.difficulty);
  } else {
    widget = genDropdownMenu(
        theme,
        'Difficulty',
        key,
        formColumnWidth,
        appState.editQuizData.difficulty,
        getDifficulties,
        setDifficulty,
        controller);
  }
  return widget;
}

Widget genQuizLanguageWidget(
    theme, readOnly, quiz, getQuizLanguage, setQuizLanguage) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Language:', quiz.name);
  } else {
    widget = genTextFormField(
        theme, 'Quiz Language', strValidator, getQuizLanguage, setQuizLanguage);
  }
  return widget;
}

genLeaderBoard(theme, controller, leaderBoard, {bool showScores = false}) {
  print('genLeaderBoard($theme, $controller, $leaderBoard, $showScores)');

  int numPlayers = leaderBoard.length;
  String regPlayersTitle =
      "${numPlayers > 0 ? numPlayers : 'No'} Registered Players";

  return Column(children: [
    SizedBox(
      width: formColumnWidth,
      child: ExpansionTile(
        controller: controller,
        initiallyExpanded: !showScores,
        expandedAlignment: Alignment.topLeft,
        title: genText(theme, showScores ? 'Leaderboard' : regPlayersTitle),
        children: [
          Table(children: [
            for (var e in leaderBoard.entries)
              TableRow(children: [
                TableCell(child: genText(theme, e.key)),
                if (showScores)
                  TableCell(child: genText(theme, e.value.toStringAsFixed(3))),
              ]),
          ]),
        ],
      ),
    )
  ]);
}

genBarChart(theme, controller, hist, responses) {
  print('genBarChart($theme, $controller, $hist, $responses)');
  List<VBarChartModel> bardata = [];

  int maxVal = 0;
  for (var i = 0; i < hist.length; i++) {
    if (hist[i] > 0) {
      if (hist[i] > maxVal) {
        maxVal = hist[i];
      }
      bardata.add(VBarChartModel(
        index: i,
        label: responses[i],
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: hist[i],
        tooltip: hist[i].toString(),
      ));
    }
  }

  return SizedBox(
    width: formColumnWidth,
    child: ExpansionTile(
        controller: controller,
        initiallyExpanded: false,
        expandedAlignment: Alignment.topLeft,
        title: genText(theme, 'Results'),
        children: [
          VerticalBarchart(
            maxX: maxVal as double,
            data: bardata,
            showLegend: true,
            alwaysShowDescription: true,
            showBackdrop: true,
          ),
        ]),
  );
}
