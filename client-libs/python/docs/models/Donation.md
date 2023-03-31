# openapi_client.model.donation.Donation

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader,  | frozendict.frozendict, str, decimal.Decimal, BoolClass, NoneClass, tuple, bytes, FileIO |  | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**amount** | decimal.Decimal, int, float,  | decimal.Decimal,  | the amount donated, in USD | 
**donor** | str,  | str,  | the id of the donor this donation is from | 
**campaign** | str,  | str,  | the id of the campaign this donation is for | 
**id** | str,  | str,  | unique, system-assigned identifier | [optional] 
**timeCreated** | str, datetime,  | str,  | system-assigned creation timestamp | [optional] value must conform to RFC-3339 date-time
**updated** | str, datetime,  | str,  | system-assigned update timestamp | [optional] value must conform to RFC-3339 date-time
**selfLink** | str,  | str,  | full URI of the resource | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

