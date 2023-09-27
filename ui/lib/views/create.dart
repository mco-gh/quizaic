import 'package:flutter/material.dart';
import 'package:quizaic/const.dart';
import 'package:quizaic/models/state.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quizaic/models/quiz.dart';
import 'package:quizaic/views/helpers.dart';

class CreatePage extends StatefulWidget {
  final String? quizId;
  final bool readOnly;

  @override
  State<CreatePage> createState() => _CreatePageState();

  CreatePage({this.quizId, this.readOnly = false});
}

final _formKey = GlobalKey<FormState>();
int _generatorKey = 0;
int _answerFormatKey = 0;
int _topicListKey = 0;

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var quiz = appState.getQuiz(widget.quizId);

    if (appState.idToken == null || appState.idToken == '') {
      return Center(
          child: genText(theme,
              'Please sign in, by clicking the person icon at upper right, to create quizzes.'));
    }

    String getQuizName() {
      return appState.editQuiz.name;
    }

    void setQuizName(value) {
      return setState(() {
        appState.editQuiz.name = value.toString();
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
      appState.editQuiz.generator = value.toString();
      return setState(() {
        print('selecting generator: $value');
        appState.editQuiz.generator = value.toString();
        appState.editQuiz.topic = '';
        _answerFormatKey++;
        _topicListKey++;
      });
    }

    List<String> getTopics() {
      for (var generator in appState.generators) {
        if (generator.name == appState.editQuiz.generator) {
          return generator.topics;
        }
      }
      return [];
    }

    String getTopic() {
      return appState.editQuiz.topic;
    }

    void setTopic(value) {
      return setState(() {
        appState.editQuiz.topic = value.toString();
      });
    }

    List<String> getAnswerFormats() {
      for (var generator in appState.generators) {
        if (generator.name == appState.editQuiz.generator) {
          return generator.answerFormats;
        }
      }
      return [];
    }

    void setAnswerFormat(value) {
      return setState(() {
        appState.editQuiz.answerFormat = value.toString();
      });
    }

    String getNumQuestions() {
      return appState.editQuiz.numQuestions;
    }

    void setNumQuestions(value) {
      return setState(() {
        appState.editQuiz.numQuestions = value.toString();
      });
    }

    List<String> getDifficulties() {
      return difficultyLevel;
    }

    void setDifficulty(value) {
      return setState(() {
        appState.editQuiz.difficulty = value.toString();
      });
    }

    String title = '';
    String snack = '';
    Quiz? quizToCreateOrUpdate;
    if (quiz == null) {
      title = 'Create Quiz';
      snack = 'Creating new quiz...';
      quizToCreateOrUpdate = null;
    } else if (quiz.id == '') {
      title = 'Clone Quiz';
      snack = 'Creating cloned quiz...';
      quizToCreateOrUpdate = quiz;
    } else if (quiz.id != '' && !widget.readOnly) {
      title = 'Edit Quiz';
      snack = 'Updating quiz...';
      quizToCreateOrUpdate = quiz;
    } else {
      title = 'View Quiz';
    }

    Widget quizNameWidget = genQuizNameWidget(
        theme, widget.readOnly, quiz, getQuizName, setQuizName);

    Widget quizGeneratorWidget = genQuizGeneratorWidget(theme, widget.readOnly,
        quiz, _generatorKey, appState, getGenerators, setGenerator);

    Widget quizTopicWidget = genQuizTopicWidget(theme, widget.readOnly, quiz,
        _topicListKey, appState, getTopics, setTopic);

    Widget quizAnswerFormatWidget = genQuizAnswerFormatWidget(
        theme,
        widget.readOnly,
        quiz,
        _answerFormatKey,
        appState,
        getAnswerFormats,
        setAnswerFormat);

    Widget quizNumQuestionsWidget = genTextFormField(theme,
        'Number of Questions', intValidator, getNumQuestions, setNumQuestions);

    Widget quizDifficultyWidget = genQuizDifficultyWidget(
        theme,
        widget.readOnly,
        quiz,
        _formKey,
        appState,
        getDifficulties,
        setDifficulty);

    return Center(
      child: Form(
          key: _formKey,
          child: SizedBox(
            width: rowWidth,
            child: ListView(children: [
              // Page title and image
              SizedBox(height: verticalSpaceHeight * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (quiz != null)
                    Hero(
                      tag: quiz.id as String,
                      child: Image.network(
                        quiz.imageUrl as String,
                        height: logoHeight,
                      ),
                    ),
                  SizedBox(width: horizontalSpaceWidth / 2),
                  genText(theme, title, size: 30, weight: FontWeight.bold),
                ],
              ),
              SizedBox(height: verticalSpaceHeight * 2),

              // Quiz Name
              quizNameWidget,
              SizedBox(height: verticalSpaceHeight),

              // Quiz Generator
              quizGeneratorWidget,
              SizedBox(height: verticalSpaceHeight),

              // Quiz Topic
              if (getTopics().isNotEmpty || widget.readOnly)
                quizTopicWidget
              else if (appState.editQuiz.generator == '')
                genDropdownMenu(
                    theme,
                    'Quiz Topic',
                    _topicListKey,
                    formColumnWidth,
                    appState.editQuiz.topic,
                    () => ['Select generator to see topics'],
                    setTopic)
              else
                genTextFormField(
                    theme,
                    'No quiz answer formats available for ${appState.editQuiz.generator} generator',
                    strValidator,
                    getTopic,
                    setTopic),
              SizedBox(height: verticalSpaceHeight),

              // Answer Format
              if (appState.editQuiz.answerFormat != '')
                quizAnswerFormatWidget
              else if (appState.editQuiz.generator == '')
                genDropdownMenu(
                    theme,
                    'Answer Format',
                    _answerFormatKey,
                    formColumnWidth,
                    appState.editQuiz.answerFormat,
                    () => ['Select generator to see formats'],
                    setAnswerFormat)
              else if (getAnswerFormats().length == 1)
                genDropdownMenu(
                    theme,
                    'Answer Format',
                    _answerFormatKey,
                    formColumnWidth,
                    getAnswerFormats()[0],
                    getAnswerFormats,
                    setAnswerFormat)
              else if (getAnswerFormats().length > 1)
                genDropdownMenu(
                    theme,
                    'Answer Format',
                    _answerFormatKey,
                    formColumnWidth,
                    appState.editQuiz.answerFormat,
                    getAnswerFormats,
                    setAnswerFormat)
              else
                genText(
                  theme,
                  'No quiz answer formats available for ${appState.editQuiz.generator} generator',
                ),
              SizedBox(height: verticalSpaceHeight),

              // Number of Questions
              quizNumQuestionsWidget,
              SizedBox(height: verticalSpaceHeight),

              // Difficulty Level
              quizDifficultyWidget,
              SizedBox(height: verticalSpaceHeight),

              // Submit button
              SizedBox(height: verticalSpaceHeight),

              if (!widget.readOnly)
                Padding(
                  padding: const EdgeInsets.all(formPadding),
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
                                content: genText(theme, snack)),
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
                      child: genText(theme, 'Save Quiz'),
                    ),
                  ),
                ),
              SizedBox(height: formRowHeight),
              if (quiz != null)
                SizedBox(
                  width: formColumnWidth,
                  child: ExpansionTile(
                      title: genText(theme, 'Quiz Contents'),
                      children: [genQuestionList(theme, quiz, appState)]),
                ),
            ]),
          )),
    );
  }
}
