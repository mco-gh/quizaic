# openapi_client.model.campaign.Campaign

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader,  | frozendict.frozendict, str, decimal.Decimal, BoolClass, NoneClass, tuple, bytes, FileIO |  | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**name** | str,  | str,  | the campaign&#x27;s display name | 
**cause** | str,  | str,  | the id of the Cause this campaign is for | 
**id** | str,  | str,  | unique, system-assigned identifier | [optional] 
**description** | str,  | str,  | the purpose of the campaign | [optional] if omitted the server will use the default value of "no description"
**[managers](#managers)** | list, tuple,  | tuple,  |  | [optional] 
**goal** | decimal.Decimal, int, float,  | decimal.Decimal,  | the fundraising goal, in USD | [optional] if omitted the server will use the default value of 0
**imageUrl** | None, str,  | NoneClass, str,  | location of image to display for the campaign | [optional] 
**active** | bool,  | BoolClass,  | is this campaign accepting donations at this time? | [optional] if omitted the server will use the default value of False
**timeCreated** | str, datetime,  | str,  | system-assigned creation timestamp | [optional] value must conform to RFC-3339 date-time
**updated** | str, datetime,  | str,  | system-assigned update timestamp | [optional] value must conform to RFC-3339 date-time
**selfLink** | str,  | str,  | full URI of the resource | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

# managers

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
list, tuple,  | tuple,  |  | 

### Tuple Items
Class Name | Input Type | Accessed Type | Description | Notes
------------- | ------------- | ------------- | ------------- | -------------
items | str,  | str,  | a manager&#x27;s email address | 

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

