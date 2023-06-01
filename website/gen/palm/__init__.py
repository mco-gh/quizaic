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
        import pprint
        import google.generativeai as palm
        palm.configure(api_key="AIzaSyB_3DiddpC5Y53jHD3Sc_E8EWCgKwUeyNk")
        models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
        model = models[0].name

        prompt = f'''
Generate a trivia quiz about {topic} represented in json as an array of {num_questions} object, where each object contains a question string associated with key "question", a correct answer string associated with key "correct", and an array of {num_answers} multiple choice answers associated with key "responses".
        '''
        completion = palm.generate_text(
            model=model,
            prompt=prompt,
            temperature=.5,
            max_output_tokens=800,
        )
        quiz = completion.result
        quiz = quiz.replace("```json", "")
        quiz = quiz.replace("```", "")

        return quiz
