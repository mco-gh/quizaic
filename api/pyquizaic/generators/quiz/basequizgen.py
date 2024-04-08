# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from abc import ABC, abstractmethod


class BaseQuizgen(ABC):
    PROJECT = os.environ.get("PROJECT_ID", "quizaic")
    REGION = os.environ.get("REGION", "us-central1")
    TOPIC = "random"
    NUM_QUESTIONS = 5
    NUM_ANSWERS = 4
    DIFFICULTY = "intermediate"
    LANGUAGE = "English"
    TEMPERATURE = 1.0

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
    def gen_quiz(
        self,
        topic=TOPIC,
        num_questions=NUM_QUESTIONS,
        num_answers=NUM_ANSWERS,
        difficulty=DIFFICULTY,
        language=LANGUAGE,
        temperature=TEMPERATURE,
    ):
        pass
