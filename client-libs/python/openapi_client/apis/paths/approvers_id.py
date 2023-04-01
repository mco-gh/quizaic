from openapi_client.paths.approvers_id.get import ApiForget
from openapi_client.paths.approvers_id.delete import ApiFordelete
from openapi_client.paths.approvers_id.patch import ApiForpatch


class ApproversId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
