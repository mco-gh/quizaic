from openapi_client.paths.quizzers_id.get import ApiForget
from openapi_client.paths.quizzers_id.delete import ApiFordelete
from openapi_client.paths.quizzers_id.patch import ApiForpatch


class QuizzersId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
