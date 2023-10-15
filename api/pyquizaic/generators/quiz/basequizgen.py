from abc import ABC, abstractmethod


class BaseQuizgen(ABC):

    TEMPERATURE = 0.5
    DIFFICULTY = "medium"
    LANGUAGE = "English"

    def __init__(self, config=None):
        pass

    @abstractmethod
    def __str__(self):
        pass

    @abstractmethod
    def get_topics(self, num=100):
        pass

    @abstractmethod
    def get_topic_formats(self):
        pass

    @abstractmethod
    def get_answer_formats(self):
        return None

    # Generate quiz with the given parameters
    @abstractmethod
    def gen_quiz(self, topic=None, num_questions=None, num_answers=None, difficulty=3, temperature=.5):
        pass
