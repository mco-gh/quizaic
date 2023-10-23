import vertexai
from vertexai.language_models import TextGenerationModel

vertexai.init(project="quizaic", location="us-central1")
parameters = {
    "candidate_count": 1,
    "max_output_tokens": 1024,
    "temperature": 0.2,
    "top_p": 0.8,
    "top_k": 40
}
model = TextGenerationModel.from_pretrained("text-bison")
response = model.predict(
    """make a trivia quiz about Berlin History. Make it multiple choice (4 responses per question). Give me the response in json.""",
    **parameters
)
print(f"Response from Model: {response.text}")
