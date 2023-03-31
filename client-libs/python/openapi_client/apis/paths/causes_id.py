from openapi_client.paths.causes_id.get import ApiForget
from openapi_client.paths.causes_id.delete import ApiFordelete
from openapi_client.paths.causes_id.patch import ApiForpatch


class CausesId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
