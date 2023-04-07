# Quiz


## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str, none_type** | the display name of this quiz | 
**id** | **str** | unique, system-assigned identifier | [optional] [readonly] 
**host** | **str** | the id of the host | [optional] 
**play_url** | **str** | URL for playing this quiz | [optional] 
**pin** | **str** | pin code for playing this quiz | [optional] 
**topic** | **str** | the topic of this quiz | [optional] 
**anonymous** | **bool** | whether players may be anonymous | [optional]  if omitted the server will use the default value of True
**image_url** | **str** | string containing URL of an image to display for this quiz | [optional] 
**difficulty** | **float** | integer level of difficulty (1-10) | [optional] 
**time_limit** | **float** | number of seconds to respond to each question in this quiz | [optional] 
**num_questions** | **float** | number of questions included in this quiz | [optional] 
**num_answers** | **float** | number of answers possible for each question in this quiz (0 &#x3D;&#x3D; free form) | [optional] 
**questions** | [**[QuizQuestions]**](QuizQuestions.md) | array of question/answer objects included in this quiz | [optional]  if omitted the server will use the default value of []
**sync** | **bool** | is this quiz synchronous (false &#x3D;&#x3D; asynchronous) | [optional]  if omitted the server will use the default value of True
**active** | **bool** | is this quiz currently being played? | [optional]  if omitted the server will use the default value of False
**time_created** | **datetime** | system-assigned creation timestamp | [optional] [readonly] 
**updated** | **datetime** | system-assigned update timestamp | [optional] [readonly] 
**self_link** | **str** | full URI of the resource | [optional] [readonly] 
**any string name** | **bool, date, datetime, dict, float, int, list, str, none_type** | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


