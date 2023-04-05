# Quizrd Requirements

Scalable and reliable runtime
Real-time storage engine
Automation through generative AI
State of the art devops
Flexible, fast analytics
Data visualization

## General
- don’t make me think! (about admin)
- open source software will enable people to host their own quiz server
- a sample server will be provided on Google Cloud for demonstration purposes
- initially mobile devices are supported via web browser only, i.e. no mobile app (yet)

## Quiz Format
- questions may be multiple choice or free form text
- quizzes may have any number of questions
- quizzes may have an associated image
- questions and answers may be presented in random or fixed order
- quizzes can be synchronous, operated by a host where challenges are seen in lockstep by all players 
- quizzes can also be asynchronous, where players can start and advance through the quiz at their own pace at any time, independent of other players
- quizzes may be ungraded; we call this a *poll* or a *survey* because it exists to gather information rather than to conduct a competition

## Quiz Generators
- quiz questions are generated via a common programming interface
- generator modules will adapt the common interface to a given generator
- initial support for three generators: Jeopardy, Bard, and ChatGPT
- generator modules will be dynamically loadable so that developers can extend support for new generators

## Quiz Operation
- the web client is called the Quizrd Agent (QA)
- the back-end service is called the Quizrd Server (QS)
- the QA and QS communicate using the Quizrd API (QAPI), which is a RESTful HTTP programming interface
- the QAPI provides bi-directional real-time notification using Web Sockets

## Admin User Interface
- set global system parameters
- add support for additional generators

## Host User Interface
- host must create a login
- host enters quiz parameters:
  - topic
  - number of questions
  - level of difficulty
  - how much time to allow for responses
- quiz creation returns two rendezvous points:
  - a unique short URL
  - a unique pin number
- once a quiz is launched, host controls the flow
- quizzes may be synchronous or asynchronous

## Player (Quiz Participant) User Interface
- no login required
- access via quiz specific URL or common URL with pin prompt
- sequence of questions and responses will appear on device
- countdown time appears while waiting for response
- results summary available on device
