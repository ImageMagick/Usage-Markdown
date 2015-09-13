#!/bin/env python

"""
Pandoc filter to run all imagemagick code in code blocks
"""

import os
import sys
import hashlib
from pandocfilters import toJSONFilter, Image, CodeBlock, Para
from subprocess import Popen, PIPE

DEBUG = True

IMAGEDIR = '_images'

# List of imagemagick tools; only commands in this list will be allowed to be run by the filter
IM_COMMANDS = ('animate', 'compare', 'composite', 'conjure', 'convert', 'display', 'identify', 'import', 'mogrify', 'montage', 'stream')
IM_IMAGE_TYPES = ('png', 'jpg', 'gif')

def sha1(x):
    return hashlib.sha1(x.encode(sys.getfilesystemencoding())).hexdigest()

def execute(code):
    """
    Executes the code.
    Performs some sanity checks first.
    """
#    if DEBUG:
#        sys.stderr.write('-'*100 + '\n')
    code = remove_slash(code)
    prev_dir = os.getcwd()
    os.chdir(IMAGEDIR)
    for line in code:
        if DEBUG:
            sys.stderr.write(line + '\n')
        commandline = line.split()
        if commandline[0] not in IM_COMMANDS:
            sys.stderr.write("Not a ImageMagick command: %s\n" % commandline[0])
            return
        image_name = commandline[-1]
        image_type = os.path.splitext(image_name)[1][1:].lower()
        if image_type not in IM_IMAGE_TYPES:
            sys.stderr.write("Not a ImageMagick Image Type: %s\n" % image_type)
            return
        p = Popen(' '.join(commandline), close_fds=True, stdout=PIPE, stderr=PIPE, shell=True)
        out, err = p.communicate()
        if out and DEBUG:
            sys.stderr.write(out + '\n')
        if err:
            sys.stderr.write(err + '\n')
    os.chdir(prev_dir)
    return

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
            outfile = os.path.join(IMAGEDIR, sha1(code))
            if format == "latex":
                filetype = "pdf"
            else:
                filetype = "png"
            src = outfile + '.' + filetype
            if not os.path.isdir(IMAGEDIR):
                try:
                    os.mkdir(IMAGEDIR)
                    sys.stderr.write('Created directory %s' % IMAGEDIR)
                except OSError:
                    sys.stderr.write('Could not create directory %s' % IMAGEDIR)
                    return
#            sys.stderr.write("classes: " + ','.join(classes) + '\n')
#            sys.stderr.write(str(zip(keyvals)) + '\n')

#        sys.stderr.write('Created image ' + src + '\n')
            execute(code)
            return [CodeBlock(("", [], []), code), Para([Image([], [src, ""])])]


if __name__ == "__main__":
    toJSONFilter(magick)
