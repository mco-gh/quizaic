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

const padding = 6.0;
const columnWidth = 325.0;
const rowHeight = 52.0;

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

    String getQuizName() {
      return appState.selectedQuiz.name;
    }

    void setQuizName(value) {
      return setState(() {
        appState.selectedQuiz.name = value.toString();
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
      appState.selectedQuiz.generator = value.toString();
      return setState(() {
        print('selecting generator: $value');
        appState.selectedQuiz.generator = value.toString();
        appState.selectedQuiz.topic = '';
        _answerFormatKey++;
        _topicListKey++;
      });
    }

    List<String> getTopics() {
      for (var generator in appState.generators) {
        if (generator.name == appState.selectedQuiz.generator) {
          return generator.topics;
        }
      }
      return [];
    }

    String getTopic() {
      return appState.selectedQuiz.topic;
    }

    void setTopic(value) {
      return setState(() {
        appState.selectedQuiz.topic = value.toString();
      });
    }

    List<String> getAnswerFormats() {
      for (var generator in appState.generators) {
        if (generator.name == appState.selectedQuiz.generator) {
          return generator.answerFormats;
        }
      }
      return [];
    }

    void setAnswerFormat(value) {
      return setState(() {
        appState.selectedQuiz.answerFormat = value.toString();
      });
    }

    String getNumQuestions() {
      return appState.selectedQuiz.numQuestions;
    }

    void setNumQuestions(value) {
      return setState(() {
        appState.selectedQuiz.numQuestions = value.toString();
      });
    }

    List<String> getDifficulties() {
      return difficultyLevel;
    }

    void setDifficulty(value) {
      return setState(() {
        appState.selectedQuiz.difficulty = value.toString();
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

    Widget quizNameWidget;
    if (widget.readOnly && quiz != null) {
      quizNameWidget = genLabelValue(theme, 'Name:', quiz.name);
    } else {
      quizNameWidget = genTextFormField(
          theme, 'Quiz Name', strValidator, getQuizName, setQuizName);
    }

    Widget quizGeneratorWidget;
    if (widget.readOnly && quiz != null) {
      quizGeneratorWidget =
          genLabelValue(theme, 'Quiz Generator:', quiz.generator);
    } else {
      quizGeneratorWidget = genDropdownMenu(
          theme,
          'Quiz Generator',
          _generatorKey,
          columnWidth,
          appState.selectedQuiz.generator,
          getGenerators,
          setGenerator);
    }

    Widget quizTopicWidget;
    if (widget.readOnly && quiz != null) {
      quizTopicWidget = genLabelValue(theme, 'Quiz Topic:', quiz.topic);
    } else {
      quizTopicWidget = genDropdownMenu(theme, 'Quiz Topic', _topicListKey,
          columnWidth, appState.selectedQuiz.topic, getTopics, setTopic);
    }

    Widget quizAnswerFormatWidget;
    if (widget.readOnly && quiz != null) {
      quizAnswerFormatWidget =
          genLabelValue(theme, 'Answer Format:', quiz.answerFormat);
    } else {
      quizAnswerFormatWidget = genDropdownMenu(
          theme,
          'Answer Format',
          _answerFormatKey,
          columnWidth,
          appState.selectedQuiz.answerFormat,
          getAnswerFormats,
          setAnswerFormat);
    }

    Widget quizNumQuestionsWidget;
    if (widget.readOnly && quiz != null) {
      quizNumQuestionsWidget =
          genLabelValue(theme, 'Number of Questions:', quiz.numQuestions);
    } else {
      quizNumQuestionsWidget = genTextFormField(theme, 'Number of Questions',
          intValidator, getNumQuestions, setNumQuestions);
    }

    Widget quizDifficultyWidget;
    if (widget.readOnly && quiz != null) {
      quizDifficultyWidget =
          genLabelValue(theme, 'Diffiulty Level:', quiz.difficulty);
    } else {
      quizDifficultyWidget = genDropdownMenu(
          theme,
          'Difficulty Level',
          _formKey,
          columnWidth,
          appState.selectedQuiz.difficulty,
          getDifficulties,
          setDifficulty);
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
                child: genText(theme, title, size: 30, weight: FontWeight.bold),
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
                      child: quizNameWidget,
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
                      child: quizGeneratorWidget,
                    ),
                  ),
                ],
              ),

              // Quiz Topic and Answer Format
              Row(
                children: [
                  // Quiz Topic
                  if (getTopics().isNotEmpty || widget.readOnly)
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: quizTopicWidget,
                      ),
                    )
                  else if (appState.selectedQuiz.generator == '')
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: quizTopicWidget = genDropdownMenu(
                            theme,
                            'Quiz Topic',
                            _topicListKey,
                            columnWidth,
                            appState.selectedQuiz.topic,
                            () => ['Select generator to see topics'],
                            setTopic),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: genTextFormField(
                            theme,
                            'No quiz answer formats available for ${appState.selectedQuiz.generator} generator',
                            strValidator,
                            getTopic,
                            setTopic),
                      ),
                    ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  // Answer Format
                  if (appState.selectedQuiz.answerFormat != '')
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                          width: columnWidth,
                          height: rowHeight,
                          child: quizAnswerFormatWidget),
                    )
                  else if (appState.selectedQuiz.generator == '')
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: genDropdownMenu(
                            theme,
                            'Answer Format',
                            _answerFormatKey,
                            columnWidth,
                            appState.selectedQuiz.answerFormat,
                            () => ['Select generator to see formats'],
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
                            theme,
                            'Answer Format',
                            _answerFormatKey,
                            columnWidth,
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
                            theme,
                            'Answer Format',
                            _answerFormatKey,
                            columnWidth,
                            appState.selectedQuiz.answerFormat,
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
                          theme,
                          'No quiz answer formats available for ${appState.selectedQuiz.generator} generator',
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
                        child: quizNumQuestionsWidget),
                  ),

                  // horizontal spacing
                  SizedBox(width: 16),

                  // Difficulty Level
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: columnWidth,
                      height: rowHeight,
                      child: quizDifficultyWidget,
                    ),
                  ),
                ],
              ),

              // Submit button
              SizedBox(height: 20),
              if (!widget.readOnly)
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
              SizedBox(height: 20),
              ExpansionTile(
                  title: genText(theme, 'Quiz Contents'),
                  children: [genQuestionList(theme, quiz)]),
            ]),
          )),
    );
  }
}
