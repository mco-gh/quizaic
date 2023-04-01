# openapi_client.model.quiz.Quiz

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader,  | frozendict.frozendict, str, decimal.Decimal, BoolClass, NoneClass, tuple, bytes, FileIO |  | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**difficulty** | decimal.Decimal, int, float,  | decimal.Decimal,  | integer level of difficulty (1-10) | 
**numQuestions** | str,  | str,  | number of questions included in this quiz | 
**timeLimit** | decimal.Decimal, int, float,  | decimal.Decimal,  | number of seconds to respond to each question in this quiz | 
**[leaderboard](#leaderboard)** | dict, frozendict.frozendict,  | frozendict.frozendict,  | map of player id to score for this quiz | 
**pin** | str,  | str,  | pin code for playing this quiz | 
**author** | str,  | str,  | the id of the quizmaster of this quiz | 
**name** | None, str,  | NoneClass, str,  | the display name of this quiz | 
**[questions](#questions)** | list, tuple,  | tuple,  | array of question/answer objects included in this quiz | 
**active** | bool,  | BoolClass,  | is this quiz currently being played? | if omitted the server will use the default value of False
**topic** | str,  | str,  | the topic of this quiz | 
**sync** | bool,  | BoolClass,  | is this quiz synchronous (false &#x3D;&#x3D; asynchronous) | if omitted the server will use the default value of True
**playUrl** | str,  | str,  | URL for playing this quiz | 
**id** | str,  | str,  | unique, system-assigned identifier | [optional] 
**imageUrl** | str,  | str,  | string containing URL of an image to display for this quiz | [optional] 
**timeCreated** | str, datetime,  | str,  | system-assigned creation timestamp | [optional] value must conform to RFC-3339 date-time
**updated** | str, datetime,  | str,  | system-assigned update timestamp | [optional] value must conform to RFC-3339 date-time
**selfLink** | str,  | str,  | full URI of the resource | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

# questions

array of question/answer objects included in this quiz

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
list, tuple,  | tuple,  | array of question/answer objects included in this quiz | 

### Tuple Items
Class Name | Input Type | Accessed Type | Description | Notes
------------- | ------------- | ------------- | ------------- | -------------
[items](#items) | dict, frozendict.frozendict,  | frozendict.frozendict,  | question and associated possible answers | 

# items

question and associated possible answers

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict,  | frozendict.frozendict,  | question and associated possible answers | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**question** | str,  | str,  | question text | 
**[answers](#answers)** | list, tuple,  | tuple,  | array of possible multiple choice answers to this question | 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

# answers

array of possible multiple choice answers to this question

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
list, tuple,  | tuple,  | array of possible multiple choice answers to this question | 

### Tuple Items
Class Name | Input Type | Accessed Type | Description | Notes
------------- | ------------- | ------------- | ------------- | -------------
items | str,  | str,  | one of four possible answers to the associated question | 

# leaderboard

map of player id to score for this quiz

## Model Type Info
Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | -------------
dict, frozendict.frozendict,  | frozendict.frozendict,  | map of player id to score for this quiz | 

### Dictionary Keys
Key | Input Type | Accessed Type | Description | Notes
------------ | ------------- | ------------- | ------------- | -------------
**player** | str,  | str,  | the id of this player | 
**score** | decimal.Decimal, int,  | decimal.Decimal,  | the score of this player | [optional] 
**any_string_name** | dict, frozendict.frozendict, str, date, datetime, int, float, bool, decimal.Decimal, None, list, tuple, bytes, io.FileIO, io.BufferedReader | frozendict.frozendict, str, BoolClass, decimal.Decimal, NoneClass, tuple, bytes, FileIO | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

