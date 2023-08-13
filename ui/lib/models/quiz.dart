class Quiz {
  final String id;
  final String timeCreated;
  final String updated;
  final String selfLink;
  final String curQuestion;
  final String creator;
  final String pin;
  final String playUrl;
  final String name;
  final String description;
  final String generator;
  final String topicFormat;
  final String answerFormat;
  final String topic;
  final String imageUrl;
  final String numQuestions;
  final String numAnswers;
  final String timeLimit;
  final String difficulty;
  final String temperature;
  final bool? sync;
  final bool? anon;
  final bool? randomQ;
  final bool? randomA;
  final bool? survey;
  final String qAndA;
  final String runCount;
  final bool? active;
  final String? results;

  const Quiz({
    required this.id,
    required this.timeCreated,
    required this.updated,
    required this.selfLink,
    required this.curQuestion,
    required this.creator,
    required this.pin,
    required this.playUrl,
    required this.name,
    required this.description,
    required this.generator,
    required this.topicFormat,
    required this.answerFormat,
    required this.topic,
    required this.imageUrl,
    required this.numQuestions,
    required this.numAnswers,
    required this.timeLimit,
    required this.difficulty,
    required this.temperature,
    required this.sync,
    required this.anon,
    required this.randomQ,
    required this.randomA,
    required this.survey,
    required this.qAndA,
    required this.runCount,
    required this.active,
    required this.results,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    print("json: $json");
    return Quiz(
      id: json['id'],
      timeCreated: json['timeCreated'],
      updated: json['updated'],
      selfLink: json['selfLink'],
      curQuestion: json['curQuestion'],
      creator: json['creator'],
      pin: json['pin'],
      playUrl: json['playUrl'],
      name: json['name'],
      description: json['description'],
      generator: json['generator'],
      topicFormat: json['topicFormat'],
      answerFormat: json['answerFormat'],
      topic: json['topic'],
      imageUrl: json['imageUrl'],
      numQuestions: json['numQuestions'],
      numAnswers: json['numAnswers'],
      timeLimit: json['timeLimit'],
      difficulty: json['difficulty'],
      temperature: json['temperature'],
      sync: json['sync'],
      anon: json['anon'],
      randomQ: json['randomQ'],
      randomA: json['randomA'],
      survey: json['survey'],
      qAndA: json['QandA'],
      runCount: json['runCount'],
      active: json['active'],
      results: json['results'],
    );
  }
}
