import html
import random
import requests

# https://opentdb.com/

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

class Quizgen(BaseQuizgen):
    TOPICS = (
        "General Knowledge",
        "Books",
        "Film",
        "Music",
        "Musicals & Theatres",
        "Television",
        "Video Games",
        "Board Games",
        "Science & Nature",
        "Computers",
        "Mathematics",
        "Mythology",
        "Sports",
        "Geography",
        "History",
        "Politics",
        "Art",
        "Celebrities",
        "Animals",
        "Vehicles",
        "Comics",
        "Gadgets",
        "Japanese Anime & Manga",
        "Cartoons &  Animations",
    )

    def __init__(self, config=None):
        pass

    def __str__(self):
        return "opentrivia quiz generator"

    def get_topics(self, num=None):
        return set(Quizgen.TOPICS)

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["multiple-choice", "true/false"]

    def gen_quiz(
        self, topic, num_questions, num_answers=None,
        difficulty=BaseQuizgen.DIFFICULTY, temperature=None
    ):
        topic_num = Quizgen.TOPICS.index(topic) + 9

        # Example: https://opentdb.com/api.php?amount=1&category=9&difficulty=easy&type=multiple
        url = "https://opentdb.com/api.php?"
        url += f"amount={num_questions}"
        url += f"&category={topic_num}"
        # TODO - Hack: For some categories (eg. Art, Gadget), there are not
        # enough questions. Ignore difficulty in that case.
        if not (topic_num == 25 or topic_num == 30):
            url += f"&difficulty={difficulty}"
        url += f"&type=multiple"

        r = requests.get(url)
        quiz = r.json()["results"]
        json_quiz = []

        for question in quiz:
            json_quiz.append(
                {
                    "question": html.unescape(question["question"]).strip(),
                    "correct": html.unescape(question["correct_answer"]).strip(),
                    "responses": [html.unescape(question["correct_answer"]).strip()]
                    + [html.unescape(s).strip() for s in question["incorrect_answers"]],
                }
            )

        # randomize responses
        for i in json_quiz:
            random.shuffle(i["responses"])
        # quiz = json.dumps(json_quiz, indent=4)
        return json_quiz


if __name__ == "__main__":
    gen = Quizgen()
    print(f"gen:{gen}")
