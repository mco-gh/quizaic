# do not import all endpoints into this module because that uses a lot of memory and stack frames
# if you need the ability to import all endpoints from this module, import them with
# from openapi_client.apis.path_to_api import path_to_api

import enum


class PathValues(str, enum.Enum):
    QUIZZES = "/quizzes"
    QUIZZES_ID = "/quizzes/{id}"
    APPROVERS = "/approvers"
    APPROVERS_ID = "/approvers/{id}"
    CAMPAIGNS = "/campaigns"
    CAMPAIGNS_ID = "/campaigns/{id}"
    CAMPAIGNS_ID_DONATIONS = "/campaigns/{id}/donations"
    CAUSES = "/causes"
    CAUSES_ID = "/causes/{id}"
    DONATIONS = "/donations"
    DONATIONS_ID = "/donations/{id}"
    DONORS = "/donors"
    DONORS_ID = "/donors/{id}"
    DONORS_ID_DONATIONS = "/donors/{id}/donations"
