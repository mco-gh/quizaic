import 'package:flutter/material.dart';
import 'package:quizaic/models/state.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quizaic/models/quiz.dart';
import 'dart:convert';

enum Synchronous { synchronous, asynchronous }

enum Anonymous { anonymous, authenticated }

enum ActivityType { quiz, survey }

enum YN { yes, no }

class CreatePage extends StatefulWidget {
  final String? quizId;

  @override
  State<CreatePage> createState() => _CreatePageState();

  CreatePage({this.quizId});
}

final _formKey = GlobalKey<FormState>();
int _generatorKey = 0;
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
    print('widget.quizId: ${widget.quizId}');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);
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
      var initialSelection = current;
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

    String getQuizName() {
      return appState.selectedQuizName;
    }

    void setQuizName(value) {
      return setState(() {
        appState.selectedQuizName = value.toString();
      });
    }

    List<String> getGenerators() {
      List<String> generatorNames = [];
      for (var generator in appState.generators) {
        generatorNames.add(generator.name);
      }
      return generatorNames;
    }

    void setGenerator(value) {
      appState.selectedGenerator = value.toString();
      return setState(() {
        print('selecting generator: $value');
        appState.selectedGenerator = value.toString();
        appState.selectedTopic = '';
        _answerFormatKey++;
        _topicListKey++;
      });
    }

    List<String> getTopics() {
      for (var generator in appState.generators) {
        if (generator.name == appState.selectedGenerator) {
          return generator.topics;
        }
      }
      return [];
    }

    String getTopic() {
      return appState.selectedTopic;
    }

    void setTopic(value) {
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

    String getNumQuestions() {
      return appState.selectedNumQuestions;
    }

    void setNumQuestions(value) {
      return setState(() {
        appState.selectedNumQuestions = value.toString();
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

    Column genQuestionList() {
      List<Widget> widgets = [];
      List<Widget> subwidgets = [];
      List<String> option = ['A', 'B', 'C', 'D'];
      int i = 0;
      int j = 0;
      if (quiz == null) {
        return Column();
      }
      var qAndA = jsonDecode(quiz.qAndA as String);
      for (var question in qAndA) {
        j = 0;
        subwidgets = [];
        widgets.add(genText('question ${i + 1}: ${question["question"]}'));
        if (quiz.answerFormat == "multiple choice") {
          for (var answer in question["responses"]) {
            subwidgets.add(genText('response ${option[j]}: $answer'));
            j++;
          }
        } else {
          subwidgets.add(genText('Answer: ${question["correct"]}'));
        }
        widgets.add(Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subwidgets),
        ));
        i++;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }

    String title = '';
    String snack = '';
    Quiz? quizToCreateOrUpdate;
    if (quiz == null) {
      title = 'Create a Quiz';
      snack = 'Creating new quiz...';
      quizToCreateOrUpdate = null;
    } else if (quiz.id == '') {
      title = 'Clone a Quiz';
      snack = 'Creating cloned quiz...';
      quizToCreateOrUpdate = quiz;
    } else {
      title = 'Edit a Quiz';
      snack = 'Updating quiz...';
      quizToCreateOrUpdate = quiz;
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
              if (quiz != null)
                Hero(
                    tag: quiz.id as String,
                    child: Image.network(quiz.imageUrl as String, height: 170)),
              SizedBox(height: 20),
              // Quiz Name and Generator
              Row(
                children: [
                  // Quiz Name
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: genTextFormField(
                          'Quiz Name', strValidator, getQuizName, setQuizName),
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
                      child: genDropdownMenu(
                          _generatorKey,
                          'Quiz Generator',
                          appState.selectedGenerator,
                          getGenerators,
                          setGenerator),
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
                            appState.selectedTopic,
                            () => ['Select generator to see topics'],
                            setTopic),
                      ),
                    )
                  else if (getTopics().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: genDropdownMenu(_topicListKey, 'Quiz Topic',
                            appState.selectedTopic, getTopics, setTopic),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: genTextFormField(
                            'No quiz answer formats available for ${appState.selectedGenerator} generator',
                            strValidator,
                            getTopic,
                            setTopic),
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
                            appState.selectedAnswerFormat,
                            () => ['Select generator to see formats'],
                            setAnswerFormat),
                      ),
                    )
                  else if (appState.selectedAnswerFormat != '')
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: genDropdownMenu(
                            _answerFormatKey,
                            'Answer Format',
                            appState.selectedAnswerFormat,
                            getAnswerFormats,
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
                            getAnswerFormats()[0],
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
                            appState.selectedAnswerFormat,
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
                      child: genTextFormField('Number of Questions',
                          intValidator, getNumQuestions, setNumQuestions),
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
                      child: genDropdownMenu(
                          _formKey,
                          'Difficulty Level',
                          appState.selectedDifficulty,
                          getDifficulties,
                          setDifficulty),
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
                          SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: genText(snack)),
                        );
                        appState.createOrUpdateQuiz(
                            context, quizToCreateOrUpdate);
                        setState(() {
                          appState.selectedIndex = 0;
                          appState.selectedPageIndex = 0;
                        });
                        GoRouter.of(context).go('/browse');
                      }
                    },
                    child: genText('Save Quiz'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ExpansionTile(
                  title: genText('Quiz Contents'),
                  children: [genQuestionList()]),
            ]),
          )),
    );
  }
}
