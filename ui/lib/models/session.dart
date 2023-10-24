// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Session {
  // provided by quiz host (in order of appearance on start quiz form)
  String quizId;
  bool synchronous;
  int timeLimit;
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
    this.anonymous = true,
    this.randomizeQuestions = false,
    this.randomizeAnswers = false,

    // managed by firestore (in alphabetical order)
    this.id = '',
    this.selfLink = '',
    this.timeCreated = '',
    this.updated = '',

    // managed (indirectly) by backend api
    this.curQuestion = -2,
    this.pin = '',
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      // provided by quiz host (in order of appearance on start quiz form)
      quizId: json['quizId'],
      synchronous: json['synchronous'],
      timeLimit: json['timeLimit'],
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
