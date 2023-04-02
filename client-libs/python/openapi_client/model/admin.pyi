# coding: utf-8

"""
    Emblem API

    REST API for any Emblem server  # noqa: E501

    The version of the OpenAPI document: 2021-09-01
    Generated by: https://openapi-generator.tech
"""

from datetime import date, datetime  # noqa: F401
import decimal  # noqa: F401
import functools  # noqa: F401
import io  # noqa: F401
import re  # noqa: F401
import typing  # noqa: F401
import typing_extensions  # noqa: F401
import uuid  # noqa: F401

import frozendict  # noqa: F401

from openapi_client import schemas  # noqa: F401


class Admin(
    schemas.AnyTypeSchema,
):
    """NOTE: This class is auto generated by OpenAPI Generator.
    Ref: https://openapi-generator.tech

    Do not edit the class manually.
    """


    class MetaOapg:
        required = {
            "name",
            "email",
        }
        
        class properties:
            name = schemas.StrSchema
            email = schemas.StrSchema
            id = schemas.StrSchema
            timeCreated = schemas.DateTimeSchema
            updated = schemas.DateTimeSchema
            selfLink = schemas.StrSchema
            __annotations__ = {
                "name": name,
                "email": email,
                "id": id,
                "timeCreated": timeCreated,
                "updated": updated,
                "selfLink": selfLink,
            }

    
    name: MetaOapg.properties.name
    email: MetaOapg.properties.email
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["name"]) -> MetaOapg.properties.name: ...
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["email"]) -> MetaOapg.properties.email: ...
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["id"]) -> MetaOapg.properties.id: ...
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["timeCreated"]) -> MetaOapg.properties.timeCreated: ...
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["updated"]) -> MetaOapg.properties.updated: ...
    
    @typing.overload
    def __getitem__(self, name: typing_extensions.Literal["selfLink"]) -> MetaOapg.properties.selfLink: ...
    
    @typing.overload
    def __getitem__(self, name: str) -> schemas.UnsetAnyTypeSchema: ...
    
    def __getitem__(self, name: typing.Union[typing_extensions.Literal["name", "email", "id", "timeCreated", "updated", "selfLink", ], str]):
        # dict_instance[name] accessor
        return super().__getitem__(name)
    
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["name"]) -> MetaOapg.properties.name: ...
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["email"]) -> MetaOapg.properties.email: ...
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["id"]) -> typing.Union[MetaOapg.properties.id, schemas.Unset]: ...
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["timeCreated"]) -> typing.Union[MetaOapg.properties.timeCreated, schemas.Unset]: ...
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["updated"]) -> typing.Union[MetaOapg.properties.updated, schemas.Unset]: ...
    
    @typing.overload
    def get_item_oapg(self, name: typing_extensions.Literal["selfLink"]) -> typing.Union[MetaOapg.properties.selfLink, schemas.Unset]: ...
    
    @typing.overload
    def get_item_oapg(self, name: str) -> typing.Union[schemas.UnsetAnyTypeSchema, schemas.Unset]: ...
    
    def get_item_oapg(self, name: typing.Union[typing_extensions.Literal["name", "email", "id", "timeCreated", "updated", "selfLink", ], str]):
        return super().get_item_oapg(name)
    

    def __new__(
        cls,
        *_args: typing.Union[dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, bool, None, list, tuple, bytes, io.FileIO, io.BufferedReader, ],
        name: typing.Union[MetaOapg.properties.name, str, ],
        email: typing.Union[MetaOapg.properties.email, str, ],
        id: typing.Union[MetaOapg.properties.id, str, schemas.Unset] = schemas.unset,
        timeCreated: typing.Union[MetaOapg.properties.timeCreated, str, datetime, schemas.Unset] = schemas.unset,
        updated: typing.Union[MetaOapg.properties.updated, str, datetime, schemas.Unset] = schemas.unset,
        selfLink: typing.Union[MetaOapg.properties.selfLink, str, schemas.Unset] = schemas.unset,
        _configuration: typing.Optional[schemas.Configuration] = None,
        **kwargs: typing.Union[schemas.AnyTypeSchema, dict, frozendict.frozendict, str, date, datetime, uuid.UUID, int, float, decimal.Decimal, None, list, tuple, bytes],
    ) -> 'Admin':
        return super().__new__(
            cls,
            *_args,
            name=name,
            email=email,
            id=id,
            timeCreated=timeCreated,
            updated=updated,
            selfLink=selfLink,
            _configuration=_configuration,
            **kwargs,
        )
