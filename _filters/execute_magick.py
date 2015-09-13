#!/bin/env python

"""
Pandoc filter to run all imagemagick code in code blocks
"""

import os
import sys
import hashlib
from pandocfilters import toJSONFilter, Image, CodeBlock, Para
from subprocess import Popen, PIPE

imagedir = '_images'

def sha1(x):
    return hashlib.sha1(x.encode(sys.getfilesystemencoding())).hexdigest()

def execute(code):
    sys.stderr.write('-'*100 + '\n')
    code = remove_slash(code)
    prev_dir = os.getcwd()
    os.chdir(imagedir)
    for line in code:
        sys.stderr.write(line + '\n')
        p = Popen(line, close_fds=True, stdout=PIPE, stderr=PIPE, shell=True)
        out, err = p.communicate()
        if err:
            sys.stderr.write(err + '\n')
        else:
            sys.stderr.write(out + '\n')
    os.chdir(prev_dir)

def remove_slash(text):
    """
    Joins lines, removing line-extending Backslashes ('\') from the text code
    :returns: list of strings
    """
    retval = []
    cummulative_line = ''
    for line in text.split('\n'):
        line = line.strip()
        if line.endswith('\\'):
            line = line.strip('\\')
            cummulative_line += line
        else:
            cummulative_line += line
#            execute(cummulative_line)
            retval.append(cummulative_line)
            cummulative_line = ''
    return retval

def magick(key, value, format, meta):
    if key == 'CodeBlock':
        [[ident, classes, keyvals], code] = value
        if 'magick' in classes:
            outfile = os.path.join(imagedir, sha1(code))
            if format == "latex":
                filetype = "pdf"
            else:
                filetype = "png"
            src = outfile + '.' + filetype
            if not os.path.isdir(imagedir):
                try:
                    os.mkdir(imagedir)
                    sys.stderr.write('Created directory %s' % imagedir)
                except OSError:
                    sys.stderr.write('Could not create directory %s' % imagedir)
                    return
#            sys.stderr.write("classes: " + ','.join(classes) + '\n')
#            sys.stderr.write(str(zip(keyvals)) + '\n')

#        sys.stderr.write('Created image ' + src + '\n')
            execute(code)
            return [CodeBlock(("", [], []), code), Para([Image([], [src, ""])])]


if __name__ == "__main__":
    toJSONFilter(magick)
