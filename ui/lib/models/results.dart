class Results {
  // provided by quiz host (in order of appearance on start quiz form)
  bool? state;
  String? quizId;
  bool? synchronous;
  String? timeLimit;
  bool? survey;
  bool? anonymous;
  bool? randomizeQuestions;
  bool? randomizeAnswers;

  // managed by firestore (in alphabetical order)
  String? id;
  final String? selfLink;
  final String? timeCreated;
  final String? updated;

  // managed by backend api (in alphabetical order)
  final String? curQuestion;
  final String? pin;

  Results({
    // provided by quiz host (in order of appearance on create quiz form)
    required this.state,
    required this.quizId,
    required this.synchronous,
    required this.timeLimit,
    required this.survey,
    required this.anonymous,
    required this.randomizeQuestions,
    required this.randomizeAnswers,

    // managed by firestore (in alphabetical order)
    this.id,
    this.selfLink,
    this.timeCreated,
    this.updated,

    // managed by backend api (in alphabetical order)
    this.curQuestion = '0',
    this.pin = '',
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      // provided by quiz host (in order of appearance on start quiz form)
      state: json['state'],
      quizId: json['quizId'],
      synchronous: json['synchronous'],
      timeLimit: json['timeLimit'],
      survey: json['survey'],
      anonymous: json['anonymous'],
      randomizeQuestions: json['randomizeQuestions'],
      randomizeAnswers: json['randomizeAnswers'],

      // managed by firestore (in alphabetical order)
      id: json['id'],
      selfLink: json['selfLink'],
      timeCreated: json['timeCreated'],
      updated: json['updated'],

      // managed by backend api (in alphabetical order)
      curQuestion: json['curQuestion'],
      pin: json['pin'],
    );
  }

  Map toJson() => {
        'state': state,
        'quizId': quizId,
        'synchronous': synchronous,
        'timeLimit': timeLimit,
        'survey': survey,
        'anonymous': anonymous,
        'randomizeQuestions': randomizeQuestions,
        'randomizeAnswers': randomizeAnswers,

        // managed by firestore (in alphabetical order)
        'id': id,
        'selfLink': selfLink,
        'timeCreated': timeCreated,
        'updated': updated,

        //. managed by backend api (in alphabetical order)
        'curQuestion': curQuestion,
        'pin': pin,
      };
}
