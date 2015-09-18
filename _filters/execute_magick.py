#!/bin/env python

"""
Pandoc filter to run all imagemagick code in code blocks
"""

import os
import sys
import hashlib
from pandocfilters import toJSONFilter, Image, CodeBlock, Para
from subprocess import Popen, PIPE

DEBUG = False

IMAGEDIR = '_images'

# List of imagemagick tools; only commands in this list will be allowed to be run by the filter
IM_COMMANDS = ('animate', 'compare', 'composite', 'conjure', 'convert', 'display', 'identify', 'import', 'mogrify', 'montage', 'stream', 'echo', 'printf')
IM_IMAGE_TYPES = ('png', 'jpg', 'gif', 'tif')

# Needed for writing unicode to stdout/stderr:
reload(sys)
sys.setdefaultencoding('utf-8')

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
    for line in code:
        if DEBUG:
            sys.stderr.write(line + u'\n')
        commandline = line.split()
        if commandline[0] not in IM_COMMANDS:
            sys.stderr.write("Not a ImageMagick command: %s\n" % commandline[0])
            return
        image_name = commandline[-1]
        image_type = os.path.splitext(image_name)[1][1:].lower()
        if os.path.isfile(image_name):
            sys.stderr.write("Image already exists: '%s'\n" % image_name)
            return os.path.join('..', IMAGEDIR, image_name)
        if image_type not in IM_IMAGE_TYPES:
            sys.stderr.write("Not a ImageMagick Image Type: %s\n" % image_type)
            return
        p = Popen(' '.join(commandline), close_fds=True, stdout=PIPE, stderr=PIPE, shell=True)
        out, err = p.communicate()
        if out and DEBUG:
            sys.stderr.write(out + '\n')
        if err:
            sys.stderr.write(err + '\n')
    return os.path.join('..', IMAGEDIR, image_name)

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
    """
    Filter to scan CodeBlocks for ImageMagick code and execute it to generate images.

    Example CodeBlock:
        ~~~{generate_image=True include_image=False}
        convert -size 40x20 xc:red xc:blue -append -rotate 90 append_rotate.gif
        ~~~

    All images are created in the '_images' directory (might need to be created first)
    Existing images will not be overwritten - we might want to add a command to the makefile like clean_images

    The filter will not blindly execute any codeblock, but expects a key/value pair:

        generate_image [True|False]
        Another switch enables the automatic generation of HTML code including the  tag for the generated image:

        include_image [True|False]

    Example CodeBlock:

        ~~~{generate_image=True include_image=False}
        convert -size 40x20 xc:red xc:blue -append -rotate 90 append_rotate.gif
        ~~~

    Note: Using fenced code blocks
        see http://pandoc.org/README.html#fenced-code-blocks
        and https://github.com/jgm/pandoc/issues/673

    Current limitations:

    - Image names need to be unique throughout the whole tree.
    - Complex commands, such as using perl/grep/pipes etc.
    - Will need to change image location for those examples which already explicitly include the image (ex. examples at the top of the antialising file)
    """
    if key == 'CodeBlock':
        [[ident, classes, keyvals], code] = value
        keyvals = dict(keyvals)
        if keyvals and keyvals.has_key('generate_image') and keyvals['generate_image']:

            # outfile = os.path.join(IMAGEDIR, sha1(code))
            # if format == "latex":
            #     filetype = "pdf"
            # else:
            #     filetype = "png"
            # src = outfile + '.' + filetype
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
            prev_dir = os.getcwd()
            os.chdir(IMAGEDIR)
            image = execute(code)
            os.chdir(prev_dir)
            if image:
                if keyvals and keyvals.has_key('include_image') and keyvals['include_image']:
                    return [CodeBlock(("", [], []), code), Para([Image([], [image, "generated my ImageMagick"])])]
                else:
                    return [CodeBlock(("", [], []), code)]
            else:
                return


if __name__ == "__main__":
    toJSONFilter(magick)
