# openapi_client.DefaultApi

All URIs are relative to *https://example.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**admins_get**](DefaultApi.md#admins_get) | **GET** /admins | Returns a list of admins
[**admins_id_delete**](DefaultApi.md#admins_id_delete) | **DELETE** /admins/{id} | deletes a single admin
[**admins_id_get**](DefaultApi.md#admins_id_get) | **GET** /admins/{id} | returns a single admin
[**admins_id_patch**](DefaultApi.md#admins_id_patch) | **PATCH** /admins/{id} | updates a single admin
[**admins_post**](DefaultApi.md#admins_post) | **POST** /admins | Create a new admin
[**approvers_get**](DefaultApi.md#approvers_get) | **GET** /approvers | Returns a list of approvers
[**approvers_id_delete**](DefaultApi.md#approvers_id_delete) | **DELETE** /approvers/{id} | deletes a single approver
[**approvers_id_get**](DefaultApi.md#approvers_id_get) | **GET** /approvers/{id} | returns a single approver
[**approvers_id_patch**](DefaultApi.md#approvers_id_patch) | **PATCH** /approvers/{id} | updates a single approver
[**approvers_post**](DefaultApi.md#approvers_post) | **POST** /approvers | Create a new approver
[**campaigns_get**](DefaultApi.md#campaigns_get) | **GET** /campaigns | Returns a list of campaigns
[**campaigns_id_delete**](DefaultApi.md#campaigns_id_delete) | **DELETE** /campaigns/{id} | deletes a single campaign
[**campaigns_id_donations_get**](DefaultApi.md#campaigns_id_donations_get) | **GET** /campaigns/{id}/donations | lists all donations for the specified campaign
[**campaigns_id_get**](DefaultApi.md#campaigns_id_get) | **GET** /campaigns/{id} | returns a single campaign
[**campaigns_id_patch**](DefaultApi.md#campaigns_id_patch) | **PATCH** /campaigns/{id} | updates a single campaign
[**campaigns_post**](DefaultApi.md#campaigns_post) | **POST** /campaigns | Create a new campaign
[**causes_get**](DefaultApi.md#causes_get) | **GET** /causes | Returns a list of causes
[**causes_id_delete**](DefaultApi.md#causes_id_delete) | **DELETE** /causes/{id} | deletes a single cause
[**causes_id_get**](DefaultApi.md#causes_id_get) | **GET** /causes/{id} | returns a single cause
[**causes_id_patch**](DefaultApi.md#causes_id_patch) | **PATCH** /causes/{id} | updates a single cause
[**causes_post**](DefaultApi.md#causes_post) | **POST** /causes | Create a new cause
[**donations_get**](DefaultApi.md#donations_get) | **GET** /donations | Returns a list of donations
[**donations_id_delete**](DefaultApi.md#donations_id_delete) | **DELETE** /donations/{id} | deletes a single donation
[**donations_id_get**](DefaultApi.md#donations_id_get) | **GET** /donations/{id} | returns a single donation
[**donations_id_patch**](DefaultApi.md#donations_id_patch) | **PATCH** /donations/{id} | updates a single donation
[**donations_post**](DefaultApi.md#donations_post) | **POST** /donations | Create a new donation
[**donors_get**](DefaultApi.md#donors_get) | **GET** /donors | Returns a list of donors
[**donors_id_delete**](DefaultApi.md#donors_id_delete) | **DELETE** /donors/{id} | deletes a single donor
[**donors_id_donations_get**](DefaultApi.md#donors_id_donations_get) | **GET** /donors/{id}/donations | lists all donations for the specified donor
[**donors_id_get**](DefaultApi.md#donors_id_get) | **GET** /donors/{id} | returns a single donor
[**donors_id_patch**](DefaultApi.md#donors_id_patch) | **PATCH** /donors/{id} | updates a single donor
[**donors_post**](DefaultApi.md#donors_post) | **POST** /donors | Create a new donor or update existing donor with matching email address. Email address should uniquely specify a donor.
[**generators_get**](DefaultApi.md#generators_get) | **GET** /generators | Returns a list of generators
[**generators_id_delete**](DefaultApi.md#generators_id_delete) | **DELETE** /generators/{id} | deletes a single generator
[**generators_id_get**](DefaultApi.md#generators_id_get) | **GET** /generators/{id} | returns a single generator
[**generators_id_patch**](DefaultApi.md#generators_id_patch) | **PATCH** /generators/{id} | updates a single generator
[**generators_post**](DefaultApi.md#generators_post) | **POST** /generators | Create a new generator
[**hosts_get**](DefaultApi.md#hosts_get) | **GET** /hosts | Returns a list of hosts
[**hosts_id_delete**](DefaultApi.md#hosts_id_delete) | **DELETE** /hosts/{id} | deletes a single host
[**hosts_id_get**](DefaultApi.md#hosts_id_get) | **GET** /hosts/{id} | returns a single host
[**hosts_id_patch**](DefaultApi.md#hosts_id_patch) | **PATCH** /hosts/{id} | updates a single host
[**hosts_post**](DefaultApi.md#hosts_post) | **POST** /hosts | Create a new host
[**players_get**](DefaultApi.md#players_get) | **GET** /players | Returns a list of players
[**players_id_delete**](DefaultApi.md#players_id_delete) | **DELETE** /players/{id} | deletes a single player
[**players_id_get**](DefaultApi.md#players_id_get) | **GET** /players/{id} | returns a single player
[**players_id_patch**](DefaultApi.md#players_id_patch) | **PATCH** /players/{id} | updates a single player
[**players_post**](DefaultApi.md#players_post) | **POST** /players | Create a new player
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

# **approvers_get**
> [Approver] approvers_get()

Returns a list of approvers

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.approver import Approver
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
        # Returns a list of approvers
        api_response = api_instance.approvers_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->approvers_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Approver]**](Approver.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of approvers |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approvers_id_delete**
> approvers_id_delete(id)

deletes a single approver

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
    id = "id_example" # str | Approver Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single approver
        api_instance.approvers_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->approvers_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Approver Id |

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

# **approvers_id_get**
> Approver approvers_id_get(id)

returns a single approver

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.approver import Approver
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
    id = "id_example" # str | Approver Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single approver
        api_response = api_instance.approvers_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->approvers_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Approver Id |

### Return type

[**Approver**](Approver.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a approver |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approvers_id_patch**
> Approver approvers_id_patch(id, approver)

updates a single approver

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.approver import Approver
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
    id = "id_example" # str | Approver Id
    approver = Approver(
        name="name_example",
        email="email_example",
        active=False,
    ) # Approver | JSON representation of a single approver

    # example passing only required values which don't have defaults set
    try:
        # updates a single approver
        api_response = api_instance.approvers_id_patch(id, approver)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->approvers_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Approver Id |
 **approver** | [**Approver**](Approver.md)| JSON representation of a single approver |

### Return type

[**Approver**](Approver.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a approver |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approvers_post**
> Approver approvers_post(approver)

Create a new approver

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.approver import Approver
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
    approver = Approver(
        name="name_example",
        email="email_example",
        active=False,
    ) # Approver | JSON representation of a single approver

    # example passing only required values which don't have defaults set
    try:
        # Create a new approver
        api_response = api_instance.approvers_post(approver)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->approvers_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **approver** | [**Approver**](Approver.md)| JSON representation of a single approver |

### Return type

[**Approver**](Approver.md)

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
**404** | approvers must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_get**
> [Campaign] campaigns_get()

Returns a list of campaigns

### Example

```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.campaign import Campaign
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)


# Enter a context with an instance of the API client
with openapi_client.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of campaigns
        api_response = api_instance.campaigns_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Campaign]**](Campaign.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of campaigns |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_id_delete**
> campaigns_id_delete(id)

deletes a single campaign

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
    id = "id_example" # str | Campaign Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single campaign
        api_instance.campaigns_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Campaign Id |

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
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_id_donations_get**
> [Donation] campaigns_id_donations_get(id)

lists all donations for the specified campaign

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
    id = "id_example" # str | Campaign Id

    # example passing only required values which don't have defaults set
    try:
        # lists all donations for the specified campaign
        api_response = api_instance.campaigns_id_donations_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_id_donations_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Campaign Id |

### Return type

[**[Donation]**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of an array of donations |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_id_get**
> Campaign campaigns_id_get(id)

returns a single campaign

### Example

```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.campaign import Campaign
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)


# Enter a context with an instance of the API client
with openapi_client.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Campaign Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single campaign
        api_response = api_instance.campaigns_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Campaign Id |

### Return type

[**Campaign**](Campaign.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a campaign |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_id_patch**
> Campaign campaigns_id_patch(id, campaign)

updates a single campaign

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.campaign import Campaign
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
    id = "id_example" # str | Campaign Id
    campaign = Campaign(
        name="name_example",
        description="no description",
        cause="cause_example",
        managers=[],
        goal=0,
        image_url="image_url_example",
        active=False,
    ) # Campaign | JSON representation of a single campaign

    # example passing only required values which don't have defaults set
    try:
        # updates a single campaign
        api_response = api_instance.campaigns_id_patch(id, campaign)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Campaign Id |
 **campaign** | [**Campaign**](Campaign.md)| JSON representation of a single campaign |

### Return type

[**Campaign**](Campaign.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a campaign |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **campaigns_post**
> Campaign campaigns_post(campaign)

Create a new campaign

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.campaign import Campaign
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
    campaign = Campaign(
        name="name_example",
        description="no description",
        cause="cause_example",
        managers=[],
        goal=0,
        image_url="image_url_example",
        active=False,
    ) # Campaign | JSON representation of a single campaign

    # example passing only required values which don't have defaults set
    try:
        # Create a new campaign
        api_response = api_instance.campaigns_post(campaign)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->campaigns_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaign** | [**Campaign**](Campaign.md)| JSON representation of a single campaign |

### Return type

[**Campaign**](Campaign.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**404** | campaigns must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **causes_get**
> [Cause] causes_get()

Returns a list of causes

### Example

```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.cause import Cause
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)


# Enter a context with an instance of the API client
with openapi_client.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)

    # example, this endpoint has no required or optional parameters
    try:
        # Returns a list of causes
        api_response = api_instance.causes_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->causes_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Cause]**](Cause.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of causes |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **causes_id_delete**
> causes_id_delete(id)

deletes a single cause

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
    id = "id_example" # str | Cause Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single cause
        api_instance.causes_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->causes_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Cause Id |

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
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **causes_id_get**
> Cause causes_id_get(id)

returns a single cause

### Example

```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.cause import Cause
from pprint import pprint
# Defining the host is optional and defaults to https://example.com
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "https://example.com"
)


# Enter a context with an instance of the API client
with openapi_client.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id = "id_example" # str | Cause Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single cause
        api_response = api_instance.causes_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->causes_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Cause Id |

### Return type

[**Cause**](Cause.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a cause |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **causes_id_patch**
> Cause causes_id_patch(id, cause)

updates a single cause

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.cause import Cause
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
    id = "id_example" # str | Cause Id
    cause = Cause(
        name="name_example",
        description="no description",
        image_url="image_url_example",
        active=False,
    ) # Cause | JSON representation of a single cause

    # example passing only required values which don't have defaults set
    try:
        # updates a single cause
        api_response = api_instance.causes_id_patch(id, cause)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->causes_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Cause Id |
 **cause** | [**Cause**](Cause.md)| JSON representation of a single cause |

### Return type

[**Cause**](Cause.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a cause |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **causes_post**
> Cause causes_post(cause)

Create a new cause

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.cause import Cause
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
    cause = Cause(
        name="name_example",
        description="no description",
        image_url="image_url_example",
        active=False,
    ) # Cause | JSON representation of a single cause

    # example passing only required values which don't have defaults set
    try:
        # Create a new cause
        api_response = api_instance.causes_post(cause)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->causes_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cause** | [**Cause**](Cause.md)| JSON representation of a single cause |

### Return type

[**Cause**](Cause.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**404** | causes must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donations_get**
> [Donation] donations_get()

Returns a list of donations

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
        # Returns a list of donations
        api_response = api_instance.donations_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donations_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Donation]**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of donations |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donations_id_delete**
> donations_id_delete(id)

deletes a single donation

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
    id = "id_example" # str | Donation Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single donation
        api_instance.donations_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donations_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donation Id |

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
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donations_id_get**
> Donation donations_id_get(id)

returns a single donation

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
    id = "id_example" # str | Donation Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single donation
        api_response = api_instance.donations_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donations_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donation Id |

### Return type

[**Donation**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a donation |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donations_id_patch**
> Donation donations_id_patch(id, donation)

updates a single donation

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
    id = "id_example" # str | Donation Id
    donation = Donation(
        campaign="campaign_example",
        donor="donor_example",
        amount=3.14,
    ) # Donation | JSON representation of a single donation

    # example passing only required values which don't have defaults set
    try:
        # updates a single donation
        api_response = api_instance.donations_id_patch(id, donation)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donations_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donation Id |
 **donation** | [**Donation**](Donation.md)| JSON representation of a single donation |

### Return type

[**Donation**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a donation |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donations_post**
> Donation donations_post(donation)

Create a new donation

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
    donation = Donation(
        campaign="campaign_example",
        donor="donor_example",
        amount=3.14,
    ) # Donation | JSON representation of a single donation

    # example passing only required values which don't have defaults set
    try:
        # Create a new donation
        api_response = api_instance.donations_post(donation)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donations_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **donation** | [**Donation**](Donation.md)| JSON representation of a single donation |

### Return type

[**Donation**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**404** | donations must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_get**
> [Donor] donors_get()

Returns a list of donors

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donor import Donor
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
        # Returns a list of donors
        api_response = api_instance.donors_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Donor]**](Donor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of donors |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_id_delete**
> donors_id_delete(id)

deletes a single donor

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
    id = "id_example" # str | Donor Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single donor
        api_instance.donors_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donor Id |

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
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_id_donations_get**
> [Donation] donors_id_donations_get(id)

lists all donations for the specified donor

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donation import Donation
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
    id = "id_example" # str | Donor Id

    # example passing only required values which don't have defaults set
    try:
        # lists all donations for the specified donor
        api_response = api_instance.donors_id_donations_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_id_donations_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donor Id |

### Return type

[**[Donation]**](Donation.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of an array of donations |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_id_get**
> Donor donors_id_get(id)

returns a single donor

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donor import Donor
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
    id = "id_example" # str | Donor Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single donor
        api_response = api_instance.donors_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donor Id |

### Return type

[**Donor**](Donor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of a donor |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_id_patch**
> Donor donors_id_patch(id, donor)

updates a single donor

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donor import Donor
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
    id = "id_example" # str | Donor Id
    donor = Donor(
        name="name_example",
        email="email_example",
        mailing_address="mailing_address_example",
    ) # Donor | JSON representation of a single donor

    # example passing only required values which don't have defaults set
    try:
        # updates a single donor
        api_response = api_instance.donors_id_patch(id, donor)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Donor Id |
 **donor** | [**Donor**](Donor.md)| JSON representation of a single donor |

### Return type

[**Donor**](Donor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of a donor |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **donors_post**
> Donor donors_post(donor)

Create a new donor or update existing donor with matching email address. Email address should uniquely specify a donor.

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.donor import Donor
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
    donor = Donor(
        name="name_example",
        email="email_example",
        mailing_address="mailing_address_example",
    ) # Donor | JSON representation of a single donor

    # example passing only required values which don't have defaults set
    try:
        # Create a new donor or update existing donor with matching email address. Email address should uniquely specify a donor.
        api_response = api_instance.donors_post(donor)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->donors_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **donor** | [**Donor**](Donor.md)| JSON representation of a single donor |

### Return type

[**Donor**](Donor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | Created |  -  |
**404** | donors must have been misspelled in path |  -  |

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

# **hosts_get**
> [Host] hosts_get()

Returns a list of hosts

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.host import Host
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
        # Returns a list of hosts
        api_response = api_instance.hosts_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->hosts_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Host]**](Host.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of hosts |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hosts_id_delete**
> hosts_id_delete(id)

deletes a single host

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
    id = "id_example" # str | Host Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single host
        api_instance.hosts_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->hosts_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Host Id |

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

# **hosts_id_get**
> Host hosts_id_get(id)

returns a single host

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.host import Host
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
    id = "id_example" # str | Host Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single host
        api_response = api_instance.hosts_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->hosts_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Host Id |

### Return type

[**Host**](Host.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of an host |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hosts_id_patch**
> Host hosts_id_patch(id, host)

updates a single host

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.host import Host
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
    id = "id_example" # str | Host Id
    host = Host(
        name="name_example",
        email="email_example",
    ) # Host | JSON representation of a single host

    # example passing only required values which don't have defaults set
    try:
        # updates a single host
        api_response = api_instance.hosts_id_patch(id, host)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->hosts_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Host Id |
 **host** | [**Host**](Host.md)| JSON representation of a single host |

### Return type

[**Host**](Host.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of an host |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hosts_post**
> Host hosts_post(host)

Create a new host

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.host import Host
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
    host = Host(
        name="name_example",
        email="email_example",
    ) # Host | JSON representation of a single host

    # example passing only required values which don't have defaults set
    try:
        # Create a new host
        api_response = api_instance.hosts_post(host)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->hosts_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **host** | [**Host**](Host.md)| JSON representation of a single host |

### Return type

[**Host**](Host.md)

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
**404** | host must have been misspelled in path |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **players_get**
> [Player] players_get()

Returns a list of players

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.player import Player
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
        # Returns a list of players
        api_response = api_instance.players_get()
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->players_get: %s\n" % e)
```


### Parameters
This endpoint does not need any parameter.

### Return type

[**[Player]**](Player.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | A JSON array of players |  -  |
**403** | Forbidden |  -  |
**404** | not found. The path must have a typo |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **players_id_delete**
> players_id_delete(id)

deletes a single player

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
    id = "id_example" # str | Player Id

    # example passing only required values which don't have defaults set
    try:
        # deletes a single player
        api_instance.players_id_delete(id)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->players_id_delete: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Player Id |

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

# **players_id_get**
> Player players_id_get(id)

returns a single player

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.player import Player
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
    id = "id_example" # str | Player Id

    # example passing only required values which don't have defaults set
    try:
        # returns a single player
        api_response = api_instance.players_id_get(id)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->players_id_get: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Player Id |

### Return type

[**Player**](Player.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | JSON representation of an player |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **players_id_patch**
> Player players_id_patch(id, player)

updates a single player

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.player import Player
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
    id = "id_example" # str | Player Id
    player = Player(
        name="name_example",
        email="email_example",
    ) # Player | JSON representation of a single player

    # example passing only required values which don't have defaults set
    try:
        # updates a single player
        api_response = api_instance.players_id_patch(id, player)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->players_id_patch: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **str**| Player Id |
 **player** | [**Player**](Player.md)| JSON representation of a single player |

### Return type

[**Player**](Player.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
**201** | JSON representation of an player |  -  |
**403** | Forbidden |  -  |
**404** | not found |  -  |
**409** | Conflict. If-Match header provided does not match current contents |  -  |
**0** | Unexpected error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **players_post**
> Player players_post(player)

Create a new player

### Example

* Bearer (JWT) Authentication (bearerAuth):
```python
import time
import openapi_client
from openapi_client.api import default_api
from openapi_client.model.player import Player
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
    player = Player(
        name="name_example",
        email="email_example",
    ) # Player | JSON representation of a single player

    # example passing only required values which don't have defaults set
    try:
        # Create a new player
        api_response = api_instance.players_post(player)
        pprint(api_response)
    except openapi_client.ApiException as e:
        print("Exception when calling DefaultApi->players_post: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **player** | [**Player**](Player.md)| JSON representation of a single player |

### Return type

[**Player**](Player.md)

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
**404** | player must have been misspelled in path |  -  |

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
        name="name_example",
        description="description_example",
        freeform=True,
        run_count=1,
        host="host_example",
        play_url="play_url_example",
        pin="pin_example",
        topic="topic_example",
        anonymous=True,
        image_url="",
        difficulty="5",
        time_limit="60",
        num_questions="10",
        num_answers="4",
        sync=True,
        active=False,
        qand_a=[
            QuizQandA(
                question="question_example",
                correct="correct_example",
                responses=[],
            ),
        ],
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
        name="name_example",
        description="description_example",
        freeform=True,
        run_count=1,
        host="host_example",
        play_url="play_url_example",
        pin="pin_example",
        topic="topic_example",
        anonymous=True,
        image_url="",
        difficulty="5",
        time_limit="60",
        num_questions="10",
        num_answers="4",
        sync=True,
        active=False,
        qand_a=[
            QuizQandA(
                question="question_example",
                correct="correct_example",
                responses=[],
            ),
        ],
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

