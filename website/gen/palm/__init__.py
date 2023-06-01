import json
import pprint
import google.generativeai as palm
import random

class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = []

    def __str__(self):
        return "Palm quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic, num_questions, num_answers):
        palm.configure(api_key="AIzaSyB_3DiddpC5Y53jHD3Sc_E8EWCgKwUeyNk")
        models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
        model = models[0].name

        prompt = f"""
Generate a trivia quiz about {topic} represented in json as an array of objects, where each object contains a question string associated with key "question", an array of possible responses associated with key "responses", and a correct answer associated with key "correct". I'd like {num_questions} questions and {num_answers} possible responses. Format the quiz in json document like this, with no internal single quotes or escaped double quotes and no line breaks:

[
          {{
              "question": "Question 1",
              "correct": "response 2",
              "responses": [
                  "response 1",
                  "response 2",
                  "response 3",
                  "response 4"
              ]
          }},
          {{
              "question": "Question 2",
              "correct": "response 4",
              "responses": [
                  "response 1",
                  "response 2",
                  "response 3",
                  "response 4"
              ]
          }},
...
]"""
        completion = palm.generate_text(
            model=model,
            prompt=prompt,
            temperature=.6,
            max_output_tokens=800,
        )
        quiz = completion.result
        quiz = quiz.replace("```json", "")
        quiz = quiz.replace("```", "")
        # randomize responses
        json_quiz = json.loads(quiz)
        for i in json_quiz:
            random.shuffle(i["responses"])
        quiz = json.dumps(json_quiz, indent=4)
        return quiz
