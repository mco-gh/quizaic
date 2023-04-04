# Quizrd Requirements

## General
- open source software will enable people to host their own quiz server
- a sample server will be provided on Google Cloud for demonstration purposes
- mobile devices supported via web browser only (i.e. at least initially, no mobile app)
- quizzes are real time, created and operated on demand by a quiz administrator

## Quiz Format
- all questions will have four possible multiple choice answers
- quizzes may have any number of questions
- order of quiz questions and answers may be randomized

## Quiz Generators
- quiz questions are generated via a standardized Quizrd Generator API (QGAPI)
- generator modules will adapt the QGAPI to a given generator
- initial support for three generators: Jeopardy, Bard, and ChatGPT
- generator modules will be dynamically loadable so that developers can extend support for new generators

## Quiz Operation
- the web client is called the Quizrd Agent (QA)
- the back-end service is called the Quizrd Server (QS)
- the QA and QS communicate using the Quizrd API (QAPI), which is a RESTful HTTP programming interface
- the QAPI provides bi-directional real-time notification using Web Sockets

## System Administrator (SA) User Interface
- set global system parameters
- add support for additional generators

## Quiz Administrator (Admin) User Interface
- admin must create a login
- admin enters quiz parameters:
  - topic
  - number of questions
  - level of difficulty
  - how much time to allow for responses
- quiz creation returns two rendezvous points:
  - a unique short URL
  - a unique pin number
- once a quiz is launched, admin controls the flow
- quizzes may be synchronous or asynchronous

## Quiz Taker (Participant) User Interface
- no login required
- access via quiz specific URL or common URL with pin prompt
- sequence of questions and responses will appear on device
- countdown time appears while waiting for response
- results summary available on device

## Possible Extensions
- give admins ability to save a quiz for repeated use
