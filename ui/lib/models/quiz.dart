class Quiz {
  // provided by quiz creator (in order of appearance on create quiz form)
  final String name;
  final String answerFormat;
  final String generator;
  final String topic;
  final String numQuestions;
  final String difficulty;

  // managed by firestore (in alphabetical order)
  final String? id;
  final String? selfLink;
  final String? timeCreated;
  final String? updated;

  //. managed by backend api (in alphabetical order)
  final bool? active;
  final bool? anonymous;
  final String? creator;
  final String? curQuestion;
  final String? imageUrl;
  final String? pin;
  final String? playUrl;
  final String? qAndA;
  final String? results;
  final String? runCount;
  final String? temperature; // surface to quiz creator?

  // quiz runtime settings (in alphabetical order)
  final bool? randomizeQuestions;
  final bool? randomizeAnswers;
  final bool? survey;
  final bool? synchronous;
  final String? timeLimit;

  // obsolete?
  final String? description;
  final String? numAnswers;
  final String? topicFormat;

  const Quiz({
    // provided by quiz creator (in order of appearance on create quiz form)
    required this.name,
    required this.answerFormat,
    required this.generator,
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
    this.results,
    this.runCount,
    this.temperature,

    // quiz runtime settings (in alphabetical order)
    this.randomizeQuestions,
    this.randomizeAnswers,
    this.survey,
    this.synchronous,
    this.timeLimit,

    // obsolete?
    this.description,
    this.numAnswers,
    this.topicFormat,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      // provided by quiz creator (in order of appearance on create quiz form)
      name: json['name'],
      answerFormat: json['answerFormat'],
      generator: json['generator'],
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
      anonymous: json['anon'],
      creator: json['creator'],
      curQuestion: json['curQuestion'],
      imageUrl: json['imageUrl'],
      pin: json['pin'],
      playUrl: json['playUrl'],
      qAndA: json['QandA'],
      results: json['results'],
      runCount: json['runCount'],
      temperature: json['temperature'],

      // quiz runtime settings (in alphabetical order)
      randomizeQuestions: json['randomQ'],
      randomizeAnswers: json['randomA'],
      survey: json['survey'],
      synchronous: json['sync'],
      timeLimit: json['timeLimit'],

      // obsolete?
      description: json['description'],
      numAnswers: json['numAnswers'],
      topicFormat: json['topicFormat'],
    );
  }
}
