# Quizrd Requirements

## General
1. three tier archtecture (web client, API server, data storage engine) for robust security and separation of concerns
2. web client and  back end server communicate using a RESTful HTTP programming interface
3. bi-directional real-time notification via Web Sockets
4. scalable and reliable runtime
5. real-time storage engine
6. automation through generative AI
7. state of the art devops
8. flexible, fast analytics
9. data visualization
10. don’t make me think! (about admin)
11. open sourced to enable hosting their own quiz server
12. sample server provided on Google Cloud for demonstration purposes
13. initially, mobile devices supported via web browser only, i.e. no mobile app (yet)

## Quiz Format
1. Questions may be multiple choice or free form text, but only one such format per quiz.
2. Quizzes may have any number of questions.
3. Multiple choice questions may have 1-4 answers per question, which may vary from question to question within a quiz.
4. Quizzes may optionally have an associated image.
5. Questions and answers may be presented in random or fixed order, per host specification.
6. Quizzes may be synchronous or asynchronous.
    1. Synchronous quizzes are operated by a host where challenges are seen in lockstep by all participating players. 
    2. Asynchronous quizzes enable players to start and advance through a quiz at any time, independently of other players.
7. Quizzes may be graded or ungraded
   1. A graded *quiz* is competitive and maintains an associated leaderboard.
   2. An ungraded *quiz* is essentially a poll or a survey because it exists to gather information rather than conduct a competition.

## Quiz Generators
1. Quiz questions are generated via a common programming interface, the Quiz Generator API.
2. The quiz generator API is internal to the service back end. It's not used directly by the web front end.
3. Generator modules adapt the common interface to a specifig generator.
4. The quiz generator type is a configuration setting when a host creates a new quiz.
5. Quizrd will initially support four generators: Jeopardy, OpenTrivia, Bard, and ChatGPT.
6. Generator modules will be dynamically loadable so that developers can add support for new generators.
7. **Operations**:
   1. query generator capabilities:
      1. name - the generator's type name
      2. freeformAnswers - whether this generator supports free-form answers
      3. topic_list - array of topics supported by this generator (an empty string means only free form topics are supported
   2. create a quiz

## Admin User Experience
1. Admins can access all functionality enumerated in the host UI section below, however, admins are "super-users" in that they can read/edit/delete other hosts' and other admins' quizzes.
2. **Operations**:
   1. set, edit, and unset global system parameters
   2. add, delete, and configure quiz generators

## Host User Experience
1. host must create a login
2. In response to quiz creation, the host receives:
   1. playURL, a short URL for playing the newly created quiz
   2. pin, a short numeric code for playing the newly created quiz
3. **Operations**:
   1. create a quiz with the following parameters:
      1. quiz name - must be unique for a given host
      2. freeform - whether answers should be free form or multiple choice
      3. topic - string representing the topic for the new quiz
      4. anonymous - whether players can be participate anonymously
      5. randomQ - whether to randomize question order
      6. randomA - whether to randomize answer order
      7. imageUrl - URL of an image to display for the new quiz
      8. difficulty - integer level of difficulty (1-10)
      9. timeLimit - number of seconds to respond to each question
      10. numQuestions - number of questions included in the new quiz
      11. numAnswers - number of answers for each question (0 == free form)
      12. sync - whether this quiz should be synchronous or asynchronous
   2. view quizzes created by or shared with the currently logged in host
   3. edit an existing quiz
   4. run a quiz
   5. stop running a quiz
   6. delete a quiz

## Player User Experience
1. Player accounts are optional, players may create one but they are not required in order to participate in a quiz.
2. Access is granted to a quiz via a specific URL or a common URL with a pin prompt.
3. Quiz specific URLs and quizzes must be as short as possible - no more than six characters for the pin and the URL suffix.
4. The player experience consists of a sequence of questions and responses appearing on the device with a clearly visible count down timer.
5. Multiple choice responses must clearly display the answer text (vs. letter coded responses mapping to text displayed somewhere else).
6. Players running results summary must be readily available on the device.
7. **Opertions**:
   1. navigate to a quiz, by URL or pin
   2. play a quiz
   3. view results
  
