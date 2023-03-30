# Quizrd API Reference

The Quizrd API is a REST-ful API which operates on the following
resources:

- *Players*
- *Admins*
- *Questions*
- *Quizzes*
- *Generators*

## Purpose and overview

The purpose of this API is to address the data needs relating to
constructing, generating, operating, and playing online trivia quizzes.

- A *player* participates in a *quiz*.
- An *admin* constructs and operates a *quiz*.
- A *question* is a multiple choice challenge with four possible answers.
- A *quiz* is an interactive online competition containing a sequence of *questions*. *Quizzes* may be shared and reused. *Quizzes* are operated in one of two modes:
  - synchronous - *players* answer each *question* in lock step
  - asynchronous - *players* respond to *questions* on their own schedule
- A *generator* generates a stream of *questions*.

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

Each *player* has one non-core properties:

| name | value |
| --- | --- |
| name | the display name of a *player* |

Each *player* has a sub-resource of *quizzes* they are currently playing, referenced with the URI `base_uri://players/player_id/quizzes` (there should not be a trailing */*). The only operation available on this sub-resource is *list*.

### Admins

Each *admin* has three non-core properties:

| name | value |
| --- | --- |
| name | the display name of an *admin* |
| email | the email address of an *admin* |
| active | boolean; whether this *admin* is currently active |

Any *admin* resource that has ever been used to create a
*quiz* should never be deleted. Instead, the _active_ property
should be set to `false`.

*insert* and *patch* operations that include an _email_ already
used in another *admin* resource will fail with a `409` status
code.

### Questions

Each *question* has three non-core properties:

| name | value |
| --- | --- |
| challenge| string describing the *question* challenge |
| answers | list of strings representing possible answers |
| imageUrl | string containing URL of an image to display |

A *question* resource with an _id_ that is referenced by a *quiz* cannot be deleted.

### Quizzes

Each *quiz* has thirteen non-core properties:

| name | value |
| --- | --- |
| name | the display name of this *quiz* |
| playUrl | URL for playing this quiz |
| pin | pin code for playing this quiz |
| topic | string representing the topic of this *quiz* |
| author | the id of the author of this *quiz* |
| numQuestions | number of *questions* included in this *quiz* |
| questions | array of ids of *questions* included in this *quiz* |
| difficulty | integer level of difficulty (1-10) |
| timeLimit | number of seconds to respond to each question in this *quiz* |
| leaderboard | a map of player ids to scores |
| imageUrl | string containing URL of an image to display for this *quiz* |
| sync | boolean; whether this *quiz* is synchronous or asynchronous |
| active | boolean; whether this *quiz* is currently being played |

Each *quiz's* name must be unique. Attempts to *insert* or *patch*
a *quiz* to have a _name_ already used by another *quiz* will
fail with a `409` status.

The _author_ and list of _questions_ properties of a *quiz* must contain the _id_ of an existing author, and *questions*, respectively.

### Generators

Each *generator* has four non-core properties:

| name | value |
| --- | --- |
| type | string representing the *generator* type |
| subscription | pubsub subscription for streaming *questions* from this *generator* |
| topic | pubsub topic for streaming *questions* from this *generator* |
| quizzes | list of ids of *quizzes* using this *generator* |

The value of the _quizzes_ property must be a list of _id_ of existing *quizzes*.
