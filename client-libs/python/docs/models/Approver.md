# openapi_client.model.approver.Approver

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader,  | frozendict.frozendict, str, decimal.Decimal, BoolClass, NoneClass, tuple, bytes, FileIO |  | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**email** | str,  | str,  | the Approver&#x27;s email address | 
**id** | str,  | str,  | unique, system-assigned identifier | [optional] 
**name** | None, str,  | NoneClass, str,  | the display name of this Approver | [optional] 
**active** | bool,  | BoolClass,  | is this approver currently active? | [optional] if omitted the server will use the default value of False
**timeCreated** | str, datetime,  | str,  | system-assigned creation timestamp | [optional] value must conform to RFC-3339 date-time
**updated** | str, datetime,  | str,  | system-assigned update timestamp | [optional] value must conform to RFC-3339 date-time
**selfLink** | str,  | str,  | full URI of the resource | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

