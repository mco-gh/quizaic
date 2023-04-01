# openapi_client.model.cause.Cause

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader,  | frozendict.frozendict, str, decimal.Decimal, BoolClass, NoneClass, tuple, bytes, FileIO |  | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**name** | str,  | str,  | the cause&#x27;s display name | 
**id** | str,  | str,  | unique, system-assigned identifier | [optional] 
**description** | str,  | str,  | the purpose of the cause | [optional] if omitted the server will use the default value of "no description"
**imageUrl** | None, str,  | NoneClass, str,  | location of image to display for the cause | [optional] 
**active** | bool,  | BoolClass,  | is this cause accepting donations at this time? | [optional] if omitted the server will use the default value of False
**timeCreated** | str, datetime,  | str,  | system-assigned creation timestamp | [optional] value must conform to RFC-3339 date-time
**updated** | str, datetime,  | str,  | system-assigned update timestamp | [optional] value must conform to RFC-3339 date-time
**selfLink** | str,  | str,  | full URI of the resource | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

