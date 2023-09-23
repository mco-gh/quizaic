import 'package:flutter/material.dart';

Text genText(ThemeData theme, String text,
    {size = 14, weight = FontWeight.normal}) {
  return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: size, fontWeight: weight, color: theme.primaryColor));
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
