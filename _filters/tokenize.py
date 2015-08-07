#!/usr/bin/env python
"""
Replace predefined terms in Pandoc JSON filter.

This filter matches any inline element wrapped in colons `:`, and replaces
element with corresponding object from a JSON dictionary.
"""
import json

__author__ = "Eric McConville"
__license__ = "ImageMagick License"
__version__ = "1.0.0"
__all__ = ('Tokenize',)


class Tokenize(object):
    def __init__(self, filename=None):
        if filename is None:
            msg = '{0} requires a filepath argument.'
            raise ValueError(msg.format(repr(self)))
        with open(filename, 'r') as fd:
            self.TOKEN_DICTIONARY = json.load(fd)

    def __call__(self, key, value, format, meta):
        if key == 'Str' and value[0] == value[-1] == ':':
            token = value[1:-1].lower()
            if token in self.TOKEN_DICTIONARY:
                return self.TOKEN_DICTIONARY[token]

if __name__ == '__main__':
    from os.path import join, dirname
    from pandocfilters import toJSONFilter
    tokenizer = Tokenize(join(dirname(__file__), 'tokens.json'))
    toJSONFilter(tokenizer)
