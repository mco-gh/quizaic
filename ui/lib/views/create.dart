import 'package:flutter/material.dart';
import 'package:quizrd/models/state.dart';
import 'package:provider/provider.dart';

enum Synchronous { synchronous, asynchronous }

enum Anonymous { anonymous, authenticated }

enum ActivityType { quiz, survey }

enum YN { yes, no }

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => _CreatePageState();
}

final _formKey = GlobalKey<FormState>();
int _answerFormatKey = 0;
int _topicListKey = 0;
const padding = 6.0;
const columnWidth = 325.0;
const rowHeight = 52.0;

String? strValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Missing value';
  }
  return null;
}

String? intValidator(String? value) {
  debugPrint('value=$value');

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

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    // Build a Form widget using the _formKey created

    Text genText(String text, {size = 14, weight = FontWeight.normal}) {
      return Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: size, fontWeight: weight, color: theme.primaryColor));
    }

    TextFormField genTextFormField(label, validator) {
      return TextFormField(
        initialValue: appState.selectedQuizName,
        onChanged: (value) => setState(() {
          appState.selectedQuizName = value.toString();
        }),
        //style: TextStyle(color: theme.primaryColor),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        // The validator receives the text that the user has entered.
        validator: validator,
      );
    }

    DropdownMenu<String> genDropdownMenu(key, text, getter, setter) {
      var initialSelection = getter()[0];
      if (text == "Quiz Generator") {
        initialSelection = null;
      }
      return DropdownMenu<String>(
          //textStyle: TextStyle(color: theme.primaryColor),
          key: ValueKey(key),
          initialSelection: initialSelection,
          onSelected: setter,
          width: columnWidth,
          label: genText(text),
          dropdownMenuEntries: [
            for (var type in getter())
              DropdownMenuEntry(
                label: type,
                value: type,
              ),
          ]);
    }

    List<String> getGenerators() {
      List<String> generatorNames = [];
      for (var generator in appState.generators) {
        generatorNames.add(generator.name);
      }
      return generatorNames;
    }

    void setGenerator(value) {
      return setState(() {
        appState.selectedGenerator = value.toString();
        appState.selectedTopic = '';
        _answerFormatKey++;
        _topicListKey++;
      });
    }

    List<String> getGeneratorTopics() {
      for (var generator in appState.generators) {
        if (generator.name == appState.selectedGenerator) {
          return generator.topics;
        }
      }
      return [];
    }

    void setGeneratorTopic(value) {
      return setState(() {
        appState.selectedTopic = value.toString();
      });
    }

    List<String> getAnswerFormats() {
      for (var generator in appState.generators) {
        if (generator.name == appState.selectedGenerator) {
          return generator.answerFormats;
        }
      }
      return [];
    }

    void setAnswerFormat(value) {
      return setState(() {
        appState.selectedAnswerFormat = value.toString();
      });
    }

    List<String> getDifficulties() {
      return ['Trivial', 'Easy', 'Medium', 'Hard', 'Killer'];
    }

    void setDifficulty(value) {
      return setState(() {
        appState.selectedDifficulty = value.toString();
      });
    }

    return FutureBuilder(
        future: appState.futureFetchGenerators,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return genText('No generators found.');
            }
            return Form(
                key: _formKey,
                child: SizedBox(
                  width: 700,
                  child: ListView(children: [
                    // Page title
                    Padding(
                      padding: const EdgeInsets.all(padding * 3),
                      child: genText('Create a New Quiz',
                          size: 30, weight: FontWeight.bold),
                    ),

                    // Quiz Name and Generator
                    Row(
                      children: [
                        // Quiz Name
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: genTextFormField('Quiz Name', strValidator),
                          ),
                        ),

                        // horizontal spacing
                        SizedBox(width: 16),

                        // Quiz Generator
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: genDropdownMenu(0, 'Quiz Generator',
                                getGenerators, setGenerator),
                          ),
                        ),
                      ],
                    ),

                    // Quiz Topic and Answer Format
                    Row(
                      children: [
                        // Quiz Topic
                        if (appState.selectedGenerator == '')
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child: genDropdownMenu(
                                  _topicListKey,
                                  'Quiz Topic',
                                  () => ['Select generator to enter topic'],
                                  setGeneratorTopic),
                            ),
                          )
                        else if (getGeneratorTopics().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child: genDropdownMenu(
                                  _topicListKey,
                                  'Quiz Topic',
                                  getGeneratorTopics,
                                  setGeneratorTopic),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child:
                                  genTextFormField("Quiz Topic", strValidator),
                            ),
                          ),

                        // horizontal spacing
                        SizedBox(width: 16),

                        // Answer Format
                        if (appState.selectedGenerator == '')
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child: genDropdownMenu(
                                  _answerFormatKey,
                                  'Answer Format',
                                  () => [
                                        'Select generator to choose answer format'
                                      ],
                                  setAnswerFormat),
                            ),
                          )
                        else if (getAnswerFormats().length == 1)
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child: genDropdownMenu(
                                  _answerFormatKey,
                                  'Answer Format',
                                  getAnswerFormats,
                                  setAnswerFormat),
                            ),
                          )
                        else if (getAnswerFormats().length > 1)
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              child: genDropdownMenu(
                                  _answerFormatKey,
                                  'Answer Format',
                                  getAnswerFormats,
                                  setAnswerFormat),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: SizedBox(
                              width: columnWidth,
                              child: genText(
                                'No quiz answer formats available for ${appState.selectedGenerator} generator',
                              ),
                            ),
                          )
                      ],
                    ),

                    // Number of Questions and Difficulty Level
                    Row(
                      children: [
                        // Number of Questions
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: genTextFormField(
                                'Number of Questions', intValidator),
                          ),
                        ),

                        // horizontal spacing
                        SizedBox(width: 16),

                        // Difficulty Level
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: genDropdownMenu(0, 'Difficulty Level',
                                getDifficulties, setDifficulty),
                          ),
                        ),
                      ],
                    ),

                    // Submit button
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Align(
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: genText('Creating quiz...')),
                              );
                              print('calling createQuiz(data)');
                              appState.createQuiz();
                            }
                          },
                          child: genText('Submit'),
                        ),
                      ),
                    ),
                  ]),
                ));
          } else if (snapshot.hasError) {
            return genText('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }
}
