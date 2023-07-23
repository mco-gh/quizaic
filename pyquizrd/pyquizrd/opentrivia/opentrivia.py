import glob
import json
import requests
import random

# https://opentdb.com/

class Quizgen:
    def __init__(self):
        self.topics = ("General Knowledge", "Books", "Film", "Music",
            "Musicals & Theatres", "Television", "Video Games", "Board Games",
            "Science & Nature", "Computers", "Mathematics", "Mythology",
            "Sports", "Geography", "History", "Politics", "Art", "Celebrities",
            "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime & Manga",
            "Cartoons &  Animations")

    def __str__(self):
        return "opentrivia quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["multiple-choice", "true/false"]

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=None):
        if difficulty <= 2:
            difficulty_word = "easy"
        elif difficulty <= 4:
            difficulty_word = "medium"
        elif difficulty == 5:
            difficulty_word = "hard"
        topic_num = self.topics.index(topic) + 9
       
        url = "https://opentdb.com/api.php?"
        url += f"amount={num_questions}"
        url += f"&category={topic_num}"
        url += f"&difficulty={difficulty_word}"
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

