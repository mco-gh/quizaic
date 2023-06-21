# openapi_client.DefaultApi

All URIs are relative to *https://example.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**admins_get**](DefaultApi.md#admins_get) | **GET** /admins | Returns a list of admins
[**admins_id_delete**](DefaultApi.md#admins_id_delete) | **DELETE** /admins/{id} | deletes a single admin
[**admins_id_get**](DefaultApi.md#admins_id_get) | **GET** /admins/{id} | returns a single admin
[**admins_id_patch**](DefaultApi.md#admins_id_patch) | **PATCH** /admins/{id} | updates a single admin
[**admins_post**](DefaultApi.md#admins_post) | **POST** /admins | Create a new admin
[**generators_get**](DefaultApi.md#generators_get) | **GET** /generators | Returns a list of generators
[**generators_id_delete**](DefaultApi.md#generators_id_delete) | **DELETE** /generators/{id} | deletes a single generator
[**generators_id_get**](DefaultApi.md#generators_id_get) | **GET** /generators/{id} | returns a single generator
[**generators_id_patch**](DefaultApi.md#generators_id_patch) | **PATCH** /generators/{id} | updates a single generator
[**generators_post**](DefaultApi.md#generators_post) | **POST** /generators | Create a new generator
[**quizzes_get**](DefaultApi.md#quizzes_get) | **GET** /quizzes | Returns a list of quizzes
[**quizzes_id_delete**](DefaultApi.md#quizzes_id_delete) | **DELETE** /quizzes/{id} | deletes a single quiz
[**quizzes_id_get**](DefaultApi.md#quizzes_id_get) | **GET** /quizzes/{id} | returns a single quiz
[**quizzes_id_patch**](DefaultApi.md#quizzes_id_patch) | **PATCH** /quizzes/{id} | updates a single quiz
[**quizzes_post**](DefaultApi.md#quizzes_post) | **POST** /quizzes | Create a new quiz
[**results_get**](DefaultApi.md#results_get) | **GET** /results | Returns a list of results
[**results_id_delete**](DefaultApi.md#results_id_delete) | **DELETE** /results/{id} | deletes a single results object
[**results_id_get**](DefaultApi.md#results_id_get) | **GET** /results/{id} | returns a single results object
[**results_id_patch**](DefaultApi.md#results_id_patch) | **PATCH** /results/{id} | updates a single results object
[**results_post**](DefaultApi.md#results_post) | **POST** /results | Create a new results object (i.e. register a player)


# **admins_get**
> [Admin] admins_get()

Returns a list of admins

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.admin import Admin
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of admins
        api_response = api_instance.admins_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->admins_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Admin]**](Admin.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of admins |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **admins_id_delete**
> admins_id_delete(id)

deletes a single admin

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Admin Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single admin
        api_instance.admins_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->admins_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Admin Id |

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**204** | No content |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **admins_id_get**
> Admin admins_id_get(id)

returns a single admin

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.admin import Admin
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Admin Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single admin
        api_response = api_instance.admins_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->admins_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Admin Id |

### Return type

[**Admin**](Admin.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of an admin |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **admins_id_patch**
> Admin admins_id_patch(id, admin)

updates a single admin

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.admin import Admin
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Admin Id
    admin = Admin(
        name="name_example",
        email="email_example",
    ) # Admin | JSON representation of a single admin

    # example passing only required values which don't have defaults set
    try:
        # updates a single admin
        api_response = api_instance.admins_id_patch(id, admin)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->admins_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Admin Id |
 **admin** | [**Admin**](Admin.md)| JSON representation of a single admin |

### Return type

[**Admin**](Admin.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of an admin |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **admins_post**
> Admin admins_post(admin)

Create a new admin

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.admin import Admin
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    admin = Admin(
        name="name_example",
        email="email_example",
    ) # Admin | JSON representation of a single admin

    # example passing only required values which don't have defaults set
    try:
        # Create a new admin
        api_response = api_instance.admins_post(admin)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->admins_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **admin** | [**Admin**](Admin.md)| JSON representation of a single admin |

### Return type

[**Admin**](Admin.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**403** | Forbidden |  -  |
**404** | admin must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generators_get**
> [Generator] generators_get()

Returns a list of generators

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.generator import Generator
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of generators
        api_response = api_instance.generators_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->generators_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Generator]**](Generator.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of generators |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generators_id_delete**
> generators_id_delete(id)

deletes a single generator

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Generator Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single generator
        api_instance.generators_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->generators_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Generator Id |

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**204** | No content |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generators_id_get**
> Generator generators_id_get(id)

returns a single generator

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.generator import Generator
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Generator Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single generator
        api_response = api_instance.generators_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->generators_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Generator Id |

### Return type

[**Generator**](Generator.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of an generator |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generators_id_patch**
> Generator generators_id_patch(id, generator)

updates a single generator

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.generator import Generator
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Generator Id
    generator = Generator(
        name="name_example",
        freeform=False,
        topic_list=[
            "topic_list_example",
        ],
    ) # Generator | JSON representation of a single generator

    # example passing only required values which don't have defaults set
    try:
        # updates a single generator
        api_response = api_instance.generators_id_patch(id, generator)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->generators_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Generator Id |
 **generator** | [**Generator**](Generator.md)| JSON representation of a single generator |

### Return type

[**Generator**](Generator.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of an generator |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generators_post**
> Generator generators_post(generator)

Create a new generator

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.generator import Generator
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    generator = Generator(
        name="name_example",
        freeform=False,
        topic_list=[
            "topic_list_example",
        ],
    ) # Generator | JSON representation of a single generator

    # example passing only required values which don't have defaults set
    try:
        # Create a new generator
        api_response = api_instance.generators_post(generator)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->generators_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **generator** | [**Generator**](Generator.md)| JSON representation of a single generator |

### Return type

[**Generator**](Generator.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**403** | Forbidden |  -  |
**404** | generator must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **quizzes_get**
> [Quiz] quizzes_get()

Returns a list of quizzes

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.quiz import Quiz
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of quizzes
        api_response = api_instance.quizzes_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->quizzes_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Quiz]**](Quiz.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of quizzes |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **quizzes_id_delete**
> quizzes_id_delete(id)

deletes a single quiz

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Quiz Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single quiz
        api_instance.quizzes_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->quizzes_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Quiz Id |

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**204** | No content |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **quizzes_id_get**
> Quiz quizzes_id_get(id)

returns a single quiz

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.quiz import Quiz
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Quiz Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single quiz
        api_response = api_instance.quizzes_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->quizzes_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Quiz Id |

### Return type

[**Quiz**](Quiz.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a quiz |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **quizzes_id_patch**
> Quiz quizzes_id_patch(id, quiz)

updates a single quiz

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.quiz import Quiz
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Quiz Id
    quiz = Quiz(
        cur_question=-1,
        pin="pin_example",
        play_url="play_url_example",
        name="name_example",
        description="description_example",
        generator="generator_example",
        topic_format="topic_format_example",
        answer_format="answer_format_example",
        topic="topic_example",
        image_url="",
        num_questions="10",
        num_answers="4",
        time_limit="30",
        difficulty="3",
        temperature=".5",
        sync=True,
        anon=True,
        random_q=True,
        random_a=True,
        survey=False,
        qand_a="qand_a_example",
        creator="creator_example",
        active=False,
        run_count=1,
    ) # Quiz | JSON representation of a single quiz

    # example passing only required values which don't have defaults set
    try:
        # updates a single quiz
        api_response = api_instance.quizzes_id_patch(id, quiz)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->quizzes_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Quiz Id |
 **quiz** | [**Quiz**](Quiz.md)| JSON representation of a single quiz |

### Return type

[**Quiz**](Quiz.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a quiz |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **quizzes_post**
> Quiz quizzes_post(quiz)

Create a new quiz

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.quiz import Quiz
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    quiz = Quiz(
        cur_question=-1,
        pin="pin_example",
        play_url="play_url_example",
        name="name_example",
        description="description_example",
        generator="generator_example",
        topic_format="topic_format_example",
        answer_format="answer_format_example",
        topic="topic_example",
        image_url="",
        num_questions="10",
        num_answers="4",
        time_limit="30",
        difficulty="3",
        temperature=".5",
        sync=True,
        anon=True,
        random_q=True,
        random_a=True,
        survey=False,
        qand_a="qand_a_example",
        creator="creator_example",
        active=False,
        run_count=1,
    ) # Quiz | JSON representation of a single quiz

    # example passing only required values which don't have defaults set
    try:
        # Create a new quiz
        api_response = api_instance.quizzes_post(quiz)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->quizzes_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quiz** | [**Quiz**](Quiz.md)| JSON representation of a single quiz |

### Return type

[**Quiz**](Quiz.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**403** | Forbidden |  -  |
**404** | quizzes must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_get**
> [Results] results_get()

Returns a list of results

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.results import Results
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of results
        api_response = api_instance.results_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->results_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Results]**](Results.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of results |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_id_delete**
> results_id_delete(id)

deletes a single results object

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Results Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single results object
        api_instance.results_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->results_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Results Id |

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**204** | No content |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_id_get**
> Results results_id_get(id)

returns a single results object

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.results import Results
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Results Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single results object
        api_response = api_instance.results_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->results_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Results Id |

### Return type

[**Results**](Results.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a results object |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_id_patch**
> Results results_id_patch(id, results)

updates a single results object

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.results import Results
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Results Id
    results = Results(
        quiz="quiz_example",
        player="player_example",
        current_question=1,
        answers=[
            "answers_example",
        ],
    ) # Results | JSON representation of a single results object

    # example passing only required values which don't have defaults set
    try:
        # updates a single results object
        api_response = api_instance.results_id_patch(id, results)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->results_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Results Id |
 **results** | [**Results**](Results.md)| JSON representation of a single results object |

### Return type

[**Results**](Results.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a results object |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_post**
> Results results_post(results)

Create a new results object (i.e. register a player)

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.results import Results
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = openapi_client.Configuration(
    access_token = 'YOUR_BEARER_TOKEN'
)

# Enter a context with an instance of the API client
with openapi_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    results = Results(
        quiz="quiz_example",
        player="player_example",
        current_question=1,
        answers=[
            "answers_example",
        ],
    ) # Results | JSON representation of a (most likely empty) results object

    # example passing only required values which don't have defaults set
    try:
        # Create a new results object (i.e. register a player)
        api_response = api_instance.results_post(results)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->results_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **results** | [**Results**](Results.md)| JSON representation of a (most likely empty) results object |

### Return type

[**Results**](Results.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**403** | Forbidden |  -  |
**404** | results must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

