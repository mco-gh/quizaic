from openapi_client.paths.players_id.get import ApiForget
from openapi_client.paths.players_id.delete import ApiFordelete
from openapi_client.paths.players_id.patch import ApiForpatch


class PlayersId(
    ApiForget,
    ApiFordelete,
    ApiForpatch,
):
    pass
