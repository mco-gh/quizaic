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

import importlib
import sys

sys.path.append("../../")  # Needed for the main method to work in this class


class QuizgenFactory:
    GENERATORS = {
        "jeopardy": None,
        "manual": None,
        "opentrivia": None,
        "palm": None,
        "gemini-pro": None,
        "gemini-ultra": None,
    }

    @staticmethod
    def get_gen(type, config=None):
        if type not in QuizgenFactory.GENERATORS:
            raise Exception(f"Unsupported generator type {type}.")
        if not QuizgenFactory.GENERATORS[type]:
            mod = importlib.import_module(f"pyquizaic.generators.quiz.{type}.quizgen")
            QuizgenFactory.GENERATORS[type] = mod
        return QuizgenFactory.GENERATORS[type].Quizgen(config)

    @staticmethod
    def get_gens():
        gens = {}
        for type in QuizgenFactory.GENERATORS:
            gens[type] = {
                "topic_formats": QuizgenFactory.get_gen(type).get_topic_formats(),
                "answer_formats": QuizgenFactory.get_gen(type).get_answer_formats(),
                "topics": QuizgenFactory.get_gen(type).get_topics(),
            }
        return gens


if __name__ == "__main__":
    gen = QuizgenFactory.get_gen("gpt")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("jeopardy")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("manual")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("opentrivia")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("palm")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("llama2-7b")
    print(f"gen:{gen}")

    gens = QuizgenFactory.get_gens()
    print(f"gens:{gens}")
