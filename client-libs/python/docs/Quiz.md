# Quiz


## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str** | the display name of this quiz | 
**id** | **str** | unique, system-assigned identifier | [optional] [readonly] 
**description** | **str** | a short description of the quiz | [optional] 
**freeform** | **bool, none_type** | whether this quiz supports free-form answers | [optional] 
**run_count** | **int, none_type** | number of times quiz has been run | [optional] 
**host** | **str, none_type** | the id of the host | [optional] 
**play_url** | **str, none_type** | URL for playing this quiz | [optional] 
**pin** | **str, none_type** | pin code for playing this quiz | [optional] 
**topic** | **str, none_type** | the topic of this quiz | [optional] 
**anonymous** | **bool, none_type** | whether players may be anonymous | [optional]  if omitted the server will use the default value of True
**image_url** | **str, none_type** | string containing URL of an image to display for this quiz | [optional]  if omitted the server will use the default value of ""
**difficulty** | **str** | integer level of difficulty (1-10) | [optional]  if omitted the server will use the default value of "5"
**time_limit** | **str** | number of seconds to respond to each question in this quiz (3-300) | [optional]  if omitted the server will use the default value of "60"
**num_questions** | **str** | number of questions included in this quiz | [optional]  if omitted the server will use the default value of "10"
**num_answers** | **str** | number of answers possible for each question in this quiz (0 &#x3D;&#x3D; free form) | [optional]  if omitted the server will use the default value of "4"
**sync** | **bool** | is this quiz synchronous (false &#x3D;&#x3D; asynchronous) | [optional]  if omitted the server will use the default value of True
**active** | **bool, none_type** | is this quiz currently being played? | [optional]  if omitted the server will use the default value of False
**qand_a** | **str, none_type** | json string representation of questions, correct answers, and options | [optional] 
**time_created** | **datetime** | system-assigned creation timestamp | [optional] [readonly] 
**updated** | **datetime** | system-assigned update timestamp | [optional] [readonly] 
**self_link** | **str** | full URI of the resource | [optional] [readonly] 
**any string name** | **bool, date, datetime, dict, float, int, list, str, none_type** | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


