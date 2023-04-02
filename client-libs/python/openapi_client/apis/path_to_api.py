import typing_extensions

from openapi_client.paths import PathValues
from openapi_client.apis.paths.players import Players
from openapi_client.apis.paths.players_id import PlayersId
from openapi_client.apis.paths.quizzers import Quizzers
from openapi_client.apis.paths.quizzers_id import QuizzersId
from openapi_client.apis.paths.admins import Admins
from openapi_client.apis.paths.admins_id import AdminsId
from openapi_client.apis.paths.quizzes import Quizzes
from openapi_client.apis.paths.quizzes_id import QuizzesId
from openapi_client.apis.paths.generators import Generators
from openapi_client.apis.paths.generators_id import GeneratorsId
from openapi_client.apis.paths.approvers import Approvers
from openapi_client.apis.paths.approvers_id import ApproversId
from openapi_client.apis.paths.campaigns import Campaigns
from openapi_client.apis.paths.campaigns_id import CampaignsId
from openapi_client.apis.paths.campaigns_id_donations import CampaignsIdDonations
from openapi_client.apis.paths.causes import Causes
from openapi_client.apis.paths.causes_id import CausesId
from openapi_client.apis.paths.donations import Donations
from openapi_client.apis.paths.donations_id import DonationsId
from openapi_client.apis.paths.donors import Donors
from openapi_client.apis.paths.donors_id import DonorsId
from openapi_client.apis.paths.donors_id_donations import DonorsIdDonations

PathToApi = typing_extensions.TypedDict(
    'PathToApi',
    {
        PathValues.PLAYERS: Players,
        PathValues.PLAYERS_ID: PlayersId,
        PathValues.QUIZZERS: Quizzers,
        PathValues.QUIZZERS_ID: QuizzersId,
        PathValues.ADMINS: Admins,
        PathValues.ADMINS_ID: AdminsId,
        PathValues.QUIZZES: Quizzes,
        PathValues.QUIZZES_ID: QuizzesId,
        PathValues.GENERATORS: Generators,
        PathValues.GENERATORS_ID: GeneratorsId,
        PathValues.APPROVERS: Approvers,
        PathValues.APPROVERS_ID: ApproversId,
        PathValues.CAMPAIGNS: Campaigns,
        PathValues.CAMPAIGNS_ID: CampaignsId,
        PathValues.CAMPAIGNS_ID_DONATIONS: CampaignsIdDonations,
        PathValues.CAUSES: Causes,
        PathValues.CAUSES_ID: CausesId,
        PathValues.DONATIONS: Donations,
        PathValues.DONATIONS_ID: DonationsId,
        PathValues.DONORS: Donors,
        PathValues.DONORS_ID: DonorsId,
        PathValues.DONORS_ID_DONATIONS: DonorsIdDonations,
    }
)

path_to_api = PathToApi(
    {
        PathValues.PLAYERS: Players,
        PathValues.PLAYERS_ID: PlayersId,
        PathValues.QUIZZERS: Quizzers,
        PathValues.QUIZZERS_ID: QuizzersId,
        PathValues.ADMINS: Admins,
        PathValues.ADMINS_ID: AdminsId,
        PathValues.QUIZZES: Quizzes,
        PathValues.QUIZZES_ID: QuizzesId,
        PathValues.GENERATORS: Generators,
        PathValues.GENERATORS_ID: GeneratorsId,
        PathValues.APPROVERS: Approvers,
        PathValues.APPROVERS_ID: ApproversId,
        PathValues.CAMPAIGNS: Campaigns,
        PathValues.CAMPAIGNS_ID: CampaignsId,
        PathValues.CAMPAIGNS_ID_DONATIONS: CampaignsIdDonations,
        PathValues.CAUSES: Causes,
        PathValues.CAUSES_ID: CausesId,
        PathValues.DONATIONS: Donations,
        PathValues.DONATIONS_ID: DonationsId,
        PathValues.DONORS: Donors,
        PathValues.DONORS_ID: DonorsId,
        PathValues.DONORS_ID_DONATIONS: DonorsIdDonations,
    }
)
