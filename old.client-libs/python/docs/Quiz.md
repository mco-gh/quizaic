# Quiz


## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str, none_type** | the display name of this quiz | 
**play_url** | **str** | URL for playing this quiz | 
**pin** | **str** | pin code for playing this quiz | 
**topic** | **str** | the topic of this quiz | 
**author** | **str** | the id of the quizmaster of this quiz | 
**num_questions** | **str** | number of questions included in this quiz | 
**difficulty** | **float** | integer level of difficulty (1-10) | 
**time_limit** | **float** | number of seconds to respond to each question in this quiz | 
**leaderboard** | [**QuizLeaderboard**](QuizLeaderboard.md) |  | 
**questions** | [**[QuizQuestions]**](QuizQuestions.md) | array of question/answer objects included in this quiz | defaults to []
**sync** | **bool** | is this quiz synchronous (false &#x3D;&#x3D; asynchronous) | defaults to True
**active** | **bool** | is this quiz currently being played? | defaults to False
**id** | **str** | unique, system-assigned identifier | [optional] [readonly] 
**image_url** | **str** | string containing URL of an image to display for this quiz | [optional] 
**time_created** | **datetime** | system-assigned creation timestamp | [optional] [readonly] 
**updated** | **datetime** | system-assigned update timestamp | [optional] [readonly] 
**self_link** | **str** | full URI of the resource | [optional] [readonly] 
**any string name** | **bool, date, datetime, dict, float, int, list, str, none_type** | any string name can be used but the value must be the correct type | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


