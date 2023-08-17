class Quiz {
  // provided by quiz creator (in order of appearance on create quiz form)
  final String name;
  final String generator;
  final String answerFormat;
  final String topic;
  final String numQuestions;
  final String difficulty;

  // managed by firestore (in alphabetical order)
  final String? id;
  final String? selfLink;
  final String? timeCreated;
  final String? updated;

  // managed by backend api (in alphabetical order)
  final bool? active;
  final bool? anonymous;
  final String? creator;
  final String? curQuestion;
  final String? imageUrl;
  final String? pin;
  final String? playUrl;
  final String? qAndA;
  final String? runCount;
  final String? temperature; // surface to quiz creator?

  // quiz runtime settings (in alphabetical order)
  final bool? randomizeQuestions;
  final bool? randomizeAnswers;
  final bool? survey;
  final bool? synchronous;
  final String? timeLimit;

  // Obsolete?
  final String? description;
  final String? numAnswers;

  const Quiz({
    // provided by quiz creator (in order of appearance on create quiz form)
    required this.name,
    required this.generator,
    required this.answerFormat,
    required this.topic,
    required this.numQuestions,
    required this.difficulty,

    // managed by firestore (in alphabetical order)
    this.id,
    this.selfLink,
    this.timeCreated,
    this.updated,

    //. managed by backend api (in alphabetical order)
    this.active,
    this.anonymous,
    this.creator,
    this.curQuestion,
    this.imageUrl,
    this.pin,
    this.playUrl,
    this.qAndA,
    this.runCount,
    this.temperature,

    // quiz runtime settings (in alphabetical order)
    this.randomizeQuestions,
    this.randomizeAnswers,
    this.survey,
    this.synchronous,
    this.timeLimit,

    // Obsolete?
    this.description,
    this.numAnswers,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      // provided by quiz creator (in order of appearance on create quiz form)
      name: json['name'],
      generator: json['generator'],
      answerFormat: json['answerFormat'],
      topic: json['topic'],
      numQuestions: json['numQuestions'],
      difficulty: json['difficulty'],

      // managed by firestore (in alphabetical order)
      id: json['id'],
      selfLink: json['selfLink'],
      timeCreated: json['timeCreated'],
      updated: json['updated'],

      //. managed by backend api (in alphabetical order)
      active: json['active'],
      anonymous: json['anonymous'],
      creator: json['creator'],
      curQuestion: json['curQuestion'],
      imageUrl: json['imageUrl'],
      pin: json['pin'],
      playUrl: json['playUrl'],
      qAndA: json['qAndA'],
      runCount: json['runCount'],
      temperature: json['temperature'],

      // quiz runtime settings (in alphabetical order)
      randomizeQuestions: json['randomizeQuestions'],
      randomizeAnswers: json['randomizeAnswers'],
      survey: json['survey'],
      synchronous: json['synchronous'],
      timeLimit: json['timeLimit'],

      // Obsolete?
      description: json['description'],
      numAnswers: json['numAnswers'],
    );
  }
}
