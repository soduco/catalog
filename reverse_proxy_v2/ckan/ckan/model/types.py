# encoding: utf-8

import copy
import uuid
import simplejson as json

from sqlalchemy import types


__all__ = ['make_uuid', 'UuidType',
           'JsonType', 'JsonDictType']


def make_uuid():
    return str(uuid.uuid4())


class UuidType(types.TypeDecorator):
    impl = types.Unicode

    def process_bind_param(self, value, engine):
        return str(value)

    def process_result_value(self, value, engine):
        return value

    def copy(self):
        return UuidType(self.impl.length)

    @classmethod
    def default(cls):
        return str(uuid.uuid4())


class JsonType(types.TypeDecorator):
    '''Store data as JSON serializing on save and unserializing on use.

    Note that default values don\'t appear to work correctly with this
    type, a workaround is to instead override ``__init__()`` to explicitly
    set any default values you expect.
    '''
    impl = types.UnicodeText

    def process_bind_param(self, value, engine):
        # ensure we stores nulls in db not json "null"
        if value is None or value == {}:
            return None

        # ensure_ascii=False => allow unicode but still need to convert
        return str(json.dumps(value, ensure_ascii=False))

    def process_result_value(self, value, engine):
        if value is None:
            return {}

        return json.loads(value)

    def copy(self):
        return JsonType(self.impl.length)

    def is_mutable(self):
        return True

    def copy_value(self, value):
        return copy.copy(value)


class JsonDictType(JsonType):

    impl = types.UnicodeText

    def process_bind_param(self, value, engine):
        # ensure we stores nulls in db not json "null"
        if value is None or value == {}:
            return None

        if isinstance(value, str):
            return str(value)

        return str(json.dumps(value, ensure_ascii=False))

    def copy(self):
        return JsonDictType(self.impl.length)
