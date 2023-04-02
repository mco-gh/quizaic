from openapi_client.paths.generators_id.get import ApiForget
from openapi_client.paths.generators_id.delete import ApiFordelete
from openapi_client.paths.generators_id.patch import ApiForpatch


class GeneratorsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
