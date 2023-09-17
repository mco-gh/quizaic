import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizaic/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Synchronous { synchronous, asynchronous }

enum Anonymous { anonymous, authenticated }

enum ActivityType { quiz, survey }

enum YN { yes, no }

class HostPage extends StatefulWidget {
  final String? quizId;

  @override
  State<HostPage> createState() => _HostPageState();

  HostPage({this.quizId});
}

final _formKey = GlobalKey<FormState>();

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

class _HostPageState extends State<HostPage> {
  _HostPageState();

  @override
  void initState() {
    super.initState();

    print('initState - quiz id: ${widget.quizId}');
  }

  @override
  Widget build(BuildContext context) {
    print('hosting quiz: ${widget.quizId}');
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);

    // Build a Form widget using the _formKey created

    Text genText(String text, {size = 14, weight = FontWeight.normal}) {
      return Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: size, fontWeight: weight, color: theme.primaryColor));
    }

    TextFormField genTextFormField(label, validator, getter, setter) {
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

    DropdownMenu<String> genDropdownMenu(key, text, current, getter, setter) {
      var initialSelection = current; //getter()[0];
      //if (text == "Quiz Generator") {
      //initialSelection = null;
      //}
      return DropdownMenu<String>(
          textStyle: TextStyle(color: theme.primaryColor),
          key: ValueKey(key),
          controller: TextEditingController(),
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

    void setHostSynch(value) {
      return setState(() {
        appState.hostSynch = value.toString();
      });
    }

    String getHostTimeLimit() {
      return appState.hostTimeLimit;
    }

    void setHostTimeLimit(value) {
      return setState(() {
        appState.hostTimeLimit = value.toString();
      });
    }

    void setHostType(value) {
      return setState(() {
        appState.hostType = value.toString();
      });
    }

    void setHostAnonymous(value) {
      return setState(() {
        appState.hostAnonymous = value.toString();
      });
    }

    void setHostRandomizeQuestions(value) {
      return setState(() {
        appState.hostRandomizeQuestions = value.toString();
      });
    }

    void setHostRandomizeAnswers(value) {
      return setState(() {
        appState.hostRandomizeAnswers = value.toString();
      });
    }

    Card genCard(widget) {
      return Card(
          //shape:
          //RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: widget,
          ));
    }

    if (quiz == null) {
      return Center(
        child: genText('No quiz selected for hosting'),
      );
    }

    String title = 'Hosting Quiz "${quiz.name}"';
    if (appState.sessionId != '') {
      print('appState.sessionId: ${appState.sessionId}');
      return StreamBuilder<DocumentSnapshot>(
          stream: appState.sessionStream,
          builder: (context, snapshot) {
            if (snapshot.data?.data() == null) {
              return Text('Hosting Quiz...');
            }
            var data = snapshot.data!.data() as Map<String, dynamic>;
            var curQuestion = int.parse(data['curQuestion']);
            var question = jsonDecode(quiz.qAndA!)[curQuestion]['question'];

            return Column(
              children: [
                genText('Hosting Quiz "${quiz.name}", Pin: ${data["pin"]}'),
                SizedBox(height: 20),
                genCard(genText('Question $curQuestion: $question')),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var answer in jsonDecode(quiz.qAndA!)[curQuestion]
                      ['responses'])
                    genCard(genText(answer)),
                ]),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    appState.incQuestion(appState.sessionId, curQuestion);
                  },
                  child: genText('Next Question'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    appState.stopHostQuiz();
                  },
                  child: genText('Stop Quiz'),
                ),
              ],
            );
          });
    }

    return Center(
      child: Form(
          key: _formKey,
          child: SizedBox(
            width: 700,
            child: ListView(children: [
              // Page title
              Padding(
                padding: const EdgeInsets.all(padding * 3),
                child: genText(title, size: 30, weight: FontWeight.bold),
              ),
              Hero(
                tag: quiz.id as String,
                child: Image.network(quiz.imageUrl as String, height: 170),
              ),
              SizedBox(height: 20),
              // Synch or Asynch and Time Limit
              Row(
                children: [
                  // Sync/Async
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          _formKey,
                          'Synch or Asynch',
                          appState.hostSynch,
                          () => ['Synchronous', 'Asynchronous'],
                          setHostSynch),
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
                      child: genTextFormField(
                          'Per Question Time Limit (seconds)',
                          intValidator,
                          getHostTimeLimit,
                          setHostTimeLimit),
                    ),
                  ),
                ],
              ),

              // Quiz/Survey and Anonymous
              Row(
                children: [
                  // Quiz or Survey
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          _formKey,
                          'Quiz or Survey',
                          appState.hostType,
                          () => ['Quiz', 'Survey'],
                          setHostType),
                    ),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          _formKey,
                          'Anonymous or Authenticated',
                          appState.hostAnonymous,
                          () => ['Anonymous', 'Autheticated'],
                          setHostAnonymous),
                    ),
                  ),
                ],
              ),

              // Randomize Questions and Answers
              Row(
                children: [
                  // Randomize Questions
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          _formKey,
                          'Randomize Questions',
                          appState.hostRandomizeQuestions,
                          () => ['Yes', 'No'],
                          setHostRandomizeQuestions),
                    ),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  // Randomize Answers
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genDropdownMenu(
                          _formKey,
                          'Randomize Answers',
                          appState.hostRandomizeAnswers,
                          () => ['Yes', 'No'],
                          setHostRandomizeAnswers),
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
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: genText('Hosting quiz...')),
                        );
                        print('creating session...');
                        appState.createSession(quiz.id);
                      }
                    },
                    child: genText('Start ${appState.hostType}'),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
