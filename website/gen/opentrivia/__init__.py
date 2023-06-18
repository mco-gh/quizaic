import glob
import json
import requests

# https://opentdb.com/

class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = ("General Knowledge", "Books", "Film", "Music",
            "Musicals & Theatres", "Television", "Video Games", "Board Games",
            "Science & Nature", "Computers", "Mathematics", "Mythology",
            "Sports", "Geography", "History", "Politics", "Art", "Celebrities",
            "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime & Manga",
            "Cartoons &  Animations")

    def __str__(self):
        return "OpenTrivia quiz generator for quizrd.io"

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
        quizrd_quiz = []
        
        for question in quiz:
            quizrd_quiz.append({
                "question": question["question"],
                "correct": question["correct_answer"],
                "responses": [question["correct_answer"]] + question["incorrect_answers"]
            })
        quizrd_quiz = json.dumps(quizrd_quiz)
        return quizrd_quiz
