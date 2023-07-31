import html
import random
import requests

# https://opentdb.com/

class Quizgen:

    TOPICS = ("General Knowledge", "Books", "Film", "Music",
            "Musicals & Theatres", "Television", "Video Games", "Board Games",
            "Science & Nature", "Computers", "Mathematics", "Mythology",
            "Sports", "Geography", "History", "Politics", "Art", "Celebrities",
            "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime & Manga",
            "Cartoons &  Animations")

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

        # Example: https://opentdb.com/api.php?amount=1&category=9&difficulty=easy&type=multiple
        url = "https://opentdb.com/api.php?"
        url += f"amount={num_questions}"
        url += f"&category={topic_num}"
        # TODO - Hack: For some categories (eg. Art, Gadget), there are not
        # enough questions. Ignore difficulty in that case.
        if not (topic_num == 25 or topic_num == 30):
            url += f"&difficulty={self.get_difficulty_word(difficulty)}"
        url += f"&type=multiple"

        r = requests.get(url)
        quiz = r.json()["results"]
        json_quiz = []

        for question in quiz:
            # json_quiz.append({
            #     "question": html.unescape(question["question"]),
            #     "correct": html.unescape(question["correct_answer"]),
            #     "responses": [html.unescape(question["correct_answer"])] + [html.unescape(s) for s in question["incorrect_answers"]]
            # })

            json_quiz.append({
                "question": question["question"].strip(),
                "correct": question["correct_answer"].strip(),
                "responses": [question["correct_answer"].strip()] + [s.strip() for s in question["incorrect_answers"]]
            })
        # randomize responses
        for i in json_quiz:
            random.shuffle(i["responses"])
        #quiz = json.dumps(json_quiz, indent=4)
        return json_quiz

    # Given a quiz, check if it's a valid quiz
    def eval_quiz(self, quiz, topic, num_questions, num_answers, shortcircuit_validity=True):
        # 1. It has right number of questions
        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            return False, f"Number of questions - actual: {actual_num_questions}, expected: {num_questions}"

        for item in quiz:
            # 2. It has right number of answers per question
            responses = item["responses"]
            actual_num_answers = len(responses)
            if actual_num_answers != num_answers:
                return False, f"Number of responses in question '{item['question']}' - actual: {actual_num_answers}, expected: {num_answers}"
            # 3. The correct answer is in the answers list
            correct = item["correct"]
            if not correct in responses:
                return False, f"The correct answer '{correct}' for question '{item['question']}' is not in responses list: {responses}"

        return True, f"Valid quiz: {eval}"
