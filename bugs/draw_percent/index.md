# Drawing a Percent Bug - FIXED

**Note:** Drawing Percent Characters is no longer an issue in IM, as percent '`%`' escapes were completely removed from all operators except "`-annotate`" for drawing text, and "`-label`" for "`montage`" labels.

This page is for reference for older IM users who may still have to deal with this bug.
The examples on this page have not been re-created when/if the bug was fixed.

------------------------------------------------------------------------

### A Percent Problem

The percent character '`%`' presents a different problem.
If you just use it, most likely it will draw onto the image just as you would expect.

~~~
convert -size 250x50 xc:none  -box white  -pointsize 20 -gravity center \
         -draw 'text 0,0 "  97%  "' \
        -trim +repage -bordercolor white -border 5x0  draw_percent_ok.gif
~~~


[![\[IM Output\]](draw_percent_ok.gif)](draw_percent_ok.gif)

But if you follow the percent character by certain special characters like '`d`' the percent and that character disappears.

~~~
convert -size 250x50 xc:none  -box white  -pointsize 20 -gravity center \
         -draw 'text 0,0 "  abc%def  "' \
        -trim +repage -bordercolor white -border 5x0  draw_percent_bad.gif
~~~


[![\[IM Output\]](draw_percent_bad.gif)](draw_percent_bad.gif)

The problem is that in the 'C' programming language "`%d`" is used for special purposes.
So replaces the character sequence with something else, in this case nothing.
This could probably be regarded as a **bug**.

The work-a-round was to replace all drawn text percent symbols with two such symbols, e.g. "`%%`'.

~~~
convert -size 250x50 xc:none  -box white  -pointsize 20 -gravity center \
         -draw 'text 0,0 "  abc%%def  "' \
        -trim +repage -bordercolor white -border 5x0  draw_percent_fixed.gif
~~~


[![\[IM Output\]](draw_percent_fixed.gif)](draw_percent_fixed.gif)

---
title: Drawing a Percent Bug
created: 1 August 2005  
updated: 9 August 2005  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.2.3
url: http://www.imagemagick.org/Usage/bugs/draw_percent/
---
