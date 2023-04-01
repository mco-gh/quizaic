from openapi_client.paths.donors_id.get import ApiForget
from openapi_client.paths.donors_id.delete import ApiFordelete
from openapi_client.paths.donors_id.patch import ApiForpatch


class DonorsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
