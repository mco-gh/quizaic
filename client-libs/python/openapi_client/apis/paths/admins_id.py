from openapi_client.paths.admins_id.get import ApiForget
from openapi_client.paths.admins_id.delete import ApiFordelete
from openapi_client.paths.admins_id.patch import ApiForpatch


class AdminsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
