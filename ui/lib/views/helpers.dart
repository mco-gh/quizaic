import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:quizaic/const.dart';

Text genText(ThemeData theme, String text,
    {size = 14, weight = FontWeight.normal, align = TextAlign.center}) {
  return Text(text,
      textAlign: align,
      style: TextStyle(
          fontSize: size, fontWeight: weight, color: theme.primaryColor));
}

genLabelValue(theme, label, value) {
  return Row(
    children: [
      SizedBox(
        width: 120,
        child: genText(theme, label,
            weight: FontWeight.bold, align: TextAlign.start),
      ),
      genText(theme, value),
    ],
  );
}

TextFormField genTextFormField(
    ThemeData theme, String label, validator, getter, setter) {
  return TextFormField(
    //style: TextStyle(color: theme.primaryColor),

    initialValue: getter(),
    onChanged: setter,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
    ),
    validator: validator,
  );
}

DropdownMenu<String> genDropdownMenu(
    ThemeData theme, String text, key, columnWidth, current, getter, setter) {
  var initialSelection = current;
  return DropdownMenu<String>(
      textStyle: TextStyle(color: theme.primaryColor),
      key: ValueKey(key),
      controller: TextEditingController(),
      initialSelection: initialSelection,
      onSelected: setter,
      width: columnWidth,
      label: genText(theme, text),
      dropdownMenuEntries: [
        for (var type in getter())
          DropdownMenuEntry(
            label: type,
            value: type,
          ),
      ]);
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

Card genCard(theme, widget) {
  return Card(
      //shape:
      //RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: widget,
      ));
}

Column genQuestionList(ThemeData theme, quiz) {
  List<Widget> widgets = [];
  List<Widget> subwidgets = [];
  int i = 0;
  int j = 0;
  if (quiz == null) {
    return Column();
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: widgets,
  );
}
