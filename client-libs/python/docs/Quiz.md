# Quiz


## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str** | the display name of this quiz | 
**generator** | **str** | quiz generator type | [optional] 
**answer_format** | **str** | response input (\&quot;freeform\&quot; or \&quot;multiple-choice\&quot;) | [optional] 
**topic** | **str** | the topic of this quiz | [optional] 
**num_questions** | **str** | number of questions included in this quiz | [optional] 
**difficulty** | **str** | integer level of difficulty (1-5) | [optional] 
**id** | **str** | unique, system-assigned identifier | [optional] [readonly] 
**self_link** | **str** | full URI of the resource | [optional] [readonly] 
**time_created** | **datetime** | system-assigned creation timestamp | [optional] [readonly] 
**updated** | **datetime** | system-assigned update timestamp | [optional] [readonly] 
**active** | **bool, none_type** | is this quiz currently being played? | [optional]  if omitted the server will use the default value of False
**anonymous** | **bool, none_type** | whether players may be anonymous | [optional] 
**creator** | **str, none_type** | the identity of the quiz creator | [optional] 
**cur_question** | **str, none_type** | current question number for active quiz or -1 for inactive | [optional]  if omitted the server will use the default value of "-1"
**image_url** | **str, none_type** | string containing URL of an image to display for this quiz | [optional] 
**pin** | **str, none_type** | pin code for playing this quiz | [optional] 
**play_url** | **str, none_type** | URL for playing this quiz | [optional] 
**q_and_a** | **str, none_type** | json string representation of questions, correct answers, and options | [optional] 
**run_count** | **str, none_type** | number of times quiz has been run | [optional]  if omitted the server will use the default value of "0"
**temperature** | **str** | generator temperature (0-1.0) | [optional]  if omitted the server will use the default value of ".5"
**randomize_questions** | **bool, none_type** | whether to present questions in random order | [optional]  if omitted the server will use the default value of True
**randomize_answers** | **bool, none_type** | whether to present answers in random order | [optional]  if omitted the server will use the default value of True
**survey** | **bool, none_type** | whether this quiz is an info gathering survey | [optional]  if omitted the server will use the default value of False
**synchronous** | **bool, none_type** | is this quiz synchronous (false &#x3D;&#x3D; asynchronous) | [optional]  if omitted the server will use the default value of True
**time_limit** | **str** | number of seconds to respond to each question in this quiz (3-300) | [optional] 
**description** | **str** | a short description of the quiz | [optional] 
**num_answers** | **str** | number of answers for each question in this quiz (1 &#x3D;&#x3D; free form) | [optional]  if omitted the server will use the default value of "4"
**any string name** | **bool, date, datetime, dict, float, int, list, str, none_type** | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


