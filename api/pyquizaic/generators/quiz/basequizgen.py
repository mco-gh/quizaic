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

from abc import ABC, abstractmethod


class BaseQuizgen(ABC):
    TEMPERATURE = 0.2
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
    def gen_quiz(
        self,
        topic=None,
        num_questions=None,
        num_answers=None,
        difficulty=3,
        temperature=0.5,
    ):
        pass
