from openapi_client.paths.campaigns_id.get import ApiForget
from openapi_client.paths.campaigns_id.delete import ApiFordelete
from openapi_client.paths.campaigns_id.patch import ApiForpatch


class CampaignsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
