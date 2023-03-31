from openapi_client.paths.donations_id.get import ApiForget
from openapi_client.paths.donations_id.delete import ApiFordelete
from openapi_client.paths.donations_id.patch import ApiForpatch


class DonationsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
