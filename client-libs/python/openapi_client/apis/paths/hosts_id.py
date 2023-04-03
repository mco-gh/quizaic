from openapi_client.paths.hosts_id.get import ApiForget
from openapi_client.paths.hosts_id.delete import ApiFordelete
from openapi_client.paths.hosts_id.patch import ApiForpatch


class HostsId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
