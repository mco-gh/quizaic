from flask import Flask
from flask import request
import vertexai
from vertexai.language_models import TextGenerationModel
import os

# Default model settings
MODEL = "text-bison"
MAX_TOKENS = 1024
TOP_P = 0.8
TOP_K = 40
TEMP = 0.5

# Default quiz settings
TOPIC = "History"
NUM_Q = 5
DIFF = "intermediate"

PROMPT = """
Generate a quiz according to the following specifications:

- topic: {topic}
- num_q: {num_q}
- diff:  {diff}

Output should be (only) an unquoted json array of objects with keys "question", "responses", and "correct".

"""


app = Flask(__name__)  # Create a Flask object.
PORT = os.environ.get("PORT")  # Get PORT setting from environment.
if not PORT:
    PORT = 8080


# This function takes a dictionary, a name, and a default value.
# If the name exists as a key in the dictionary, the corresponding
# value is returned. Otherwise, the default value is returned.
def check(args, name, default):
    if name in args:
        return args[name]
    return default


# The app.route decorator routes any GET requests sent to the /generate
# path to this function, which responds with "Generating:” followed by
# the body of the request.
@app.route("/", methods=["GET"])
# This function generates a quiz using Vertex AI.
def generate():
    args = request.args.to_dict()
    topic = check(args, "topic", TOPIC)
    num_q = check(args, "num_q", NUM_Q)
    diff = check(args, "diff", DIFF)
    prompt = PROMPT.format(topic=topic, num_q=num_q, diff=diff)
    html = f"<h1>Prompt:</h1><br><pre>{prompt}</pre>"
    return html


# This code ensures that your Flask app is started and listens for
# incoming connections on the local interface and port 8080.
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
