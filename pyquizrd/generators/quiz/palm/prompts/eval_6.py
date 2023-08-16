import copy
import json
import os


# eval6 prompt uses a more freeform input and no prompt template:
# question: What is the name of the largest planet in the solar system? Jupiter, Saturn, Uranus, Neptune
# correct: <find correct answer>
#
# question: What is the name of the smallest planet in the solar system? Venus, Earth, Mercury, Mars?
# correct: <find correct answer>
#
# Return correct answers in JSON: [
#    <answer>,
#    ...
# ]
class QuizevalHelper:

    def __init__(self):
        pass

    def __str__(self):
        return "eval_6"

    @staticmethod
    def prepare_prompt(quiz, topic):
        prompt = ""
        for item in quiz:
            prompt += (f"\nquestion: {item['question']} {', '.join(item['responses'])}\n"
                       + "correct: <find correct answer>\n")
        prompt += """\nReturn correct answers in JSON: 
        [
            <answer>,
            <answer>,
            ...
        ]"""
        print(f"prompt: {prompt}")

        return prompt

    @staticmethod
    def parse_output_and_eval_quiz(validity, prediction, quiz, topic):
        # [
        #     "<answer1>"
        #     "<answer2>
        # ],
        evaluation = json.loads(prediction)

        for index, item in enumerate(evaluation):
            question = quiz[index]['question']

            expected_correct = item
            actual_correct = quiz[index]["correct"]
            if expected_correct != actual_correct:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #6: The correct answer is not correct - question: '{question}"
                                           f"', expected: {expected_correct}, actual: {actual_correct}")

            if question not in validity["invalid_questions"]:
                validity["valid_questions"].add(question)

        return validity
