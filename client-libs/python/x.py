import emblem_client
import os

api_url = os.environ.get("EMBLEM_API_URL")
id_token = os.environ.get("ID_TOKEN")

api = emblem_client.EmblemClient(api_url, access_token=id_token)
x = api.campaigns_get()
print(x)
x = api.quizzes_get()
print(x)
