import json
import requests
import random

# https://opentdb.com/

class Quizgen:

    TOPICS = ("General Knowledge", "Books", "Film", "Music",
            "Musicals & Theatres", "Television", "Video Games", "Board Games",
            "Science & Nature", "Computers", "Mathematics", "Mythology",
            "Sports", "Geography", "History", "Politics", "Art", "Celebrities",
            "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime & Manga",
            "Cartoons &  Animations")

    def __init__(self):
        pass

    def __str__(self):
        return "opentrivia quiz generator"

    def get_topics(self, num=None):
        return set(Quizgen.TOPICS)

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["multiple-choice", "true/false"]

    def get_difficulty_word(self, difficulty):
        if difficulty < 1 or difficulty > 5:
            raise Exception("Difficulty cannot be less than 1 or more than 5")

        if difficulty <= 2:
            return "easy"
        elif difficulty <= 4:
            return "medium"
        elif difficulty <= 5:
            return "hard"

    def gen_quiz(self, topic, num_questions, num_answers=None, difficulty=3, temperature=None):
        topic_num = Quizgen.TOPICS.index(topic) + 9

        url = "https://opentdb.com/api.php?"
        url += f"amount={num_questions}"
        url += f"&category={topic_num}"
        url += f"&difficulty={self.get_difficulty_word(difficulty)}"
        url += f"&type=multiple"

        r = requests.get(url)
        quiz = r.json()["results"]
        json_quiz = []

        for question in quiz:
            json_quiz.append({
                "question": question["question"],
                "correct": question["correct_answer"],
                "responses": [question["correct_answer"]] + question["incorrect_answers"]
            })
        # randomize responses
        for i in json_quiz:
            random.shuffle(i["responses"])
        quiz = json.dumps(json_quiz, indent=4)
        return quiz

