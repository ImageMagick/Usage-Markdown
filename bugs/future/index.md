# Future Development

**Index**
[![](../../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../../)
[![](../../img_www/granitesm_left.gif) Known and Fixed Bugs Index](../)

This page known problems in areas of IM currently under development, so are not true bugs, but works in progress.
Also listed below are new enhancements and suggested development within ImageMagick itself.

------------------------------------------------------------------------

## Future Development Proposals

This is a list of existing problems, and wants in ImageMagick.
It is also a sort of un-offical guide for things I may try to implement in IM.

Anything listed here is open for review, comment or suggestion, but should be taken with a grain of salt as they may never actually be implemented.
though the more comments people make on the [ImageMagick Discussion Forum](../../forum_link.cgi?f=1) and in emails to me, the more likely it will get implemented!

------------------------------------------------------------------------

### MVG expansion to allow full use of SVG gradients

SVG gradients which are overlaid as a 'fill tile', can be defined using multiple colors (not just two), linearly from one point to another (any angle), radially, or using path shapes.
The how range is defined in the [SVG -- Scalable Vector Graphics](http://www.w3.org/TR/SVG/) manual.

Currently IM only supports vertical linear gadients across the whole canvas of the image.

This lack is becoming important as just about every SVG image I have looked at relies of gradients of various forms for shading images.
Without it the SVG image conversion are basically yuck!.

An expandsion of the "`gradient:`" syntax to provide extra options would also be good.
For example (posibility only)

      gradient:'red=.1-green=.3-blue=.9, 1,1, 50,90'

These are suggestions for the future development for IM.
They are currently not being developed but have been requested my myself and other users on the IM mail lists and web forum.

Some of these may never be developed, others may not be provided until a new major version number release of IM.
Some may appear next week!

If you feel you can help, you can attempt to program these into IM and send the patches to Crisy.
I am sure he wold welcome them.

------------------------------------------------------------------------

### Scripted form of Convert Command

**This is now being implemented in IMv7**  

For details see [IMv7\_Scripting.txt](../IMv7_Scripting.txt).

What is really needed is for the command line API to be re-written in such as way as to allow...

-   argument processing, using pure argument order (IMv6 mixes this up a bit)
-   the ability to read all arguments from a file (convert scripts!).
    This could allow you to call IM, such as from PHP, without needing to do so though a shell wrapper.
    That is start IM as a piped open, and feed the commands to it.
-   argument strings from a file ("@filename") or pipeline ("@-")
-   insertion of numbers (with/without math processing) of values extracted from images already in memory
-   Proper handling of global settings, verses image attribute settings.
    Say snapshot and restore global settings.
    Keep global and image attributes separate at API call level.
-   Posible loop mechisims.
    Such as Loop over images in list, or reperat X times, numbers accessable as a percent escape.
-   if-then-else constructs for command line/script handling.
-   generation of definable and callable functions
-   conversion of command line options/script to compilable C program

This re-write may require some re-coding of mogrify which current does some very weird argument handling to separate the list of images to process, from the operations and settings needed to process them.
For example some settings need to be pre-set before reading the first image!

This new command line API could in fact be done as a separate command to convert, but will need someone to get the ball rolling and keep it moving.
One previous attempt that failed (probably was done before IM was ready for it) was "conjure".
The new version would have to be BOTH command line and script capable, and do what convert does to properly replace convert.

------------------------------------------------------------------------

### Auto-levels, Stretching, Auto-Gamma, De-normalizing problem

A IM Forum [Discussion](http://redux.imagemagick.org/discourse-server/viewtopic.php?p=24216) has resulted in a request for a "`-histogram-stretch`" operator which normalizes the image so that the given percentage of the brightest and darkest pixels are pegged to black and white.
That is a single odd white or black pixel will not majorly effect the overall result.

A "`-linear-stretch`" operator was also added recently.
  
Another IM mail list discussion between *Jason Lamey* and *Ed Halley*, talked about a posible gamma level auto adjusting operator.

Fit a gaussian peak to a histogram.
This will give you a peak position, and a width for the peak (two half-widths, actually).
Then choose a gamma value that will realign the distribution to be more centered and appropriately wide.

Redistributing the Histogram based on 'equalizing' the colors to fit a gaussian peak was also suggested by a image expert *Fred Weinhaus*.
The overall brightness and contrast of an image can then be controled by two simple arameters (mean and std).

    A simpler and linear transformation can be effective if one computes the
    linear transformation from a formula that uses desired mean and standard
    deviations along with the image's actual mean and standard deviation. That was
    why I was asking if you have a function that can extract the images mean and
    standard deviation (as well as the min and max values). Something like
    "-identify or info:" but more of an image statistics function that would report
    these values per channel.  This could be very useful.  

I have yet to find a real-world use for "`-equalize`"
  
The current "`-contrast-stretch`" operator normalizes images using the peak color values in the image, then moving those points inward by the percentages given.
This provides a more controled normalize.

**Current Recommended Solution**...

    Linear 'stretching' methods should be able to...

    For example woring with 8bit values and image with min = 100  and max =
    200 (make it easy) and a autolevel parameter of say 20 (units).

      1/  find the max and min values than move inward by 'percentage'
          so min+20  max-20   =>  level 120,180
          (black/white point arguments are 'color values')

      2/  cut off 20 pixel values from each end of the histogram
          (black/white point arguments are 'pixels')

      3/  select the value of the first bin from each end where the number
          of values in the exceeds 20  (the height of the bin)
          (black/white point arguments are 'pixels per bin')

    Also note that histograms have multiple types.
       separate color channels,  grayscale,  all values
       luminance (HSL colorspace)

    Once the points have been determined (per channel or combined channels)
    then the 'level' routines can be used to do the 'stretch' (as per -level).

    Implementation should separate the generation of histogram data that can then
    be used by various histogram modification methods. Including the posibility of
    the data of one image being used for a completely different image!

    Data output should correctly handle 8-bit histogram output (existing bug).

    The data can also be used to generate, histogram gradients, cumultive histogram
    gradients. Also we should be able to do gradient graphing (profile
    generation), rather than using external image generating applications.

    The data will also be used for equalize, and equalize-gaussian, histogram
    re-distribution, as well as histogram thresholding methods, and histogram
    segmentation.

------------------------------------------------------------------------

### Better handling of histograms, as LUT gradient images

    Hmmmmm....   I wonder if we can change the histogram: usage.

    That is  histogram: currently outputs a simple normalized  LUT  histogram
    (one row)  and also we add   cumulative:  to output a normalize cumulative
    histogram.

    BUT we also add    graph:   which graphs a LUT image!

    Now that would be great!  It can even follow the techniques that you
    developed in your "profile" script.  Or the displacement graphing
    technique I developed.



    Better still lets take all this OUT of the output and make them
    operations.

       -histogram  -cumulative  -graph

    Now this would be great!!!  Of course they can still contain a
    comment listing the actual value counts.

    We would need to be careful of both operations when a IM Q8 is used
    or the upper values could be clipped when the data is saved back into
    a image.   8bits means a maximum count of 255!  That is not very many
    pixels!  A solid color 16x16 image could exceed that!

    As such some expert otpions to control...
      * number of bins
      * height of the histogram (clipping to prevent high peaks)
        Actual value or based on image_size/number_of_bins
      * scaling of the histogram (especially for Q8 versions)
         + automatic  so maximum value maps to quantum range
         + fixed  N pixels to 1 value in histogram  (1:1 default)

    A cumulative function would probbaly need to be normalised to work.
    After all a 256x256 pixel count would fill a 16 bit value,
    unless HDRI is actually used.

------------------------------------------------------------------------

### Divide an image into horizontal rows (or columns) of pixels

Given an image, divide the image into rows (or columns) basied on rows of pixels which are similar to each other (according to the fuzz factor).

One implementation would be to divide image into blank,non-blank...
alturnating rows extracted from the image.
An argument can used to place constraints on the minimum size for the separate blank and non-blank areas.
A missed image at the start can denote if the first part was non-blank, something that is commonly just junked.

The offset positions can be kept or junked as per crop.

Two operators may be needed, -divide-vert and -divide-horiz.

    EG: divide-horizontally +{bw}+{nbw}

Complementary operators such as -layers 'remove-blank' and -layers 'remove-null' may be needed to allow user to also delete 'blank' images if these are unwanted.

**ADDUMDUM** I wrote a script [divide-vert](../../scripts/divide_vert) which does basically what I am suggesting gets built into IM.

Another similar script is [de-pixelate](../../scripts/de-pixelate) which removes 'doubled' rows and columns of pixels from an image.

This really should be part of a larger compound operator for -segmentation

------------------------------------------------------------------------

### Miscellanious functions to be added..

Other fuctions...

-   -trim-edges Edge\_list  
    Limit the trim to just the specific edges specified.

------------------------------------------------------------------------

### Consolidation of Specialized Blur Options

Currently we have two specialised blur operations... "`-radial-blur`" and "`-motion-blur`" as generic blur operations.

First of all "`-radial-blur`" is miss-named, as it is really a rotational blur.
A radial blur would blur out from the center point of the image or region, not in a circle around that point.

Secondally these speciallised blurs are only the start of a whole set of blur type operations that should be made available.
And implementing as a single option per blur type woudl produce far too many options.
It needs to be consolidated before new types of blurs are introduced.

I can see 7 types of special blurs...

| Type       | Direction       | Description                                   |
|:-----------|:----------------|:----------------------------------------------|
| linear     | one direction   | like -motion-blur                             |
| linear     | both directions | like a 1d blur, but at any angle)             |
| rotational | one direction   | like a electron around an atom                |
| rotational | both directions | like -radial-blur                             |
| radial     | out of          | small circles would look like asteroids speeding from the center |
| radial     | into            | things heading toward the center              |
| radial     | both in & out   |

I propose a single 2 argument operator for specialised blurs...

       -special-blur {type} {radius}x{sigma}+{dir}+{angle}

Where...

-   *type* is the type of blur as a string  
     EG: either "linear", "radial" or "rotational" and may be others in the future.
-   The *radius* and *sigma* is as normal though sigma represents an angle in degress rather than pixels in a 'rotational' blurs.
-   *dir* is either 0 or 3 for blurs in BOTH directions (default = 0)  
     1 for blur only in one positive direction  
     2 for blur in the other negative direction
-   *angle* is the angle for a linear blur (defaults = 0)

I do not want to separate these into separate settings as they are linked too closely to the specific operation being performed.

------------------------------------------------------------------------

### Specify the exact "Quantum Range" for specific output formats

At this time depth is generally restricted to 8 or 16 depending on the compile time Q-level of your IM installation.
That is setting of "`-depth 4`" only results in 8 bit images, not 4 bit images.
Of course that is only valid if the image format and IM even allows the use of 'depths' for that image format.

These depth/quantium restriction is becoming a problem for many image formats such as NetPBM, TXT (IM pixel enumeration), BMP, TIFF... etc..

~~~
convert -size 1x1000 gradient:  -define pbmplus:quantum=1000  t.pgm
~~~

        P2
        1 1000
        999
        999 998 997 ... 3 2 1 0

Where all image data values are in the 0 to 999 inclusive range.

If defined the setting overrides -depth

------------------------------------------------------------------------

### Image layout methods

Addition of "layout" methods to "convert".

For example a 'layout' method to generate a montage 'grid'.
A fixed sized grid of cells with optional spacing between cells.
Spacing may be negative to allow overlapping images, but will NOT 'clip' edge images (due to negative spacing) as "montage" currently does.

Note that spacing is not just a 'border' added to each image, as spacing on ends is the same as in the middle, except in the negative case.
Implementation can ignore any existing 'virtual canvas' setting, though could use use virtual canvas layering techniques to do image layout more efficientally.

Another posible layout method is 'lines', which appends images horizontally (with given spacings), with the appropriate vertical "`-gravity`" alignment, until "`-size`" width, is reached.
The line is then horizontally -gravity justified, and padded to the "`-size`" width.
When the height of all the lines exceeds a optionally given "`-size`" height, a new 'page' image is started, but pages are not padded, which will allow vertical justification using "`-extent`" using a different gravity setting.

Similarly for a 'columns' layout method but vertically, down the 'page' images, being generated.

The "`+/-append`" operator could be classed as a special type of layout method.
One in which "`-size`" is not used.

Other posible layout methods could include 'best fit into page' using various 2D 'napsack packing' algorithms, though that may mix up the order of the images so as to produce the smallest number of 'pages'.

See topic [Re: Informal but coherent montage](../../forum_link.cgi?f=1&t=21354) for a 'randomized layout' idea.

All methods however should record and keep track of the location each image ended up, for the purpose of 'HTML' image map generation, though it may be implemented as part of the image 'layering' rather than the specific layout method.
Something that "montage" currently does but which goes wrong in its 'concatenate' mode.

The above does NOT need to deal with frames, borders, captions, labels as these should be taken care of by pre-layout operations.

    How a 'general layout' operator (or command, like "montage") should work.

    1. Prepare images (rotations, framing, lables, and other 'fluff')
       This is generally external to the 'layout' method.

    2. initial placement of images ( randomly cover background completely,
       form rows, columns, arcs, spirals, etc)
       Limits of placement (unlimited, or width, height limits, shaped area)?

    3. optional adjustment of placements (minimise overlap, remove excess images
       such as those that go off the edge, or completely covered by other images)

    4. re-order the image layering (input order, top/bottom/left/right placement
       order, center uppermost, edge uppermost, randomize)

    5. output results....
         * flatten/mosaic/merge (generating the display image)
           (shadow handling may be added here)
         * generate imagemaps (for color index mapping)
         * generate imagemap table (color index, rectangular positions, to image
           name or link)

Note that all but the final step is really about generating a image placement list, and may only involve the images as part of that processing.

------------------------------------------------------------------------

### Output size control for Montage

Often it is imposible for a user to know how big a "`montage`" will be, and it has, many times, been suggested that some sort of output size control added.

That is specify a final size and geometry size, and let montage work out the tiling, (and perhaps geometry spacing) to produce however many pages are nessary.
Of course if the width of the individual tiles (as determined by -geometry is more that the final output size, then all bets are off, and a warning probably should be issued.

Or, specify the final size and number of tiles, then let montage work out the geometry needed.
What algorithm should be used for figuring out tile size verses tile spacing is another matter, particularly when labels and framing also needs to taken into account.

It may be that in both cases some extra boarder space will be required to 'pad out' the image to the exact image size requested, as a variable geometry or tile setting may not generate an exact fit.

At the moment there is no defined method of setting a final output image size.
Also what should "`montage`" do if all three (size, tile, geometry) is given.

------------------------------------------------------------------------

One suggestion is to allow the use of a '!' flag to "`-tile`" as meaning a 'fit to this size if posible' setting.
Of course the -tile setting (and extra boarder space) would then be the variable part of the montage generator.

EG: "`-tile 800x600\!`" would mean that montage will try to adjust the tile counts to form pages that fit into a final image of this size.

OR: "`-tile 800x\!`" will only adjust the number of columns to fit into 800 pixels, in a single page of appropriate length.

Some extra spacing may have to be added to the edges to handle any remaining space that can't be assorbed by the tile geometry size or spacing.

**NOTE:** This option is probably better implemented using core routines to replace montage completely.
"Convert script?"

------------------------------------------------------------------------

### Shadow controls in Montage (interface change - require major release)

Add some control to shadows within "`montage`" to allow user defined hard or soft shadows in a similar way that the new "`convert`", "`-shadow`" operator does.

No suggestions as to implimentation, as "`montage`" "`-shadow`" setting should probably remain a boolean on/off operator, unless it is added as part of a major version number release.

Similarly add some extra framing controls, would be nice if more that a single number is given.

------------------------------------------------------------------------

### Text/Image Justification Setting (as distinct to gravity positioning)

Separate the controls for text/image justification from the gravity defined position.
Justification should also have vertical and horizontal attributes.

Horizontal Attributes: left, center, right  

 Vertical Attributes: top, middle, baseline, bottom  

 The setting should consist of one item from both aspects.

If the justification is unset the gravity setting can be use to define the missing justification attribute to use...

       gravity_setting       default justification attributes
          undefined             Left       Baseline      (Top for images)
          North                 Center     Top
          South                 Center     Bottom
          East                  Right      Middle
          West                  Left       Middle

          Center                Center     Middle

          ... other gravity settings as appropriate ...

Note that 'Baseline' has no meaning for image justification.
But if specifically given for an images it should probably be equal to either 'Bottom', 'Middle' or prehaps to align with text better, 1/3 from the Bottom.

    ----
    Additional thoughts.

    Really for good positioning (composition) of anything (images or text) there
    are lots of factors, which could be important to its final location.

      gravity (positioning on background image, with X,Y coord)
      placement  (how the 'rectangle' should be placed relative to that
                   position, could also have a X,Y coord)
      scale/rotate
      justification  (how text is arranged within its 'box')

    That last is actually text to image creation
    The first we have already (but doing 'placement' as well)

    All but justification are essentially SRT distort (no gravity).
    But gravity can be calculated (relative to destination image)

------------------------------------------------------------------------

### Limit FX to smaller areas of an image

Having FX limit its effect to a specific region of an image.

This is much like using channels to limit what values FX generate but limiting its use to smaller areas of image.
Unlike regions however the i,j values will remain their correct values.

Proposed Solution: using a "fx:limit" set/define...

~~~
convert -size 5x5 plasma: \
        -channel R -set fx:limit '1x1+2+2'  -fx 'debug(u)' \
        null: 2>&1 | sort
~~~

[![\[IM Text\]](fx_region.txt.gif)](fx_region.txt)

Note that this can be further enhanced by having FX understand the use of write masks, so it does not waste energy on pixels that can't be written to.

------------------------------------------------------------------------

### Use of percent escapes in ALL arguments

Moved to [FX and Percent Escapes](../IMv7_FX_and_Percent.html)

------------------------------------------------------------------------

### Colorspace handling problems (as I have come to know them)...

A "\#xxxxx" color is non-specific to the colorspace and as such can be applied ASIS to any colorspace.
That is the value has a undefined colorspace, though an functional extension may allow you to define a colorspace for that color.

There is no way of specifying a named color with some transparency level.
EG: you can not specify a 50% transparent DodgerBlue color!

Named colors is actually defined as an SRGB color (it isn't actually an RGB!) and needs to be converted to the colorspace in which the color is being applied.
This is closely related to the problem reported by the user!

That is when the color gets recorded for future use, the colorspace of that color should also be recorded so the color can be converted appropriatally when applied to, or compared against, some specific image.
That is colors must be saved, not only with the 'values' but also the 'colorspace' of those values (unless undefined)

This is also related to the fact that IM currently (IMv6 that is) stores image by default as RGB colorspace when it is in fact really SRGB colorspace.
Most image formats should actually read/save images by default to SRGB, unless specifically declared otherwise.
GIF images especially should only save and load as SRGB!
While NetPBM/PbmPlus images are sometimes SRGB (real images) and sometimes RGB (mathematical images and gradients).

Continuing this problem... is that -colorspace SRGB of an image (currently marked as RGB) actually converts from SRGB to linear RGB for processing (marked as SRGB internally).
EG: the colorspace definations of RGB and SRGB in IMv6 is reversed!
This should not be changed in IMv6, as it it too throughly embedded, but it should only be fixed in IMv7.

The problem with this is that 'draw' functions is designed to do its anti-aliasing of lines and circles in linear RGB space.
At least that is what my tests are showing!
However images which are loaded are using SRGB colorspace.
If you (correctly) convert images to linear RGB (using -colorspace SRGB) before drawing on them, then convert back before saving the draw anti-aliasing works perfectly, producing nice smooth edge results.
See [Drawing with Gamma and Colorspace Correction](http://www.imagemagick.org/Usage/draw/#colorspace) for examples and details of this.

However as the 'SRGB named colors' are applied by draw without regard to colorspace, a image converted to linear RGB colorspace and drawn to will have the applied named colors become out 'wrong', when the drawn image gets converted back to SRGB (using -colorspace RGB) for saving!

In IMv6 direct drawing with named colors works, but only because draw is drawing directly to a SRGB colorspace image, and thus getting incorrect anit-aliased results.
Drawing correctly in linear RGB gets the anti-alising right but the colors wrong.
A loose-loose situation at present.

Basically all these colorspace handling problems needs to be looked at and fixed in IMv7!

------------------------------------------------------------------------

### Fill enlarges drawn areas by 1/2 pixel

Fill enlarges the fill area by 1/2 pixel.
This is done to allow drawing of lines to work (or by default you never see any line drawn) but really it is wrong.
It becomes a problem only when no stroke is used, and you want to 'join' adjacent polygonal areas.

For examples see [Draw Fill Bounds](../../draw/#bounds)

One solution is to have 'stoke' default to 'fill' when unset, and fill not 'enlarge' drawn areas.
that way if you specific set stroke to 'none' areas will not become 'enlarged'.
The problem is that at this time the stoke color can not be 'unset', or fall back to 'fill'.

------------------------------------------------------------------------

Created: 1 November 2005  
 Updated: 28 August 2012  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/bugs/future/`
