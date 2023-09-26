import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:quizaic/const.dart';

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
    ThemeData theme, String label, validator, getter, setter) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(formPadding),
      child: SizedBox(
        width: formColumnWidth,
        height: formRowHeight,
        child: TextFormField(
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
    current, getter, setter) {
  var initialSelection = current;
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(formPadding),
      child: SizedBox(
        width: formColumnWidth,
        height: formRowHeight,
        child: DropdownMenu<String>(
            textStyle: TextStyle(color: theme.primaryColor),
            key: ValueKey(key),
            controller: TextEditingController(),
            initialSelection: initialSelection,
            onSelected: setter,
            width: formColumnWidth,
            label: genText(theme, text),
            dropdownMenuEntries: [
              for (var type in getter())
                DropdownMenuEntry(
                  label: type,
                  value: type,
                ),
            ]),
      ),
    ),
  );
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

Widget genCard(theme, widget) {
  return Padding(
    padding: const EdgeInsets.all(formPadding),
    child: Card(
        //shape:
        //RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: widget,
        )),
  );
}

Widget genQuestionList(ThemeData theme, quiz) {
  List<Widget> widgets = [];
  List<Widget> subwidgets = [];
  int i = 0;
  int j = 0;
  if (quiz == null) {
    return Padding(
      padding: const EdgeInsets.all(formPadding),
      child: Column(),
    );
  }
  var qAndA = jsonDecode(quiz.qAndA as String);
  for (var question in qAndA) {
    j = 0;
    subwidgets = [];
    widgets.add(genText(theme, '${i + 1}: ${question["question"]}'));
    if (quiz.answerFormat == "multiple choice") {
      for (var answer in question["responses"]) {
        subwidgets.add(genText(theme, '${options[j]}: $answer'));
        j++;
      }
    } else {
      subwidgets.add(genText(theme, 'Answer: ${question["correct"]}'));
    }
    widgets.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: subwidgets),
    ));
    i++;
  }
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

Widget genQuizGeneratorWidget(
    theme, readOnly, quiz, key, appState, getGenerators, setGenerator) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Quiz Generator:', quiz.generator);
  } else {
    widget = genDropdownMenu(theme, 'Quiz Generator', key, formColumnWidth,
        appState.selectedQuiz.generator, getGenerators, setGenerator);
  }
  return widget;
}

Widget genQuizTopicWidget(
    theme, readOnly, quiz, key, appState, getTopics, setTopic) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Quiz Topic:', quiz.topic);
  } else {
    widget = genDropdownMenu(theme, 'Quiz Topic', key, formColumnWidth,
        appState.selectedQuiz.topic, getTopics, setTopic);
  }
  return widget;
}

Widget genQuizAnswerFormatWidget(
    theme, readOnly, quiz, key, appState, getAnswerFormats, setAnswerFormat) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Answer Format:', quiz.answerFormat);
  } else {
    widget = genDropdownMenu(theme, 'Answer Format', key, formColumnWidth,
        appState.selectedQuiz.answerFormat, getAnswerFormats, setAnswerFormat);
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

Widget genQuizDifficultyWidget(
    theme, readOnly, quiz, key, appState, getDifficulty, setDifficulty) {
  Widget widget;

  if (readOnly && quiz != null) {
    widget = genLabelValue(theme, 'Difficulty:', quiz.difficulty);
  } else {
    widget = genDropdownMenu(theme, 'Difficulty', key, formColumnWidth,
        appState.selectedQuiz.difficulty, getDifficulty, setDifficulty);
  }
  return widget;
}
