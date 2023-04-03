# Quizrd API Reference

The Quizrd API is a REST-ful API which operates on the following
resources:

- *Players*
- *Host*
- *Admins*
- *Quizzes*
- *Generators*

## Purpose and overview

The purpose of this API is to address the data needs relating to
constructing, generating, operating, and playing online trivia quizzes.

- A *player* participates in a *quiz*.
- A *host* organizes and runs a *quiz*.
- A *sysadmin* manages the system.
- A *quiz* is an interactive online competition containing a sequence of multiple choice questions.
- A *generator* generates a *quiz* based on *host* specifications.

## Resources in general

Each resource, regardless of type, consists of _name/value_ pairs.
Every resource has a _kind_ (the name of the resource type), and
several *core* system assigned properties that are common to every
kind of resource:

 - _id_, which, along with the _kind_, uniquely specifies
that resource
- _timeCreated_
- _updated_
- _selfLink_, a unique URI of this resource

Every resource contains additional values specific to their
_kind_.

## Representations

The canonical representation of any resource is a JSON object listing
all the _name/value_ pairs in it. For example, an abstract resource
might be represented by:

    {
        "kind": "somekind",
        "id": "A8fj3js876",
        "timeCreated": "20211205T201500.00000Z",
        "updated": "20211215T114500.00000Z",
        "selfLink": "https://domain.name/somekind/A8fs3js876"
        "name": "Some resource",
        "score": 95
    }

Every resource sent to or returned from the API must have a
Content-Type of `application/json`.

## General Operations

Operations on resources are performed via HTTP(s) requests to
the resource's (or resource kind's) URI. They are consistent
with standard HTTP verbs and status codes.

Each resource may have special behaviors specific to its kind
but in general they follow the typical HTTP method behavior.

### Request Headers:

| Header | Value | Notes |
| --- | --- | --- |
| Content-Type | application/json | if request has a body |
| If-Match | string | only return value if resource's ETag matches |

### Response Headers:

| Header | Value | Notes |
| --- | --- | --- |
| Content-Type | application/json | if response has a body |
| ETag | string | if response contains a single resource |

### Status Codes:

| Code | Meaning |
| --- | --- |
| 200 | Request was honored |
| 403 | Request not authorized |
| 404 | No such kind |
| 409 | Resource's current ETag does not match If-Match value |

### Methods

#### list

Returns a list of all resources of a specific kind.

    GET base_uri://kinds

Note that there should not be a trailing slash `/`.

#### list_subresources

Returns a list of all child resources of a specific kind, of a specific resource.

For example, if a resource has a property whose name is the singular
version of another resource (such as a _donations_ resource has a property
name _campaign_, which is the singular version of _campaigns_, then that
resource is a child resource if that property matches the _id_ property of
the parent resource).

This allows fetching all donations for a particular campaign or for a
particular donor, for example.

    GET base_uri://parents/parent_id/childs

Note that there should not be a trailing slash `/`.

#### get

Returns a single resource, if available.

    GET base_uri://kinds/id

#### insert

Creates a new resource. Body is the JSON representation
of user-provided fields (that is, not including the kind,
id, selfLink, timeCreated, or updated values)

    POST base_uri://kinds

Note again that there should not be a trailing slash.

Response body is the newly created resource. Status code is 201.

#### patch

Changes an existing resource, if allowed. Body is the
JSON representation of fields to change.

    PATCH base_uri://kinds/id

Response body is the newly updated resource.

#### delete

Removes a resource, if possible.

    DELETE base_uri://kinds/id

Response body is empty. Status code is 204.

## Examples

[Examples](./example_requests.md) of how to interact with the API
using the [curl](https://curl.se/) command line tool are available.

## Resource details

### Players

Each *player* has two non-core properties:

| name | value |
| --- | --- |
| name | the display name of a *player* |
| email | the email address of a *player* |

*insert* and *patch* operations that include an _email_ already
used in another *player* resource will fail with a `409` status
code.

### Hosts

Each *host* has two non-core properties:

| name | value |
| --- | --- |
| name | the display name of an *host* |
| email | the email address of an *host* |

*insert* and *patch* operations that include an _email_ already
used in another *host* resource will fail with a `409` status
code.

### Admins

Each *admin* has two non-core properties:

| name | value |
| --- | --- |
| name | the display name of an *admin* |
| email | the email address of an *admin* |

*insert* and *patch* operations that include an _email_ already
used in another *admin* resource will fail with a `409` status
code.

### Quizzes

Each *quiz* has the following non-core properties:

| name | value |
| --- | --- |
| name | the display name of this *quiz* |
| host | the id of the *host* of this *quiz* |
| playUrl | URL for playing this *quiz* |
| pin | pin code for playing this *quiz* |
| topic | string representing the topic of this *quiz* |
| anonymous | boolean; whether players are anonymous |
| imageUrl | string containing URL of an image to display for this *quiz* |
| difficulty | integer level of difficulty (1-10) |
| timeLimit | number of seconds to respond to each question in this *quiz* |
| numQuestions | number of questions included in this *quiz* |
| numAnswers | number of answers for each question (0 == free form) |
| questions | array of questions and associated answers included in this *quiz* |
| answer | answer text (free form) or letter (multiple choice) |
| sync | boolean; whether this *quiz* is synchronous or asynchronous |
| active | boolean; whether this *quiz* is currently being played |

Each *quiz's* playUrl and pin must be unique. Attempts to *insert* or *patch* a *quiz* to have a _playUrl_ or _pin_ already used by another *quiz* will fail with a `409` status.

The _author_ of a *quiz* must contain the _id_ of an existing author.

### Generators

Each *generator* has three non-core properties:

| name | value |
| --- | --- |
| name | string representing the *generator* name |
| freeform | boolean; whether this *generator* supports free-form answers |
| topic_list | array of topics supported by this *generator* (empty == unlimited) |
