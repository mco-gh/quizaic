import gen
import json
g = gen.Generator("jeopardy")
topics = g.get_topics()
quiz = g.gen_quiz("Quotations", 3, 4)
print(json.dumps(json.loads(quiz), indent=4))
