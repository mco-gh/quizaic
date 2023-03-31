from openapi_client.paths.quizzes_id.get import ApiForget
from openapi_client.paths.quizzes_id.delete import ApiFordelete
from openapi_client.paths.quizzes_id.patch import ApiForpatch


class QuizzesId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
