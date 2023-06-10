import json
import pprint
import google.generativeai as palm
import random
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Generator:
    def __init__(self, root, project="quizrd-prod-382117", location="us-central1"):
        self.root = root
        self.topics = []
        vertexai.init(project=project, location=location)
        self.prompt = """
Generate a trivia quiz about {topic} represented in json as an array of objects, where each object contains a question string associated with key "question", an array of possible responses associated with key "responses", and a correct answer associated with key "correct". The difficulty level should be {difficulty} on a 1-5 scale, where 1 is easiest and 5 is most difficult. Generate {num_questions} questions and {num_answers} possible responses. Format the quiz in json document with no internal single quotes or escaped double quotes and no line breaks. Vary the question structure and the possible responses so that there's very little repetition throughout the quiz. Avoid obvious questions, of the "Who was buried in Grant's Tomb?" variety.

input: geography, 2 questions
output: [
    {{
        "question": "What is the name of the largest continent in the world?",
        "correct": "Asia",
        "responses": [
            "Antarctica",
            "Africa",
            "North America",
            "Asia"
        ]
    }},
    {{
        "question": "What is the name of the largest country in the world?",
        "correct": "Russia",
        "responses": [
            "Russia",
            "India",
            "China",
            "United States"
        ]
    }}
]

input: history, 4 questions
output: [
    {{
        "question": "Who was the first emperor of the Holy Roman Empire?",
        "correct": "Charlemagne",
        "responses": [
            "Otto I",
            "Frederick Barbarossa",
            "Charles V",
            "Charlemagne"
        ]
    }},
    {{
        "question": "What was the name of the English king who conquered Normandy?",
        "correct": "William the Conqueror",
        "responses": [
            "Edward the Confessor",
            "Richard I",
            "Henry II",
            "William the Conqueror"
        ]
    }},
    {{
        "question": "What was the name of the French revolutionary who was executed during the Reign of Terror?",
        "correct": "Marie Antoinette",
        "responses": [
            "Georges Danton",
            "Louis XVI",
            "Marie Antoinette",
            "Maximilien Robespierre"
        ]
    }},
    {{
        "question": "What was the name of the British prime minister who led the country during World War II?",
        "correct": "Winston Churchill",
        "responses": [
            "Joseph Stalin",
            "Adolf Hitler",
            "Winston Churchill",
            "Neville Chamberlain"
        ]
    }}
]

input: {topic}, {num_questions} questions
output:
"""

    def __str__(self):
        return "Palm quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def predict_llm(self, model, temp, tokens, top_p, top_k, content, tuned_model=""):
      m = TextGenerationModel.from_pretrained(model)
      if tuned_model:
          m = model.get_tuned_model(tuned_model)
      response = m.predict(content, temperature=temp, max_output_tokens=tokens,
          top_k=top_k, top_p=top_p)
      return response.text

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        prompt = self.prompt.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=difficulty)
        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        # randomize responses
        json_quiz = json.loads(quiz)
        for i in json_quiz:
            random.shuffle(i["responses"])
        quiz = json.dumps(json_quiz, indent=4)
        return quiz
