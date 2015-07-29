# Multi-Image Layers

**Index**
[![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
[![](../img_www/granitesm_right.gif) Layers Introduction](#intro)
[![](../img_www/granitesm_right.gif) Appending Images](#append) (-append)
[![](../img_www/granitesm_right.gif) Composition of Multiple Pairs of Images](#composition)
-   [Using Composite Command](#composite) (composite, -geometry)
-   [Composite Operator of Convert](#convert) (-composite, -geometry)
-   [Draw Multiple Images](#draw) (-draw 'image ..')

[![](../img_www/granitesm_right.gif) Layering Multiple Images](#layers)
-   [Flatten - onto a Background Image](#flatten)
-   [Mosaics - Canvas Expanding](#mosaic)
-   [Merging - to Create a New Layer Image](#merge)
-   [Coalesce Composition - a Progressive Layering](#coalesce)
-   [Compose Methods and Layering](#compose)
-   [Layers Composite - Merge Two Image Lists](#layer_composite)

[![](../img_www/granitesm_right.gif) Layering Image Examples](#layer_examples)
-   [Layering Thumbnails](#layer_thumbnails)
-   [Calculated Positioning of Images](#layer_calc)
-   [Two Stage Positioning of Images](#layer_prog)
-   [Pins in a Map](#layer_pins)
-   [Layers of Shadows](#layer_shadow)
-   [Distorted Image Placement using Layers](#layer_distort)

  
[![](../img_www/granitesm_right.gif) Evaluate Sequence Multi-Image Merging](#evaluate-sequence)
[Mean (average)](#eval-seq_mean),  [Min/Max Value](#eval-seq_max),  [Median Pixel](#eval-seq_median),   [Add](#eval-seq_add),  [Multiply](#eval-seq_multiply)
[![](../img_www/granitesm_right.gif) Poly - Merge Mutli-images Using a Polynomial](#poly)

Overlaying multiple images onto each other to generate a larger 'composite' is generally known as using image 'layering'.
These examples involve the combining of multiple 'layers' of images to produce the final larger more complex image.

------------------------------------------------------------------------

## Layering Images Introduction

As we have previously noted, ImageMagick does not deal with just one image, but a sequence or list of images.
This allows you to use IM in two very special image processing techniques.

You can for example think of each image in the list as a single frame in time, so that the whole list can be regarded as being a *Animation*.
This will be explored in other IM Example Pages.
See [Animation Basics](../anim_basics/).

Alternatively, you can think of each image in the sequence as *Layers* of a set of see-through overhead transparencies.
That is, each image represents a small part of the final image.
For example: the first (lowest) layer can represent a background image.
Above that you can have a fuzzy see though shadow.
Then the next layer image contains the object that casts that shadow.
On top of this a layer with some text that is written over that object.

That is you can have a sequence of images or 'layers' that each adds one more piece to a much more complex image.
Each image layer can be moved, edited, or modified completely separately from any other layer, and even saved into a multi-image file (such as TIFF:, MIFF: or XCF:) or as separate images, for future processing.
And that is the point of image layering.

Only when all the image layers have been created do you [Flatten](#flatten), [Mosaic](#mosaic), or [Merge](#merge) all the [Layered Images](#example) into a single final image.

------------------------------------------------------------------------

## Appending Images

Appending is probably the simplest, of the multi-image operations provided to handle multiple images.

Basically it joins the current sequence of images in memory into a column, or a row, without gaps.
The "`-append`" option appends vertically, while the plus form "`+append`" appends horizontally.

For example here we append a set of letter images together, side-by-side, to form a fancy word, in a similar way that individual 'glyphs' or letters of a 'font', are joined together.
  
      convert font_A.gif font_P.gif font_P.gif font_E.gif font_N.gif \
              font_D.gif font_E.gif font_D.gif +append  append_row.gif

[![\[IM Output\]](append_row.gif)](append_row.gif)

The above is similar (in a very basic way) to how fonts are handled.
Unlike real fonts you are not limited to just two colors, but can generate some very fancy colorful alphabets from individual character images.
Many of these 'image fonts' are available on the WWW for download.
A very small set can be found in [Anthony's Icon Library](http://www.ict.griffith.edu.au/anthony/icons/), in [Fonts for Text and Counters](http://www.ict.griffith.edu.au/anthony/icons/prog/fonts/Icons.html), which is also where I found the above [Blue Bubble Font](http://www.ict.griffith.edu.au/anthony/icons/prog/fonts/bubble_blue.xpm).

Note also how the "`+append`" operator was done as the last operation, after all the images that you want to append have been added to the current image sequence.

This is great for appending a label to an image, for example...
  
      convert rose:  -background LawnGreen label:Rose \
              -background white  -append append_label.jpg

  
[![\[IM Output\]](append_label.jpg)](append_label.jpg)

Note that the "`-background`" color was used to fill in any space that was not filled in.
Of course if the all the images are the same width, no space will be left for this fill.

From IM v6.4.7-1 the "`-gravity`" setting can be used to specify how the images should be added together.
As such in a vertical append, a setting of '`Center`' will center the image relative to the final resulting image (so will a setting of either '`North`' or '`South`').
  
      convert rose:  -background LawnGreen label:Rose \
              -background white -gravity center -append \
              append_center.jpg

  
[![\[IM Output\]](append_center.jpg)](append_center.jpg)

Naturally any '`East`' gravity setting will align the images on the right side.
  
      convert rose:  -background LawnGreen label:Rose \
              -background white -gravity east -append \
              append_east.jpg

  
[![\[IM Output\]](append_east.jpg)](append_east.jpg)

Similar vertical alignment can be achieved when using "`+append`"
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
Before IM v6.4.7 it was much more difficult to align appended images, and generally involved using a "`-flop`" for right alignment.
Or using "`-extent`" or "`-border`" to adjust the image width for centered aligned appends.
  
For example, this will work with an older 6.3.2 version of IM...
  
      convert rose:  -background SkyBlue label:Rose \
              -background White -gravity center -extent 200x \
              -append -trim +repage   append_center_old.jpg

  
[![\[IM Output\]](append_center_old.jpg)](append_center_old.jpg)

You can also use multiple append operations, in the same command without conflict or confusion as to the outcome of the operations (which was not the case before IM v6).
  
      convert font_{0,0,6,1,2}.gif +append  dragon_long.gif \
              -background none   -append   append_multi.gif

[![\[IM Output\]](append_multi.gif)](append_multi.gif)

We appended each row of images together, then appende a larger image below that.
This is very simple, and straight-forward.

By using [parenthesis](../basics/#parenthesis), you can append just the numbers after the larger image.
For example, here append all the numbers together, before appending them vertically to the dragon image we read in before the numbers.
  
      convert dragon_long.gif  '(' font_{0,0,6,2,9}.gif +append ')' \
              -background none   -append   append_parenthesis.gif

  
[![\[IM Output\]](append_parenthesis.gif)](append_parenthesis.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The parenthesis in the above must be either quoted, or escaped with a backslashed ('`\`') when used with a UNIX shell, otherwise they will be interpreted by the shell as something completely different.*
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*As only two images were involved we could have just used "`+swap`" or "`-reverse`" instead of using parenthesis.*

You can take this further to make a whole array of images, and build them either by rows, or by columns.
  
      convert \( font_1.gif font_2.gif font_3.gif +append \) \
              \( font_4.gif font_5.gif font_6.gif +append \) \
              \( font_7.gif font_8.gif font_9.gif +append \) \
              \( -size 32x32 xc:none  font_0.gif +append \) \
              -background none -append   append_array.gif

  
[![\[IM Output\]](append_array.gif)](append_array.gif)

Technically the first set of parenthesis is not needed, as no images have been read in yet, but it makes the whole thing look uniform and shows the intent of the command, in making an array of images.

See also [Montage Concatenation Mode](../montage/#concatenate), for an alternative way of creating arrays of equal sized images.
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
The "`-append`" operator will only append the actual images, and does not make use the virtual canvas (image page) size of offset.
However the virtual canvas information seems to be left in a funny state with the canvas sizes being added together and the offset set to some undefined value.
  
This may be regarded as a bug, and means either the input images or result should have the virtual canvas reset using "`+repage`", before saving, or using the image in operations where this information can become important.
  
This situation will probably be fixed in some future expansion of the operation.
Caution is thus advised, especially if re-appending [Tile Cropped](../crop/#crop_tile) images.

------------------------------------------------------------------------

## Composition of Multiple Pairs of Images

Compostion is the low-level operation that is used to merge two individual images together.
Almost all layering techniques eventaully devolve down to merging images together two at a time, until only one image is left.

So lets start by looking at ways of doing low-level composition of image pairs.
### Using the Composite Command

The traditional method of combining two images together using ImageMagick is though the "`composite`" command.
This command can only combine only two images at a time, saving the results of each operation into a file.
This of course does not stop you from using it to layer multiple images, one image at a time...
  
      convert -size 100x100 xc:skyblue composite.gif
      composite -geometry  +5+10 balloon.gif composite.gif composite.gif
      composite -geometry +35+30 medical.gif composite.gif composite.gif
      composite -geometry +62+50 present.gif composite.gif composite.gif
      composite -geometry +10+55 shading.gif composite.gif composite.gif

  
[![\[IM Output\]](composite.gif)](composite.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
As all input images are read in by ImageMagick BEFORE the output image is opened, you can output to one of the input images.
This allows you to work on the same image over and over, as shown above, without problems.
  
Do not do this with a lossy image format like "JPEG" as the format errors are accumulative, and the base image will quickly degrade.

You can also resize the overlaid image as well as position it using the "`-geometry`" setting.
  
      convert -size 100x100 xc:skyblue comp_resize.gif
      composite -geometry 40x40+5+10  balloon.gif comp_resize.gif comp_resize.gif
      composite -geometry      +35+30 medical.gif comp_resize.gif comp_resize.gif
      composite -geometry 24x24+62+50 present.gif comp_resize.gif comp_resize.gif
      composite -geometry 16x16+10+55 shading.gif comp_resize.gif comp_resize.gif

  
[![\[IM Output\]](comp_resize.gif)](comp_resize.gif)

The "`composite`" command also has a few other advantages in that you can use to control the way the image is drawn onto the background with the "`-compose`" option and its relative position is effected by the "`-gravity`" setting.

You can also "`-tile`" the overlay so that it will just cover the background image, without needing to specify tile limits.
This is something only available when using "`composite`".

The big disadvantage with this method is that you are using multiple commands, and IM has to write-out the working image, either to a pipeline, or to disk, for the next command to read-in again.

To find more examples of using the "`composite`" command, to overlay images on top of other images, see "[Annotating by Overlaying Images](../annotating/#overlay)" and "[Image Positioning using Gravity](../annotating/#image_gravity)".

### Composite Operator of Convert

The "`-composite`" operator is available within the "`convert`" command.
For more details see [Convert -composite Operator](../basics/#composite).
This allows you to do the same as the above, but all in one command.
  
      convert -size 100x100 xc:skyblue \
              balloon.gif  -geometry  +5+10  -composite \
              medical.gif  -geometry +35+30  -composite \
              present.gif  -geometry +62+50  -composite \
              shading.gif  -geometry +10+55  -composite \
              compose.gif

  
[![\[IM Output\]](compose.gif)](compose.gif)

This first creates a [Canvas Image](../canvas/#solid) which is "`skyblue`" in color, and then layers each of the later images onto that canvas at the given locations.

Now the "`-geometry`" is is a very special operator that not only sets an overlay position for the next "`-composite`" operation, it will also "`-resize`" the *last* image (and only the last image) in the current image sequence.
  
      convert -size 100x100 xc:skyblue \
              balloon.gif  -geometry 40x40+5+10   -composite \
              medical.gif  -geometry      +35+30  -composite \
              present.gif  -geometry 24x24+62+50  -composite \
              shading.gif  -geometry 16x16+10+55  -composite \
              compose_geometry.gif

  
[![\[IM Output\]](compose_geometry.gif)](compose_geometry.gif)

Note it is recommended that you avoid this 'resize' side-effect of of the "`-geometry`", even if it is convenient.
Basically as it is more of a backward compatibilty effect and may in some situations generate other effects.

Here is the more verbose recommendation...
  
      convert -size 100x100 xc:skyblue \
              \( balloon.gif -resize 40x40 \) -geometry +5+10   -composite \
              \( medical.gif               \) -geometry +35+30  -composite \
              \( present.gif -resize 24x24 \) -geometry +62+50  -composite \
              \( shading.gif -resize 16x16 \) -geometry +10+55  -composite \
              compose_resize.gif

  
[![\[IM Output\]](compose_resize.gif)](compose_resize.gif)

### Draw Multiple Images

Also using "`convert`" you can also use [Draw Primitives](../draw/#primitive) to overlay images onto its working canvas.
  
      convert -size 100x100 xc:skyblue \
              -draw "image over  5,10 0,0 'balloon.gif'" \
              -draw "image over 35,30 0,0 'medical.gif'" \
              -draw "image over 62,50 0,0 'present.gif'" \
              -draw "image over 10,55 0,0 'shading.gif'" \
              drawn.gif

  
[![\[IM Output\]](drawn.gif)](drawn.gif)

You can of course also specify a resize for the overlaid image too..
  
      convert -size 100x100 xc:skyblue \
              -draw "image over  5,10 40,40 'balloon.gif'" \
              -draw "image over 35,30  0,0  'medical.gif'" \
              -draw "image over 62,50 24,24 'present.gif'" \
              -draw "image over 10,55 16,16 'shading.gif'" \
              drawn_resize.gif

  
[![\[IM Output\]](drawn_resize.gif)](drawn_resize.gif)

The 'drawn' images can also be [Rotated, Scaled, and Affine Distorted](../draw/#transform) during the overlay process.
Though that can be tricky to get working the way you want.

Drawn images are "`-gravity`" effected, just like text.

------------------------------------------------------------------------

## Layering Multiple Images

True layering of images requires methods to combine multiple images together, without needing to individually compose each pair of images separately.
This is where the various `-layers` operator methods come into their own.

Ordering of layered images can be important, so it is a good idea to understand the special [Image Sequence or List Operators](../basics/#image_seq).

Note that 'layered images' is practically identical to the handling 'animated frames'.
As such it is recommended you also look at both [Animation Basics](../anim_basics/) and [Animation Modifications](../anim_mods/) for techniques involving processing individual 'layers' or 'frames'.
Actually animations often use the same `-layers` operator for processing images.

### Flatten - onto a Background Image

The "`-layers flatten`" image list operator, (or its shortcut "`-flatten`") will basically "[Compose](../compose/)" each of the given images on to a background to form one single image.
However the image positions are specified using their current [Virtual Canvas, or Page](../basics/#page) offset.

For example, here I create a nice canvas, and specify each of the images I want to overlay onto that canvas.
  
      convert -size 100x100 xc:skyblue \
              -fill dodgerblue -draw 'circle 50,50 15,25' \
              -page +5+10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -layers flatten  flatten_canvas.gif

  
[![\[IM Output\]](flatten_canvas.gif)](flatten_canvas.gif)
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
As of IM v6.3.6-2 the "`-flatten`" operator is only an alias for a "`-layers 'flatten'`" method.
  
Thus the "`-flatten`" option can be regarded as a short cut for the "`-layers`" method of the same name.

You don't need to create an initial canvas as we did above, you can instead let "`-flatten`" create one for you.
The canvas color will be the current "`-background`" color, while its size is defined by the first images [Virtual Canvas](../basics/#page) size.
  
      convert -page 100x100+5+10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50        present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -layers flatten  flatten_page.gif

  
[![\[IM Output\]](flatten_page.gif)](flatten_page.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
While the "`-gravity`" setting will effect image placement defined using "`-geometry`" settings, it will not effect image positioning using [virtual canvas offsets](../basics/#page) set via the "`-page`" setting.
This is part of the definition of such offsets.
See [Geometry vs Page Offsets](../compose/#geometry) for more details.
  
If placement with "`-gravity`" is need look at either the above multi-image composition methods, or the special [Layers Composition](../anim_mods/#composite) method that can handle both positioning methods simultaneously.

If any image does not appear in the defined virtual canvas area, it will either be clipped or ignored, as appropriate.
For example here we used a smaller canvas size, causing the later images not to appear completely on that canvas.
  
      convert -page 75x75+5+10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -flatten  flatten_bounds.gif

  
[![\[IM Output\]](flatten_bounds.gif)](flatten_bounds.gif)

The normal use of [Flatten](#flatten) is to merge multiple 'layers' of images together.

That is you can be generating various parts of a larger image, usually using [Parenthesis](../basics/#parenthesis) to limit image operators to the single 'layer' image being generated, and then flatten the final result together.

For example one typical use is to create a [Shadow Image](../blur/#shadow) layer, onto which the original image is flattened.
For example...
  
      convert balloon.gif \( +clone  -background navy  -shadow 80x3+5+5 \) +swap \
              -background none   -flatten   flatten_shadow.png

  
[![\[IM Output\]](flatten_shadow.png)](flatten_shadow.png)

Note that as I want the shadow under the original image, I needed to [swap](../basics/#swap) the two images place them in the right order.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
Using [Flatten](#flatten) for adding generated [Shadow Images](../blur/#shadow) is not recommended, as generated shadow images can have negative image offsets.
  
The recommended solution, as given in the section on [Shadow Images](../blur/#shadow), is to use the more advanced [Layer Merging](#merge) technique, we will look at later.

Because the [Virtual Canvas](../basics/#page) consists of just a size, the resulting image will be that size, but have no virtual canvas offset, as such you do not need to worry about any offsets present in the final image.

This use of the virtual canvas to define the canvas on which to overlay the image means you can use it to add a surrounding border to an image.
For example here I set the an image's size and virtual offset to 'pad out' an image to a specific size.
  
      convert medical.gif -set page 64x64+20+20 \
              -background SkyBlue   -flatten   flatten_padding.gif

  
[![\[IM Output\]](flatten_padding.gif)](flatten_padding.gif)

Of course there are better ways to [Pad Out an Image](../thumbnails/#pad) so that IM automatically centers the image in the larger area.
  
Strangely the exact same handling can be used to 'clip' or [Crop](../crop/#crop) an image to a virtual canvas that is smaller than the original image.
In this case however you want to use a negative offset to position the 'crop' location, as you are offseting the image and not positioning the crop 'window'.
  
      convert  logo:  -repage 100x100-190-60  -flatten  flatten_crop.gif

  
[![\[IM Output\]](flatten_crop.gif)](flatten_crop.gif)

Of course a [Viewport Crop](../crop/#crop_viewport) would also do this better, without the extra processing of canvas generation and overlaying that "`-flatten`" also does.
It also will not 'expand' the image itself to cover the whole viewport if the image was only partially contained in that viewing window.

A common mis-use of the "`-flatten`" operator is to [Remove Transparency](../masking/#remove) from an image.
That is to get rid of any transparency that an image may have, but overlaying it on the background color.
However this will not work when multiple images are involved as as such no longer recommended.
### Mosaic - Canvas Expanding

The "`-layers mosaic`" operator (or its "`-mosaic`" shortcut) is more like a expanding canvas version of the [Flatten Operator](.#flatten).
Rather than only creating an initial canvas based on just the canvas size of the initial image, the [Mosaic Operator](#mosaic) creates a canvas that is large enough to hold all the images (in the positive direction only).

For example here I don't even set an appropriate [Virtual Canvas](../basics/#page), however the "`-mosaic`" operator will work out how big such a canvas needs to be to hold all the image layers.
  
      convert -page +5+10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -layers mosaic  mosaic.gif

  
[![\[IM Output\]](mosaic.gif)](mosaic.gif)
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
As on IM v6.3.6-2 the "`-mosaic`" operator is only an alias for a "`-layers 'mosaic'`".
  
Thus the "`-mosaic`" option can be regarded as a short cut for the "`-layers`" method of the same name.

Note that both "`-mosaic`" and "`-flatten`" still creates a canvas that started from the 'origin' or 0,0 pixel.
This is part of the definition of an images 'virtual canvas' or 'page' and because of this you can be sure that the final image for both operators will have a no virtual offset, and the whole canvas will be fully defined in terms of actual pixel data.

Also note that "`-mosaic`" will only expand the canvas in the positive directions (the bottom or right edges), as the top and left edge are fixed to the virtual origin.
That of course means "`-mosaic`" will still clip images with negative offsets...
  
      convert -page -5-10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -mosaic  mosaic_clip.gif

  
[![\[IM Output\]](mosaic_clip.gif)](mosaic_clip.gif)

### Merging - to Create a New Layer Image

The "`-layers merge`" operator is almost identical to the previous operators and was added with IM v6.3.6-2.
It only creates a canvas image just large enough to hold all the given images at their respective offsets.

Like [Mosaic](#mosaic) will also expand the canvas, but not only in the positive direction, but also in the negative direction.
Basically it means that you don't have to worry about clipping, offset, or other aspects when merging layer images together.
All images will be merged relative to each others location.

The output does not include or ensure the origin is part of the expanded canavs.
As such the output of a [Layers Merge](#merge) can contain a 'layers offset' which may be positive or negative.

In otherwords..
[Layers Merge](#merge) merges layer images to produce a new *layer image*.

As such if you don't want that offset when finished you will probably want to include a "`+repage`" operator before the final save.

For example here is the same set of layer image we have used previously...
  
      convert -page +5+10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -layers merge  +repage layers_merge.gif

  
[![\[IM Output\]](layers_merge.gif)](layers_merge.gif)

As you can see the image is only just big enough to hold all the images which were placed relative to each other, while I discarded the resulting images offset relative to the virtual canvas origin.
This preservation of relative position without clipping or extra unneeded space is what make this variant so powerful.

Lets try this again by giving one image a negative offset...
  
      convert -page -5-10  balloon.gif   -page +35+30 medical.gif  \
              -page +62+50 present.gif   -page +10+55 shading.gif  \
              -background dodgerblue  -layers merge  +repage layers_merge_2.gif

  
[![\[IM Output\]](layers_merge_2.gif)](layers_merge_2.gif)

As you can see the "balloon" was not clipped, just moved further away from the others so as to preserve its relative distance to them.

Of course the "`+repage`" operator in the above examples, removes the absolute virtual canvas offset in the final image, preserving only the relative image placements between the images.
The offset was removed as web browsers often have trouble with image offsets and especially negative image offsets, unless part of a GIF animation.

But if I did not remove that offset, all the images will remain in their correct location on the virtual canvas within the generated single layer image, allowing you to continue to process and add more images to the merged image.
Typically you would use a "`-background`" color of '`None`', to make the unused areas of the merged image transparent.

When applied to a single image, [Layer Merging](#merge) will replace any transparency in the image with the solid color background, but preserve the images original size, as well as any any offsets in that image, The virtual canvas size of the image however may be adjusted to 'best fit' that images size and offset.

The operators original purpose was allow users to more easily merge multiple distorted images into a unified whole, regardless of the individual images offset.
For example when aligning photos to form a larger 'panorama'.
You could simply start with a central undistorted base image (without an offset), and use this operator to overlay the other images around that starting point (using either negative or positive offsets) that have been aligned and distorted to match that central image.

For other examples of using this operator by distorting images to align common control points, see [3D Isometric Photo Cube](../distorts/#cube3d), and [3D Perspective Box](../distorts/#cube3d).

Other examples of using this operator is to generate a simple series of [Overlapping Photos](../photos/#overlap).

    The operation "-layers trim-bounds" can be used to ensure all
    images get a positive offset on a minimal canvas size, while retaining there
    relative positions, and without actually layer merging the images into one
    final image.

    This lets you then perform further processing of the images before they are
    actually merged, such as placing more images relative to the that image group
    but looking up the resulting virtual canvas bounds.

    However if images have a transparency, it is probably a good idea to trim
    that transparency from images first, making the ideal usage...

      -alpha set -bordercolor none -border 1x1 -trim -layers trim-bounds

    This minimizes the image layers including any and all transparent areas of
    actual image data, while ensuring everything is contained on a valid
    virtual (positive) canvas of minimal size.

### Coalesce Composition - a Progressive Layering

The "`-layers coalesce`" image operator (or its "`-coalesce`" shortcut) is really designed for converting GIF animations into a sequence of images.
For examples, see [Coalescing Animations](../anim_basics/#coalesce) for details.

However, it is very closely associated with "`-flatten`" and has very useful effects for multi-layered images in this regard.
  
For example using [Coalesce](#coalesce) on a single image, will do exact the same job as using [Flatten](#flatten) with a "`-background`" color of '`None`' or '`Transparency`'.
That is it will 'fill out' the canvas of the image with transparent pixels.
  
      convert  -page 100x100+5+10 balloon.gif -layers coalesce  coalesce_canvas.gif

  
[![\[IM Output\]](coalesce_canvas.gif)](coalesce_canvas.gif)

When dealing with a image consisting on multiple layers, [Coalesce](#coalesce) can be used to generate a 'Progressive Layering' of the image.
But to do this we need to take a few precautions, to disable any 'GIF animation' handling by the operator.
  
       convert -page 100x100+5+10 balloon.gif   -page +35+30 medical.gif  \
               -page +62+50       present.gif   -page +10+55 shading.gif  \
               -set dispose None  -coalesce  miff:- |\
         montage - -frame 4 -tile x1 -geometry +2+2 \
                 -background none -bordercolor none  coalesce_none.gif

[![\[IM Output\]](coalesce_none.gif)](coalesce_none.gif)

In the above, we "`-set`" all the "`-dispose`" settings to '`None`'.
This effectively tells "`-coalesce`" to just overlay each frame on top the results of the previous overlays.

The result is the first image is just a 'fill out' of the images canvas, with a transparency background.
The next image is the previous image with that layer overlaid.
And so on.
A 'progressive' flatten of the image sequence.

The last image in the sequence will thus be the same as if you did a normal "`-flatten`" with a transparent background.

You can get a completely different sort of effect if you had used a "`-dispose`" setting of '`Background`'.
In this case "`-coalesce`" will just 'fill out' the canvas of each image, as if they were completely separate images!
  
      convert -page 100x100+5+10 balloon.gif   -page +35+30 medical.gif  \
              -page +62+50       present.gif   -page +10+55 shading.gif  \
              -set dispose Background  -coalesce  miff:- |\
        montage - -frame 4 -tile x1 -geometry +2+2 \
                -background none -bordercolor none  coalesce_bgnd.gif

[![\[IM Output\]](coalesce_bgnd.gif)](coalesce_bgnd.gif)

Please note however that unlike [Flatten](#flatten), [Mosaic](#mosaic), or [Merge](#merge) the "`-coalesce`" operator does *not* make use of the current "`-compose`" alpha composition setting.
It only uses an '`Over`' compose method, as this is what is required for GIF animation handling.

Using different "`-compose`" methods with the more standard image layering operators is the subject of the next set of examples.

### Compose Methods and Layering

The three [Layering](#layers) methods '`flatten`', '`mosaic`' will make use of the "`-compose`" setting to determine the composition method used to overlay each image in sequence.
As such you could think of these functions as a multi-image "`-composite`" operator with the ability to set an initial "`-background`" canvas color.

However using anything but the default [Alpha Composition](../compose/) of '`Over`' requires some thought before applying or you will get unexpected results.
You may also may need to thing about the effect of the "`-background`" color that is used by these operators to generate a starting canvas, onto with each image (including the first) in composed.

For example lets place each successive image *under* the previous images using a '`DstOver`'...
  
      convert -page 100x100+5+10 balloon.gif   -page +35+30 medical.gif  \
              -page +62+50       present.gif   -page +10+55 shading.gif  \
              -background none  -compose DstOver  -flatten  flatten_dstover.gif

  
[![\[IM Output\]](flatten_dstover.gif)](flatten_dstover.gif)

Here the background was set to be transparent, otherwise you will only see the background canvas in the result as all the other images will have been placed 'under' this initial canvas!
This does provide a way of 'blanking' an image with a particular color, as shown in [Canvases Sized to an Existing Image](../canvas/#sized).

Here is a more practical example.
Rather than layering the images with the background canvas first, which awkward and un-natural in some image processing situations, you can just generate the images top-down or foreground to background order.
  
      convert rose: -repage +10+10 \
              \( +clone -background black -shadow 60x3+5+5 \) \
              \( granite: -crop 100x80+0+0 +repage \) \
              -background none  -compose DstOver -layers merge layer_dstover.gif

  
[![\[IM Output\]](layer_dstover.gif)](layer_dstover.gif)

Each of the first three lines generates one layer image, with the final line merging all the layers under the previous layers, effectively reversing the order.

As you can see the image processing for the above was simpler and cleaner than you normally would see with shadow generation, just by underlaying each image in sequence (with a transparent starting canvas)

Of course I could have just as easily [Reverse](../basics/#reverse) the image list instead.
  
      convert rose: -repage +10+10 \
              \( +clone -background black -shadow 60x3+5+5 \) \
              \( granite: -crop 100x80+0+0 +repage \) \
              -reverse -layers merge layer_reverse.gif

  
[![\[IM Output\]](layer_reverse.gif)](layer_reverse.gif)

However remember that this only re-orders the existing images, and does not effect the 'starting background canvas' that the layering methods create.
The compose methods can also be used to produce some interesting effects.
For example, if you draw three circles, then by overlaying them using the '`Xor`' compose method, you get a unusual and complex looking symbol, for minimal effort.
  
      convert -size 60x60 \
              \( xc:none -fill blue   -draw 'circle 21,39 24,57' \) \
              \( xc:none -fill red    -draw 'circle 39,39 36,57' \) \
              \( xc:none -fill green  -draw 'circle 30,21 30,3'  \) \
              -background none  -compose Xor   -flatten  flatten_xor.png

  
[![\[IM Output\]](flatten_xor.png)](flatten_xor.png)

### Layers Composite - Merge Two Layer Lists

With IM v6.3.3-7 the "`-layers`" method, '`Composite`' was added allowing you compose two completely separate sets of images together.

To do this on the command line a special '`null:`' marker image is needed to define where the first *destination* list of images ends and the overlaid *source* image list begins.
But that is the only real complication of this method.

Basically each image from the first list is composed against the corresponding image in the second list, effectivally merging the two lists together.

The second list can be positioned globally relative to the first list, using a [Geometry Offset](../compose/#geometry), just as you can with a normal [Composite Operator](../compose/#convert) (see above).
Gravity is also applied using the canvas size of the first image, to do the calculations.

On top of that 'global offset', the individual virtual offset of image is also preserved, as each pair of images is composited together.

One special case is also handled.
If one of the image lists contains only one image, that image will be composed against all the images of the other list.
Also in that case the image meta-data (such as animation timings) of larger list is what will be kept, even if it is not the destination side of the composition.

This laying operator is more typically used when composing two animations, which can be regarded as a sort of time-wise layered image list.
Because of this it is better exampled in the [Animation Modifications](../anim_mods/) section of the examples.
So see [Multi-Image Alpha Composition](../anim_mods/#compose) for more details.

------------------------------------------------------------------------

## Handling Image Layers

Laying multiple images using the various layer operators above is a very versatile technique.
It lets you work on a large number of images individually, and then when finished you combine them all into a single unified whole.

So far we have shown various ways of merging (composing or layering) multiple images in many different ways.
Here I provide some more practical examples on just how to make use of those techniques.

### Layering Of Thumbnail Images

You can also use this technique for merging multiple thumbnails together in various complex ways.

Here I add a [Soft Edge](../thumbnails/#soft_edges) to the images as you read and position them, you can generate a rather nice composition of images, on a [Tiled Canvas](../canvas/#tile).
  
      convert -page +5+5    holocaust_tn.gif \
              -page +80+50  spiral_stairs_tn.gif \
              -page +40+105 chinese_chess_tn.gif \
              +page \
              -alpha Set -virtual-pixel transparent \
              -channel A -blur 0x10  -level 50,100% +channel \
              \( -size 200x200 tile:tile_fabric.gif -alpha Set \) -insert 0 \
              -background None -flatten  overlap_canvas.jpg

[![\[IM Output\]](overlap_canvas.jpg)](overlap_canvas.jpg)

### Calculated Positioning of Images.

The [Virtual Canvas Offset (page)](../basics/#page) can be set in many ways.
More specifically you can "`-set`" set this per-image [Attribute](../basics/#attribute), and even calculate a different location for each and every image.

For example here I read in a big set of images (small icon images all the same size) and arrange them in a circle.
  
      convert {balloon,castle,eye,eyeguy,ghost,hand_point,medical}.gif \
              {news,noseguy,paint_brush,pencil,present,recycle}.gif \
              {shading,skull,snowman,storm,terminal,tree}.gif \
              \
              -set page '+%[fx:80*cos((t/n)*2*pi)]+%[fx:80*sin((t/n)*2*pi)]' \
              \
              -background none -layers merge +repage image_circle.png

[![\[IM Output\]](image_circle.png)](image_circle.png)

The key to the above example is the "`-set page`" operation that uses the normalized image index (the [FX Expression](http://www.imagemagick.org/script/fx.php) '`t/n`' ) to create a value from 0.0 to not quite 1.0 for each individual image.
This value is then mapped to position the image (by angle) in a circle of 80 pixels radius, using [FX Expressions as a Percent Escape](../transform/#fx_escapes).

The position calculated is of the top-left corner of the image (not its center, though that is a simple adjustment), which is then [Merged](#merge) to generate a new image.
The positioning is done without regard of the offset being positive or negative, which is the power of the [Merge Laying Operator](#merge).
That is we generated a new image of all the images as they are relative to each other.

The final "`+repage`" removes the final resulting negative offset of the merged layer image, as this is no longer needed and can cause problems when viewing the resulting image.

Note that the first image (right-most in result) is layered below every other image.
If you want the layering to be truely cyclic so the last image was below this first one, you may have either: to generate and combine two versions of the above, with different ordering of the images; or overlay the first image on the last image, correctly, before generating the circle.
Both solutions are tricky, and is left as a exercise.

This technique is powerful, but it can only position images to a integer offset.
If you need more excate sub-pixel positioning of images then the images will need to be distorted (translated) to the right location rather than simply adjusting its virtual offset.

#### Incrementally Calculated Positions

You can access some image attributes of other images using FX expressions, while setting the attribute of images as they are processed.
This means that you can set the location of each image, relative the calculated position of the previous image.

For example this sets the position of each image to be the position of the previous image, plus the previous images width.
  
      convert  rose: netscape: granite: \
              \
              +repage -set page '+%[fx:u[t-1]page.x+u[t-1].w]+0' \
              \
              -background none -layers merge +repage append_diy.png

[![\[IM Output\]](append_diy.png)](append_diy.png)

Each image is appended to the location of the previous image, by looking up that location and adding that images width.
This previous location was in fact just calculated, as IM looped through each image setting the '`page`' (virtual offset) attribute.
The result is a DIY [Append Operator](#append) equivalent, and from which you can develop your own variations.

You should note that the whole sequence is actually shifted by '`u[-1].w`' set during the position calculation of the first image.
This should be the width of the last image in the current image sequence.
That overall displacement however is junked by the final "`+repage`".
You can use some extra calculation to have it ignore this offset, but it isn't needed in the above.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*When using a image index such as '`u[t]`' all image selectors '`u`', '`v`', and '`s`', all references the same image, according to the '`[index]`' given.
As such it is better to use '`u`' (the first or zeroth image) as a mnemonic of this indexing behaviour (and in case this changes).*

This ability to access attributes of other images, also includes the pixel data of other images.
That means you could position a list of images according to say values found in the first (or last) image in the list, though that 'mapping' image would also be re-positioned.
How useful 'mapped positions' would be is another matter.
It is just another possibility.

### Two Stage Positioning of Images

You can simplify your image processing, by separating them into two steps.
One step can be used to generate, distort, position and add fluff to images, with a final step to merge them all together.
For example, lets create [Polaroid Thumbnails](../transform/#polaroid) from the larger original images in [Photo Store](../img_photos/INDEX.html), processing each of them individually (keeping that aspect separate and simple).
  
      center=0   # Start position of the center of the first image.
                 # This can be ANYTHING, as only relative changes are important.

      for image in ../img_photos/[a-m]*_orig.jpg
      do

        # Add 70 to the previous images relative offset to add to each image
        #
        center=`convert xc: -format "%[fx: $center +70 ]" info:`

        # read image, add fluff, and using centered padding/trim locate the
        # center of the image at the next location (relative to the last).
        #
        convert -size 500x500 "$image" -thumbnail 240x240 \
                -set caption '%t' -bordercolor Lavender -background black \
                -pointsize 12  -density 96x96  +polaroid  -resize 30% \
                -gravity center -background None -extent 100x100 -trim \
                -repage +${center}+0\!    MIFF:-

      done |
        # read pipeline of positioned images, and merge together
        convert -background skyblue   MIFF:-  -layers merge +repage \
                -bordercolor skyblue -border 3x3   overlapped_polaroids.jpg

[![\[IM Output\]](overlapped_polaroids.jpg)](overlapped_polaroids.jpg)

The script above seem complicated but isn't really.
It simply generates each thumbnail image in a loop, while at the same time center pads (using [Extent](../crop/#extent)) and [Trims](../canvas/#trim) each image so that the images 'center' is in a known location on the virtual canvas.
It could actually calculate that postion, though that may require temporary files, so it is better to ensure it is in a well known location, for all images.

The image is then translated (using a relative "`-repage`" operator, see [Canvas Offsets](../basics/#page)), so that each image generated will be exactly 60 pixels to the right of the previous image.
That is, each image center is spaced a fixed distance apart, regardless of the images actual size, which could have changed due to aspect ratios and rotations.

The other major trick with this script is that rather than save each 'layer image' into a temporary file, you can just write the image into a pipeline using the [MIFF:](../files/#miff) file format.
A method known as a [MIFF Image Streaming](../files/#miff_stream).

This works because the "`MIFF:`" file format allows you to simply concatenate multiple images together into a single data stream, while preserving all the images meta-data, such as its virtual canvas offset.

This technique provides a good starting point for many other scripts.
Images can be generated, or modified and the final size and position can be calculated in any way you like.

Another example is the script "`hsl_named_colors`" which takes the list of named colors found in ImageMagick and sorts them into a chart of those colors in HSL colorspace.
You can see its output in [Color Specification](../color_basics/#colors).

Other possibilities include...

-   Use any type of thumbnail (or other [Fluff](../thumbnails/#fluff)), or just simply use a raw small thumbnail directly.
-   Generate images so the first image is centered and the other images are arrange to the left and right under that first image, like a pyramid.
-   Position images into Arcs, Circles and spirals, by placing them at specific X and Y coordinates relative to each other.
    For example: [PhD Circle](http://www.flickr.com/photos/dsevilla/2363002372), [Sunset Flower](http://www.flickr.com/photos/krazydad/4994679), [Fibonacci Spiral](http://www.flickr.com/photos/krazydad/4109739).
-   Position images according to their color.
    For example: [Book Covers](http://www.flickr.com/photos/davepattern/2954305171).
-   Position images by time of day or time submitted.
    For example: [Year of Sunsets](http://www.flickr.com/photos/krazydad/292081922)

Basically you have complete freedom in the positioning of images on the virtual canvas, and can then simply leave IM to sort out the final size of the canvas needed to whole all the images.

### Pins in a Map

Here is a typical layering example, placing coloured pins in a map, at specific locations.

[![\[IM Output\]](push_pin.png)](push_pin.png) To the left is a 'push pin' image.
The end of the pin is at position `+18+41`.

I also have a image of a [Map of Venice](map_venice.jpg), and want to put a pin at various points on the map.
For example 'Accademia' is locate at pixel position, `+160+283`.

To align the push-pin with that position you need to subtract the location of the end of the pin from map position.
This produces a offset of `+142+242` for our 'pin' image.

Here is the result, using layered images
  
      convert map_venice.jpg    -page +142+242 push_pin.png \
              -flatten  map_push_pin.jpg

[![\[IM Output\]](map_push_pin.jpg)](map_push_pin.jpg)

This example was from a IM Forum Discussion, [Layering Images with Convert](../forum_link.cgi?f=1&t=20251).

**Lets automate this further.**

We have a file listing the locations and colors for each of the pins we want to place in the map.
The location name in the file is not used and is just a reference comment on the pixel location listed.
  
[![\[Data File\]](map_venice_pins.txt.gif)](map_venice_pins.txt)

Lets read this text file, to create 'pins' in a loop.
  

      pin_x=18  pin_y=41

      cat map_venice_pins.txt |\
        while read x y color location; do

          [ "X$x" = "X#" ] && continue   # skip comments in data

          x=$(( x - pin_x ))    # convert x,y to pin image offsets
          y=$(( y - pin_y ))

          # convert 'color' to settings for color modulate (hue only)
          # assumes a pure 'red' color for the original push pin
          mod_args=$(
             convert xc:$color -colorspace HSL txt: |
               tr -sc '0-9\012' ' ' |\
                 awk 'NR==1 { depth=$3 }
                      NR==2 { hue=$3;
                              print  "100,100,"  100+200*hue/depth
                            }'; )

          # re-color and position the push pin
          convert push_pin.png -repage +${x}+${y} -modulate $mod_args miff:-

        done |\
          # read pipeline of positioned images, and merge together
          convert  map_venice.jpg  MIFF:-  -flatten  map_venice_pins.jpg

[![\[IM Output\]](map_venice_pins.jpg)](map_venice_pins.jpg)

Note it assumes the original pin color is red ( which has a hue of 0 ) and uses the [Modulate Operator](../color_mods/#modulate) to re-color it to other colors, with the appropriate scaling calculations.
Note that the modulate argument for a no-op hue change is 100, with it cycling over a value of 200 (a sort of pseudo-percentage value).

*FUTURE: perspective distort map, adjust pin size for 'depth' on the map calculate change in pin position due to distortion, and 'pin' it to the distorted map.*

The above used a method known as a [MIFF Image Streaming](../files/#miff_stream), with each image generated individually in a loop, then 'piped' into the 'layering' command to generate the final image.

The alternative method (commonly using in PHP scripts) is to use a 'generated command' technique, that uses a shell script to generate a long "`convert`" command to be run.
The scripts in [Image Warping Animations](../warping/#animations) use this technique.

Both methods avoid the need to generate temporary images.

### Layers of Shadows

Correctly handling semi-transparent shadow effects in a set of overlapping images is actually a lot more difficult than it seems.
Just overlaying photos with shadows will cause the shadows to be applied twice.
That is two overlapping shadows become very dark, where in reality they do not overlay together in quite the same way that the overlaying images do.

The various parts of the image should be simply shadowed or not shadowed.
That is shadows should be applied once only to any part of the image.
You should not get darker areas, unless you have two separate light sources, and that can make things harder still.

Tomas Zathurecky &lt; tom @ ksp.sk &gt; took up the challenge of handling shadow effects in layered images, and developed image accumulator technique, to handle the problem.

Basically we need to add each image to the bottom of stack one at a time.
As we add a new image the shadow of all the previous images needs to darken the new image, before it is added to the stack.
However only the shadow falling on the new image, needs to be added.
Shadows not falling on the new image needs to be ignored until later, when it falls on some other image, or the background (if any).

Here is an example...
  
      convert \
        \( holocaust_tn.gif -frame 10x10+3+3 \
              -background none  -rotate 5 -repage +0+0 \) \
        \
        \( spiral_stairs_tn.gif -frame 10x10+3+3 \
              -background none -rotate -15 -repage -90+60 \) \
        \( -clone 0   -background black -shadow 70x3+4+7 \
           -clone 1   -background black -compose DstATop -layers merge \
           -trim \) \
        \( -clone 2,0 -background none  -compose Over -layers merge \) \
        -delete 0--2 \
        \
        \( chinese_chess_tn.gif -frame 10x10+3+3 \
              -background none -rotate 20 -repage +60+90 \) \
        \( -clone 0   -background black -shadow 70x3+4+7 \
           -clone 1   -background black -compose DstATop -layers merge \
           -trim \) \
        \( -clone 2,0 -background none  -compose Over -layers merge \) \
        -delete 0--2 \
        \
        \( +clone -background black -shadow 70x3+4+7 \) +swap \
        -background none -compose Over -layers merge +repage \
        layers_of_shadows.png

  
[![\[IM Output\]](layers_of_shadows.png)](layers_of_shadows.png)

The above program seems complex, but is actually quite straight forward.

The first image is used to start a accumulating stack of images (image index \#0).

Note we could have actually started with a single transparent pixel ("`-size 1x1 xc:none`"), if you don't want to use that first image to initialize the stack.

Now to add a new image to the bottom of the image stack, we apply the same set of operations, each time...

-   First the thumbnail image is read into memory, and any rotations, relative placements (may be negative), is applied.
    You could also do apply other thumbnailing operations to the image at this point if you want, though for his example that have already been performed.
    The new image forms image index \#1.
-   We now grab the previous stack of images (\#0), generate a shadow with appropriate color, blur, offset, and ambient light percentage.
-   This shadow is overlaid on the new image (\#1) so only the shadow that falls '`ATop`' the new image is kept.
    We also (optionally) apply a [Trim Operation](../crop/#trim) the result to remove any extra space added from the shadowing operation, to form image \#2.
-   Now we simply add the new image (\#2) to the accumulating stack of images (\#0).
-   and delete all the previous working images, except the last.

To add more images we basically just repeat the above block of operations.

After all the images has been added to the stack, it is simply a matter of doing a normal shadowing operation on the accumulated stack of images.
removing any remaining image offsets (which many web browsers hate).

Using [Merge](#merge) I can automatically handle virtual offsets, especially negative ones, allowing to to simply place images anywhere you like relative to the previous image placements.
It also make applying shadows which can generate larger images with negative offsets properly.

Now the above handles multi-layered image shadows properly, but while the shadow is offset, it is actually offset equally for all the images!

What really should happen is that the shadow should become more offset and also more blurry as it falls on images deeper and deeper in the stack.
That is a image at the top should case a very blurry shadow on the background, compared to the bottom-most image.

This is actually harder to do as you not only need to keep a track of the stack of images, you also need to keep a track of how 'fuzzy' the shadow has become as the stack of images becomes larger.
Thus you really need two accumulators.
The image stack (as above), and the shadow accumulation, as we add more images.

For example here is the same set of images but with shadows that get more blurry with depth.
  
      convert xc:none xc:none \
        \
        \( holocaust_tn.gif -frame 10x10+3+3 \
              -background none  -rotate 5 -repage +0+0 \) \
        \( -clone 1   -background black -shadow 70x0+0+0 \
           -clone 2   -background black -compose DstATop -layers merge \
           -clone 0   -background none  -compose Over    -layers merge \) \
        \( -clone 2,1 -background none  -compose Over    -layers merge \
                      -background black -shadow 100x2+4+7 \) \
        -delete 0-2 \
        \
        \( spiral_stairs_tn.gif -frame 10x10+3+3 \
              -background none -rotate -15 -repage -90+60 \) \
        \( -clone 1   -background black -shadow 70x0+0+0 \
           -clone 2   -background black -compose DstATop -layers merge \
           -clone 0   -background none  -compose Over    -layers merge \) \
        \( -clone 2,1 -background none  -compose Over    -layers merge \
                      -background black -shadow 100x2+4+7 \) \
        -delete 0-2 \
        \
        \( chinese_chess_tn.gif -frame 10x10+3+3 \
              -background none -rotate 20 -repage +60+90 \) \
        \( -clone 1   -background black -shadow 70x0+0+0 \
           -clone 2   -background black -compose DstATop -layers merge \
           -clone 0   -background none  -compose Over    -layers merge \) \
        \( -clone 2,1 -background none  -compose Over    -layers merge \
                      -background black -shadow 100x2+4+7 \) \
        -delete 0-2 \
        \
        \( -clone 1 -background black -shadow 70x0+0+0 \
           -clone 0 -background none -compose Over -layers merge \) \
        -delete 0-1 -trim +repage \
        layers_of_deep_shadows.png

  
[![\[IM Output\]](layers_of_deep_shadows.png)](layers_of_deep_shadows.png)

Look carefully at the result.
The offset and blurriness of the shadow is different in different parts of the image.
It is very thin between images in adjacent layers, but very thick when it falls on a image, or even the background much deeper down.

Of course in this example, the shadow offset is probably too large, but the result seems very realistic giving a better sense of depth to the layers.

Note how we split the operation of shadow into two steps.
When applying the accumulated shadow (image index \#1) to the new image (\#2), we only add the ambient light percentage, without any blur, or offset ('`70x0+0+0`' in this case).

The new image is then added to the accumulating stack of images (\#0).

But after adding new images (\#2) shadow directly to the accumulated shadow (\#1), again without blur or offset, only then do we blur and offset ALL the shadows, to form the new accumulated shadow image.

In other words, the accumulated shadow image becomes more and more blurry and offset as the stack gets thicker and thicker.
Only the shadow of deeper images has not accumulated the effect as much.

This program essentually separates the application of the shadow, from the incremental shadow accumulator.
This allows you control things like...

-   Realistic Shadow (as above): 70x0+0+0 and 100x2+4+7
-   Constant Shadow (as basic example): 70x2+4+7 and 100x0+0+0
-   constant blur, but cumulative offset: 70x2+0+0 and 100x0+4+7
-   both constant and progressive offset: 60x0+4+7 and 100x0+1+1
-   cumulative ambient light effect: 80x0+0+0 and and 95x2+4+7

Most of them are probably unrealistic, but may look good in another situations.
Also setting the "`-background`" color before the "`-compose ATOP`" composition will let you define the color of the shadow (actually a colored ambient light).

You can even even use a different color for the shadow that eventually falls on the final background layer (the last "`-background black`" setting), or leave it off entirely to make it look like the images are not above any background at all (that is floating in mid-air).

It is highly versitile.

Tomas Zathurecky went on to develop another method of handling the shadows of layered images, by dealing with a list of layered images as a whole.
Something I would not have considered posible myself.

The advantage of this method is that you can deal with a whole list of images as a whole, rather than having to accumulate one image at a time, and repeating the same block of operations over and over.

First lets again look at the simplier 'contant shadow' problem.
  
      convert \
        \( holocaust_tn.gif -frame 10x10+3+3 \
              -background none  -rotate 5 -repage +0+0 \) \
        \( spiral_stairs_tn.gif -frame 10x10+3+3 \
              -background none -rotate -15 -repage -90+60 \) \
        \( chinese_chess_tn.gif -frame 10x10+3+3 \
              -background none -rotate 20 -repage +60+90 \) \
        \
        -layers trim-bounds \
        \
        \( -clone 0--1 -dispose None -coalesce \
           -background black -shadow 70x2+4+7 \
           xc:none +insert null: +insert +insert xc:none \) \
        -layers trim-bounds -compose Atop -layers composite \
        \
        -fuzz 10% -trim \
        -reverse -background none -compose Over -layers merge +repage \
        coalesced_shadows.png

  
[![\[IM Output\]](coalesced_shadows.png)](coalesced_shadows.png)

The first block of opertors is just generating the list of layered images.
It could be a separate programmed loop, as shown previously.

The the operation starts with a "`-layers trim-bounds`", a [Bounds Trimming](../anim_mods/#trim) operation that expands the virtual canvas of all images so as to contain all the images, and also ensure all offsets are positive.

This is then cloned, [Coalesced](#coalesce) and shadowed to create a separate progressing list of shadows.

Now we can use [Layer Compostion](#layer_composite) to merge the shadows and the original list of images together.
The complication here is that before merging we need to not only add a special '`null:`' marker image to divide the two lists, but also add a special blank image '`xc:none`' so as to offset the shadow list.
That way each shadow image will be overlaid '`ATop`' the next image of the original list.

All that is left is to merge the now correctly shadowed images from bottom to top ([Reverse](../basics/#reverse)) order.

To handle 'deep shadows' requires [Layer Calculations](#layer_calc).
  
      convert \
        \( holocaust_tn.gif -frame 10x10+3+3 \
              -background none  -rotate 5 -repage +0+0 \) \
        \( spiral_stairs_tn.gif -frame 10x10+3+3 \
              -background none -rotate -15 -repage -90+60 \) \
        \( chinese_chess_tn.gif -frame 10x10+3+3 \
              -background none -rotate 20 -repage +60+90 \) \
        \
        \( -clone 0--1 \
           -set page '+%[fx:page.x-4*t]+%[fx:page.y-7*t]' -layers merge \) \
        -layers trim-bounds +delete \
        \
        \( -clone 0--1 \
           -set page '+%[fx:page.x-4*t]+%[fx:page.y-7*t]' \
                -dispose None -coalesce \
           -set page '+%[fx:page.x+4*t]+%[fx:page.y+7*t]' \
                -background black -shadow 70x2+4+7 \
           xc:none +insert null: +insert +insert xc:none \) \
        -layers trim-bounds -compose Atop -layers composite \
        \
        -fuzz 10% -trim \
        -reverse -background none -compose Over -layers merge +repage \
        coalesced_deep_shadows.png

  
[![\[IM Output\]](coalesced_deep_shadows.png)](coalesced_deep_shadows.png)

You can see the same set of blocks that was used previously, but with much more complicated caculations to set the initial [Bounds Trimming](../anim_mods/#trim), and later calculate the offsets needed for the 'progressive shadow list'.

However the shadow currently does not become more blurry with depth.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The above will be a lot simplier using the IMv7 "magick" command, which would allow you to use 'fx calculations' directly the argument to "`-shadow`", that would let you not only calculate a larger offset for the shadow with depth, but also let you mak ethe shadow more blurry with depth.*

### Positioning Distorted Perspective Images

Aligning distorted images can be tricky, and here I will look at aligning such images to match up at a very specific location.
Here I have two images that highlight a specific point on each image.

[![\[IM Output\]](align_blue.png)](align_blue.png) [![\[IM Output\]](align_red.png)](align_red.png)

The second image is 65% semi-transparent, which allow you to see though it when it is composed onto the blue image, so you can see if the marked points align.
The marked control points themselves are at the coordinates `59,26` (blue) and `35,14` (red) respectively.

If you are simply overlaying the two images, you can just subtract the offsets and 'compose' the two image on top of each other, producing a offset of `+24+12`.
  
      convert align_blue.png align_red.png -geometry +24+12 \
              -composite align_composite.png

  
[![\[IM Output\]](align_composite.png)](align_composite.png)

Note that this offset could be negative!
And that is something we will deal with shortly.

This only works as the coordinates are integer pixel coordinates.
If the matching coordinates are sub-pixel locations (as is typically the case in a photo montage), simple composition will not work.
It will also not work well if any sort of distortion is involved (which is also common for real-life images).
And this is the problem we will explore.

When distorting the image, you will want to ensure the two pixels remain aligned.
The best way to do that would be to use the points you want to align as [Distort Control Points](../distorts/#control_points).
This will ensure they are positioned properly.
  
      convert align_blue.png \
              \( align_red.png -alpha set -virtual-pixel transparent \
                 +distort SRT '35.5,14.5  1 75  59.5,26.5' \
              \) -flatten  align_rotate.png

  
[![\[IM Output\]](align_rotate.png)](align_rotate.png)

As distort generates a 'layer image' with a 'canvas offset' you can not simply use [Composite](../compose/#composite) to overlay the images (too low level), instead we need to use a [Flatten](#flatten) operator, so that it will position them using the distort generated offset.

Note how I also added a value of 0.5 to the 'pixel' coordinates.
This is because pixels have area, while mathematical points do not, as such if you want to align the center of a pixel, you need to add 0.5 to the location of the center 'point' within the pixel.
See [Image Coordinates vs Pixel Coordinates](../distorts/#control_coordinates) for more information.

The other problem with the above was that the overlaid image was 'clipped' by the blue background canvas image, just as the [Composite Operator](../compose/#composite) does.
That is to say the 'blue' image provided the 'clipping viewport' for the result during the composition.
To prevent this we use [Layer Merge](#merge) instead which automatically calculates a 'viewport' canvas that is large enough contain hold all the images being composted together.
  
      convert align_blue.png \
              \( align_red.png -alpha set -virtual-pixel transparent \
                 +distort SRT '35.5,14.5  1 75  59.5,26.5' \
              \) -background none -layers merge +repage  align_rotate_merge.png

  
[![\[IM Output\]](align_rotate_merge.png)](align_rotate_merge.png)

As the result of the 'merge' the image will have a 'negative' offset (so as to preserve layer positions of the images).
To display the results I needed to junk that offset as many browsers do not handle negative offsets in images.
I do this using "`+repage`" before saving the final image.
If I was going to do further processing (without displaying the result on the web) I would keep that offset (remove the "`+repage`"), so the image positions remains in their correct and known position for later processing.

Now the same techniques as shown above would also apply if you were doing a more complex distortion such as [Perspective](../distorts/#perspective).
  
      convert align_blue.png \
              \( align_red.png -alpha set -virtual-pixel transparent \
                 +distort Perspective '35.5,14.5  59.5,26.5
                           0,0 32,4    0,%h 14,36    %w,%h 72,53  ' \
              \) -background none -layers merge +repage  align_perspective.png

  
[![\[IM Output\]](align_perspective.png)](align_perspective.png)

The problem with this technique is that you position the perspective distortion using an internal control point.
That is one point in the inside of the image, and 3 points around the edge.
That can make it hard to control the actual perspective shape, as a small movement of any control point can make the 'free corner' move wildly.

This situation can be even worse if you are using a large list of 'registered points' to get a more exact 'least squares fit' to position images.
In that case the point you are interested in be no wehere near one of the control 'registered' points used to distort the image.

The alternative is to simply distort the image the way we need to, then figure out how we need to translate the resulting image to align the points we are interested in.
To make this work we will need to know how the 'point of interest' moved as a result of the distortion.
This is real problem with distorting and positioning images, especially real life images.

For example, here I distort the image using all four corners to produce a specific (suposedally desired) distortion shape, but I will not try to align the control points at this point, just apply the distortion...
  
      convert align_blue.png \
              \( align_red.png -alpha set -virtual-pixel transparent \
                 +distort Perspective '0,0  10,12  0,%h 14,40
                                   %w,0 68,6  %w,%h 63,48 ' \
              \) -background none -layers merge +repage  align_persp_shape.png

  
[![\[IM Output\]](align_persp_shape.png)](align_persp_shape.png)

As you can see while the red image was distorted, the position of the red control point is no where near the blue control point we want to align.
You can not just simply measure these two points as the red point is unlikely to be at a exact pixel position, but will have a sub-pixel offset involved.
We will need to first calculate exactly where the red point is.

To do that we can re-run the above distortion with verbose enabled to get the perspective forward mapping coefficients.
These can then be used to calculate as described in [Perspective Projection Distortion](../distorts/#perspective_projection).
  
      convert align_red.png  -define distort:viewport=1x1  -verbose \
              +distort Perspective '0,0  10,12  0,%h 14,40
                                    %w,0 68,6  %w,%h 63,48 ' null:

  
[![\[IM Text\]](align_persp_verbose.txt.gif)](align_persp_verbose.txt)

All we want is just the calculated coefficients used by the distortion.
As such we don't need the destination image, so we just the output using a "`null:`" image file format.
We also tell the distort that the new image it is generating is only one pixel is size using a [Distort Viewport](../distorts/#distort_viewport).
That way it does the distortion preparation and verbose reporting, but then only distorts a single 'destination' pixel, which is then junked.
This can save a lot of processing time.

Actually if the distortion did not use source image meta-data (needed for the percent escapes '`%w`' and '`%h`') as part of its calculations, we would not even need the source image "`align_red.png`".
In that case we could have used a single pixel "`null:`" image, for the input image too.

We are also not really interested in the virtual pixels, backgrounds, or anything else for this information gathering step, so we don't need to worry about setting those features.

Now we can get the distort information, we need to extract the 8 perspective coefficients, from the 3rd and 4th line of the output.
These can then be used to map the red control point to its new distorted position, and from there subtract it from the blue control point, so as to get the actual amount of translation that is needed, to align the marked red coordinate with the blue coordinate.
  
      bluex=59; bluey=26
      redx=35; redy=14

      convert align_red.png  -verbose \
                 +distort Perspective '0,0  10,12  0,%h 14,40
                                   %w,0 68,6  %w,%h 63,48 ' null: 2>&1 |\
        tr -d "',"  |\
          awk 'BEGIN   { redx='"$redx"'+0.5;   redy='"$redy"+0.5';
                         bluex='"$bluex"'+0.5; bluey='"$bluey"'+0.5; }
               NR == 3 { sx=$1; ry=$2;  tx=$3; rx=$4; }
               NR == 4 { sy=$1; ty=$2;  px=$3; py=$4; }
               END { div =  redx*px + redy*py + 1.0;
                     dx = ( redx*sx + redy*ry + tx ) / div;
                     dy = ( redx*rx + redy*sy + ty ) / div;
                     printf "red point now at %f,%f\n", dx, dy;
                     printf "translate shape by %+f %+f\n", bluex-dx, bluey-dy; }'

  
[![\[IM Text\]](align_persp_coord.txt.gif)](align_persp_coord.txt)

The above used the "`tr`" text filter to remove extra quotes and commas from the output.
It then uses the "`awk`" program to extract the coefficients, and do the floating point mathematics required to 'forward map' the red marker to match the blue marker.

Note that I again added 0.5 to the 'pixel coordinates' of the control points to ensure that the center of the pixel is what is used for the calculations.
See [Image Coordinates vs Pixel Coordinates](../distorts/#control_coordinates).

Now we know the amount of translation needed by the distorted image, we have two ways you add that translation to the distortion.
Either by modifying the coefficients of the perspective projection appropriately (not easy).
Or we could just add the translation amounts to each of the destination coordinates of the original (very easy).

Here is the result of the latter (add translations to destination coordinates)...
  
      convert align_blue.png \
              \( align_red.png -alpha set -virtual-pixel transparent \
                 +distort Perspective '0,0   31.408223,15.334305
                                       0,%h  35.408223,43.334305
                                       %w,0  89.408223, 9.334305
                                       %w,%h 84.408223,51.334305 ' \
              \) -background none -layers merge +repage  align_persp_move.png

  
[![\[IM Output\]](align_persp_move.png)](align_persp_move.png)
  
To the right I have cropped and scaled the result around the control points to show they are perfectly aligned!
  
      convert align_persp_shape.png -crop 19x19+50+17 +repage \
              -scale 500%   align_persp_shape_mag.png

  
[![\[IM Output\]](align_persp_shape_mag.png)](align_persp_shape_mag.png)

As you can see we have a perfect alignment of the two pixels, without any sub-pixel overflow to any one side.
Even the smallest miss-alignment would show as an asymmetrical coloring on either side of the central pixel.

This scaling even shows a slight asymmetrical difference between left and right sides of the red cross due to the perspective distortion.
That is how accurate this pixel level view test is.

A similar but simpler problem is looked at in [Text Positioning using Distort](../annotating/#distort).
  

------------------------------------------------------------------------

## Evaluate-Sequence - Direct Mutli-Image Merging Methods

The "**`-evaluate-sequence`**" methods, are designed to merge multiple images of the **same size** together in very specific ways.

In some ways it is a blend of the [Evaluate and Function Operators](../transform/#evaluate) combined with multi-image [Composition](#composite) techniques we have seen above.
Many of the methods provided can even be performed using normal multi-image layering composition techniques, but not all.

The operator uses the same methods as "`-evaluate`" so you can get a list of them using "`-list Evaluate`".
Though some of these (such as '`Mean`' and '`Medium`') are really only useful when used with this operator.

### Mean (Average) of multiple images

Essentially both the older "`-average`" and the newer "`-evaluate-sequence mean`" will create a average of all the images provided.

For example, here is an average of the rose image using all its [Flipped and Flopped](../warping/#flip) versions.
  
      convert rose: -flip rose: \( -clone 0--1 -flop \) \
              -evaluate-sequence mean  average.png

  
[![\[IM Output\]](average.png)](average.png)

Averaging hundreds of images of the same fixed scene, can be used to remove most transient effects, such moving people, making them less important.
However areas that get lots of transient effects may have a 'ghostly blur' left behind that may be very hard to remove.

As video sequences are notoriously noisy when you look at the individual frames, you can average a number of consecutive, but unchanging, frames together to produce much better cleaner and sharper result.

Matt Leigh, of the University of Arizona, reports that he has used this technique to improve the resolution of microscope images.
He takes multiple images of the same 'target' then averages them all together to increase the signal/noise ratio of the results.
He suggests others may also find it useful for this purpose.

An alternative for averaging two images together is to use a "`composite -blend 50%`" image operation, which will work with two different sized images.
See the example of [Blend Two Images Together](../compose/#blend) for more detail.

The [IM Discussion Forum](../forum_link.cgi?f=1) had a discussion on [Averaging a sequence 10 frames at a time](../forum_link.cgi?f=1&t=19945), so as to average thousands of images, without filling up the computers memory (making it very slow).
Related to this, and containing relevent maths is the discussion [Don't load all images at once](../forum_link.cgi?f=1&t=19855).

Another alternative to using '`mean`' is to use the newer [Poly Operator](#poly), which can individually weight each image.

### Max/Min Value of multiple images

The '**`Max`**' and '**`Min`**' methods will get the maximum (lighter) values and minimum (darker) values from a sequence of images.

Again they are basically equivalent to using a [Lighten and Darken Composition Methods](../compose/#lighten), but with multiple images.
With the right selection of background canvas color, you could use [Flatten Operator](#flatten) with the equivelent compose method.

WARNING: This is not a selection of pixels (by intensity), but a selection of values.
That means the output image could result in the individule red, green and blue values from different images, resulting in a new color not found in any of the input images.
See the [Lighten Compose Method](../compose/#lighten) for more details of this.

### Median Pixel by Intensity

The "`-evaluate-sequence Median`" will look for the pixel which has an intensity of the middle pixel from all the images that are given.

That is for each position it collects and sorts the pixel intensity from each of the images.
Then it will pick the pixel that falls in the middle of the sequence.

It can also be used as a alternative to simply averaging the pixels of a collection of images.

This could be used for example by combining an image with two upper and lower 'limiting' images.
As the pixel will be the middle intensity you will either get the pixel from the original image, or a pixel from the 'limiting' images.
In other words you can use this to 'clip' the intensity of the original image.
Strange but true.

For an even number of images, the pixel on the brighter side of the middle will be selected.
As such with only two images, this operator will be equivalent to a pixel-wise "lighten by intensity".

The key point is that each pixel will come completely from one image, and sorted by intensity.
You will never get a mix of values, producing a color mixed from different images.
The exact color of each pixel will come completely from one image.

### Add Multiple Images

The '**`Add`**' method is will of course simply add all the images together.
  
      convert ... -evaluate-sequence add ...

Which is a faster (more direct) version of using [Flatten](#flatten) to [Plus Compose](../compose/#plus) all the images together...
  
      convert ... -background black -compose plus -layers flatten ...

Be warned that adding images in this way can very easilly overflow the Quantum Range of the image, and as such it may get 'clipped', unless you use a [HDRI version of IM](../basics/#hdri).
This is why an [Average, or Mean](#eval-seq_mean) is generally used instead, as this will divide all images equally to ensure the resulting image is not clipped.
Another alturnative is to use the newer [Poly Operator](#poly), which can individually weight each image.

### Subtract Multiple Images

The '**`Subtract`**' method subtracts each image from the first.
Or at least that is what it should do.
Internally it has arguments swapped and it is subtracting the previous results from the next image.
Arrggggg!

However by using a quirk of the [Linear Burn Compose Method](../compose/#linearburn) you can subtract the second and later images from the first.
Basically by [Negating](../color_mods/#negate) all but the first image, and setting a '`white`' (negated zero) as a the starting background color you can then use [Flatten](../layering/#flatten) to subtract all the images from the first.
  
      convert  ...  \
             -negate \( -clone 0 -negate \) -swap 0 +delete \
             -compose LinearBurn -background white -flatten \
             ...

### Multiple/Divide Multiple Images

'**Multiply**' and '**Divide**' are accepted as methods by "`-evaluate-sequence`" but they generate unexpected and odd results, as they are using the actual color value of the images rather than the normalised color value, just as "`-evaluate`" does.
As a result the scale of the multiply and divide is too large.

This could be classed as a bug.

In the meantime, you are better using the equivelent 'flatten' method for Multiply, which does work as expected.
  
      convert ... -background white -compose multiply -layers flatten ...

## Poly - Merge Multiple Images Using a Polynomial

Closely related to "`-evaluate-sequence and specifically to the 'mean`' method (image averaging), is the "`-poly`" operator (added IM v6.8.0-5).

This operator is given a list of two numbers for each image in memory, one to provide a multiplicative weight for each image, but also a power-of exponent to each image.
This lets you merge a list of images as if each image was the variable input to a polynomial equation.
The color values from each image is treated as if they were a normalized 0 to 1 value.

With each pair of values the image color (normalized) is first powered by the second 'power-of' exponent, then it is weighted (multiplied) by the first number.

If the exponent is '`1`' then the value is just multiplied by the given weighting.
However if the exponent is '`0`' the weight becomes the final value, producing a normalized color constant addition (value from 0.0 to 1.0).

A single pixel image can be provided in the current image sequence, and can be used to add a specific color, with a different normalized color value for each channel (using a weight and exponent = 1.0).
Or you can provide a "`NULL:`' image (or any other junk image), and use an exponent of 0.0.
This will will only add the given weighting factor as constant.

The final image is generated from the first image (and its size and other meta-data), just as it is with [FX DIY Operator](../transforms/#fx).

For example...
  
      convert rose: granite: null: -poly '1,1 2,1 -1.0,0' poly_rose.png

  
[![\[IM Output\]](poly_rose.png)](poly_rose.png)

This takes a '`rose:`' (unmodified using a weight of 1 and power-of 1), adds to this twice the color values from the '`granite:`' image (weight=2), and finally subtracts a value of 1 using a '`null:`' image, using an exponent of 0 (ignore image input) and a weighting value of -1.0.

The resulting image is equivalent to...

`  rose + 2.0*granite - 1.0 `

or

`  rose + 2.0*(granite-0.5) `

In other words the rose image is given a noisy granite texture overlay (with a 50% grey bias).
This is in fact exactly like a very strong [Hardlight](../compose/#hardlight) lighting effect but with very explicit weighting of the granite overlay.

The key difference to this over other multi-image operations is the ability to weight each image individually, but perform all calculations in a single image processing operation without the need for extra intermediate images.
This avoids and quantum rounding, clipping or other effects on the final results, in a non-[HDRI](../basics/#hdri) version of ImagMagick.
(See [Quantum Effects](#../basics/#quantium_effects)).
It can for example be used to perform a weighted average of large numbers of images, such as averaging smaller groups of images, then averaging those groups together.
  

------------------------------------------------------------------------

Created: 3 January 2004  
 Updated: 19 April 2012  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/layers/`
