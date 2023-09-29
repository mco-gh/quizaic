class Session {
  // provided by quiz host (in order of appearance on start quiz form)
  String quizId;
  bool synchronous;
  int timeLimit;
  bool survey;
  bool anonymous;
  bool randomizeQuestions;
  bool randomizeAnswers;

  // managed by firestore (in alphabetical order)
  String id;
  String selfLink;
  String timeCreated;
  String updated;

  // managed by backend api (in alphabetical order)
  int curQuestion;
  String pin;

  Session({
    // provided by quiz host (in order of appearance on create quiz form)
    this.quizId = '',
    this.synchronous = true,
    this.timeLimit = 30,
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
    this.curQuestion = -1,
    this.pin = '',
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      // provided by quiz host (in order of appearance on start quiz form)
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
