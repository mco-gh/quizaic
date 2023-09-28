class Session {
  // provided by quiz host (in order of appearance on start quiz form)
  String state; // starting, quizzing, revealing, suspended
  String quizId;
  String sessionId;
  bool synchronous;
  String timeLimit;
  bool survey;
  bool anonymous;
  bool randomizeQuestions;
  bool randomizeAnswers;

  // managed by firestore (in alphabetical order)
  String id;
  final String selfLink;
  final String timeCreated;
  final String updated;

  // managed by backend api (in alphabetical order)
  final String curQuestion;
  final String pin;

  Session({
    // provided by quiz host (in order of appearance on create quiz form)
    //required this.state,
    this.state = '',
    this.quizId = '',
    this.sessionId = '',
    this.synchronous = true,
    this.timeLimit = '30',
    this.survey = false,
    this.anonymous = true,
    this.randomizeQuestions = false,
    this.randomizeAnswers = false,

    // managed by firestore (in alphabetical order)
    this.id = '',
    this.selfLink = '',
    this.timeCreated = '',
    this.updated = '',

    // managed by backend api (in alphabetical order)
    this.curQuestion = '-1',
    this.pin = '',
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      // provided by quiz host (in order of appearance on start quiz form)
      state: json['state'],
      quizId: json['quizId'],
      sessionId: json['sessionId'],
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
        'sessionId': sessionId,
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
