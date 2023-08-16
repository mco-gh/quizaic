import 'package:flutter/material.dart';
import 'package:quizrd/models/state.dart';
import 'package:provider/provider.dart';

enum Synch { synchronous, asynchronous }

enum Anon { anonymous, authenticated }

enum ActivityType { quiz, survey }

enum YN { yes, no }

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => _CreatePageState();
}

final _formKey = GlobalKey<FormState>();

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
  }

  List<String> getSelectedGeneratorsTopicList(appState) {
    for (var generator in appState.generators) {
      if (generator.name == appState.selectedGenerator) {
        return generator.topicList.split(',');
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
                  width: 600,
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Create a New Quiz',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: TextFormField(
                        initialValue: appState.selectedQuizName,
                        onChanged: (value) => setState(() {
                          appState.selectedQuizName = value.toString();
                        }),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quiz name',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing quiz name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          DropdownMenu<String>(
                            initialSelection: appState.selectedGenerator,
                            onSelected: (value) => setState(() {
                              appState.selectedGenerator = value.toString();
                            }),
                            width: 285,
                            label: const Text('Quiz generator'),
                            dropdownMenuEntries: [
                              for (var generator in snapshot.data!)
                                DropdownMenuEntry(
                                  label: generator.name,
                                  value: generator.name,
                                ),
                            ],
                          ),
                          SizedBox(width: 18),
                          DropdownMenu<String>(
                            initialSelection: appState.selectedTopic,
                            onSelected: (value) => setState(() {
                              appState.selectedTopic = value.toString();
                            }),
                            width: 285,
                            label: const Text('Quiz Topic'),
                            dropdownMenuEntries: [
                              for (var topic
                                  in getSelectedGeneratorsTopicList(appState))
                                DropdownMenuEntry(
                                  label: topic,
                                  value: topic,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Align(
                            child: SizedBox(
                              width: 285,
                              child: TextFormField(
                                initialValue:
                                    appState.selectedNumQuestions?.toString(),
                                onChanged: (value) => setState(() {
                                  appState.selectedNumQuestions =
                                      int.parse(value);
                                }),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Number of Questions',
                                ),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Must be an integer greater than zero';
                                  }
                                  return null;
                                },
                              ),
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
                            width: 285,
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

/*
// The following form fields are quiz run-time, not create-time,
// so they should be presented to the host when starting a quiz.
const SizedBox(width: 22),
SizedBox(
width: 281,
child: TextFormField(
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Seconds to respond',
  ),
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Must be an integer greater than zero';
    }
    return null;
  },
),
),
const SizedBox(width: 20),
DropdownMenu<YN>(
  width: 181,
  label: const Text('Randomize Questions'),
  dropdownMenuEntries: [
    DropdownMenuEntry(
      label: 'Yes',
      value: YN.yes,
    ),
    DropdownMenuEntry(
      label: 'No',
      value: YN.no,
    ),
  ],
),
const SizedBox(width: 20),
DropdownMenu<YN>(
  width: 181,
  label: const Text('Randomize Answers'),
  dropdownMenuEntries: [
    DropdownMenuEntry(
      label: 'Yes',
      value: YN.yes,
    ),
    DropdownMenuEntry(
      label: 'No',
      value: YN.no,
    ),
  ],
),
*/
