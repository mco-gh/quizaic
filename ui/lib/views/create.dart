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

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
  }

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

  Text genText(String text, {size = 14, weight = FontWeight.normal}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: size, fontWeight: weight));
  }

  TextFormField genTextFormField(appState, label, validator) {
    return TextFormField(
      initialValue: appState.selectedQuizName,
      onChanged: (value) => setState(() {
        appState.selectedQuizName = value.toString();
      }),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      // The validator receives the text that the user has entered.
      validator: validator,
    );
  }

  List<String> getSelectedGeneratorsTopics(appState) {
    for (var generator in appState.generators) {
      if (generator.name == appState.selectedGenerator) {
        return generator.topics;
      }
    }
    return [];
  }

  List<String> getSelectedGeneratorsAnswerFormats(appState) {
    for (var generator in appState.generators) {
      if (generator.name == appState.selectedGenerator) {
        return generator.answerFormats;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    // Build a Form widget using the _formKey created
    const padding = 6.0;
    const columnWidth = 285.0;
    const rowHeight = 52.0;

    return FutureBuilder(
        future: appState.futureFetchGenerators,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Text('No generators found.');
            }
            return Form(
                key: _formKey,
                child: SizedBox(
                  width: 650,
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: genText('Create a New Quiz',
                          size: 24, weight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: genTextFormField(
                                appState, 'Quiz Name', strValidator),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: DropdownMenu<String>(
                            initialSelection: appState.selectedGenerator,
                            onSelected: (value) => setState(() {
                              appState.selectedGenerator = value.toString();
                              appState.selectedTopic = '';
                              _answerFormatKey++;
                            }),
                            width: columnWidth,
                            label: genText('Quiz generator'),
                            dropdownMenuEntries: [
                              for (var generator in snapshot.data!)
                                DropdownMenuEntry(
                                  label: generator.name,
                                  value: generator.name,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          if (appState.selectedGenerator == '')
                            Row(children: [
                              SizedBox(
                                  width: columnWidth,
                                  child: genText(
                                      'Select generator to choose topic')),
                            ])
                          else if (getSelectedGeneratorsTopics(appState)
                              .isNotEmpty)
                            Row(children: [
                              DropdownMenu<String>(
                                  key: ValueKey(_answerFormatKey),
                                  initialSelection: appState.selectedTopic,
                                  onSelected: (value) => setState(() {
                                        appState.selectedTopic =
                                            value.toString();
                                      }),
                                  width: columnWidth,
                                  label: genText('Quiz Topic'),
                                  dropdownMenuEntries: [
                                    for (var topic
                                        in getSelectedGeneratorsTopics(
                                            appState))
                                      DropdownMenuEntry(
                                        label: topic,
                                        value: topic,
                                      ),
                                  ]),
                            ])
                          else
                            Row(children: [
                              SizedBox(
                                width: columnWidth,
                                height: rowHeight,
                                child: genTextFormField(
                                    appState, "Quiz Topic", strValidator),
                              ),
                            ]),
                          if (appState.selectedGenerator == '')
                            Row(children: [
                              SizedBox(width: 16),
                              SizedBox(
                                width: columnWidth,
                                child: genText(
                                    'Select generator to choose answer format'),
                              ),
                            ])
                          else if (getSelectedGeneratorsAnswerFormats(appState)
                                  .length ==
                              1)
                            Row(children: [
                              SizedBox(width: 16),
                              SizedBox(
                                width: columnWidth,
                                child: DropdownMenu<String>(
                                    key: ValueKey(_answerFormatKey),
                                    initialSelection:
                                        getSelectedGeneratorsAnswerFormats(
                                            appState)[0],
                                    onSelected: (value) => setState(() {
                                          appState.selectedAnswerFormat =
                                              value.toString();
                                        }),
                                    width: columnWidth,
                                    label: genText('Answer Format'),
                                    dropdownMenuEntries: [
                                      for (var type
                                          in getSelectedGeneratorsAnswerFormats(
                                              appState))
                                        DropdownMenuEntry(
                                          label: type,
                                          value: type,
                                        ),
                                    ]),
                              ),
                            ])
                          else if (getSelectedGeneratorsAnswerFormats(appState)
                                  .length >
                              1)
                            Row(children: [
                              SizedBox(width: 16),
                              SizedBox(
                                width: columnWidth,
                                child: DropdownMenu<String>(
                                    key: ValueKey(_answerFormatKey),
                                    initialSelection:
                                        appState.selectedAnswerFormat,
                                    onSelected: (value) => setState(() {
                                          appState.selectedAnswerFormat =
                                              value.toString();
                                        }),
                                    width: columnWidth,
                                    label: genText('Answer Format'),
                                    dropdownMenuEntries: [
                                      for (var type
                                          in getSelectedGeneratorsAnswerFormats(
                                              appState))
                                        DropdownMenuEntry(
                                          label: type,
                                          value: type,
                                        ),
                                    ]),
                              ),
                            ])
                          else
                            Row(children: [
                              SizedBox(width: 16),
                              SizedBox(
                                width: columnWidth,
                                child: Text(
                                    'No quiz answer formats available for ${appState.selectedGenerator} generator',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Align(
                            child: SizedBox(
                              width: columnWidth,
                              height: rowHeight,
                              child: genTextFormField(appState,
                                  'Number of Questions', intValidator),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: DropdownMenu<String>(
                            initialSelection: appState.selectedDifficulty,
                            onSelected: (value) => setState(() {
                              appState.selectedDifficulty = value.toString();
                            }),
                            width: columnWidth,
                            label: const Text('Difficulty Level'),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                label: 'Trivial',
                                value: 'Trivial',
                              ),
                              DropdownMenuEntry(
                                label: 'Easy',
                                value: 'Easy',
                              ),
                              DropdownMenuEntry(
                                label: 'Medium',
                                value: 'Medium',
                              ),
                              DropdownMenuEntry(
                                label: 'Hard',
                                value: 'Hard',
                              ),
                              DropdownMenuEntry(
                                label: 'Killer',
                                value: 'Killer',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                                const SnackBar(
                                    content: Text('Creating quiz...')),
                              );
                              print('calling createQuiz(data)');
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ),
                  ]),
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }
}
