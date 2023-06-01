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

    def gen_quiz(self, topic, numQuestions, numAnswers):
        import pprint
        import google.generativeai as palm
        palm.configure(api_key="AIzaSyB_3DiddpC5Y53jHD3Sc_E8EWCgKwUeyNk")
        models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
        model = models[0].name

        prompt = """
Generate a trivia quiz about popular music. I'd like 10 questions, each with four multiple choice answers. One answer to each question may be funny or silly. Please format the quiz in json document like this, with no internal single quotes or escaped double quotes and no line breaks:

[
          {
              "question": "Which band sold the most records of all time?",
              "correct": "The Beatles",
              "responses": [
                  "The Rolling Stones",
                  "The Beatles",
                  "Oasis",
                  "Spinal Tap"
              ]
          },
          ...
]
"""
        completion = palm.generate_text(
            model=model,
            prompt=prompt,
            temperature=0,
            max_output_tokens=800,
        )

        return completion.result
