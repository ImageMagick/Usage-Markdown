# Warping Images

**Index**  

 * [![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
   * [![](../img_www/granitesm_right.gif) Simple Distortions](#simple)
     * [Flipping and Mirroring Images](#flip)
     * [Transpose and Transverse, Diagonally](#transpose)
     * [Rectangular Rotates](#rect_rotates)
     * [Rolling Images](#roll) (like a bad TV)
     * [Simple Rearrangements Summary](#simple_summary)
   * [![](../img_www/granitesm_right.gif) Rotate and Shearing](#rot_n_shear)
     * [Rotating Images](#rotate) (Simple Image Rotations)
       * [Rotating a Thin Line](#rotate_line) (Rotation Blurring)
     * [Shearing Images](#shear) (Linear Displacement)
       * [Isometric Cube using Shears](#sheared_cube)
     * [Waving Images](#wave) (Sine Wave Displacement)
   * [![](../img_www/granitesm_right.gif) Circular Warping](#circular)
     * [Imploding Images](#implode)
     * [Exploding Images](#explode)
     * [Swirling Image Whirlpools](#swirl)
   * [![](../img_www/granitesm_right.gif) Animations](#animations) (fun examples)

In this section we will look at general and simpler image warping and distortion operators that are provided by ImageMagick.
This is as a way of wetting your appetite for the more advanced and complex distortions which we will look at in later sections.

------------------------------------------------------------------------

## Simple Distortions

Simple distortions Operators just rearrange the pixels in the image.
The number of pixels and even the size of the image remains the same.
The key feature is that the image does not loose any information, it is just rearranged, and could very easily be returned to normal exactly as if no processed has been done.

Basically it just rearranges the pixels, without destroying, overwriting, copying, or color merging or modifying the contents of the original image.

[![\[IM Output\]](koala.gif)](koala.gif)

### Flipping, and Mirroring

For these examples lets use this cute looking koala image...
  
The simplest image distortion is to rearrange the pixels in the image so as to "[`-flip`](../option_link.cgi?flip)" it upside-down.
  
      convert koala.gif  -flip  flip.gif

  
[![\[IM Output\]](flip.gif)](flip.gif)
  
Or by using "[`-flop`](../option_link.cgi?flop)" you can generate a mirror image.
  
      convert koala.gif  -flop  flop.gif

  
[![\[IM Output\]](flop.gif)](flop.gif)
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> Before IM v6.6.6-5 both the "`-flip`" and the "`-flop`" operators did not modify the virtual canvas offset of the image, relative to a larger virtual canvas that may have been present

### Transpose and Transverse, Diagonally

The "[`-transpose`](../option_link.cgi?transpose)" and "[`-transverse`](../option_link.cgi?transverse)" image operations produce diagonal mirrors of the image.
  
The "[`-transpose`](../option_link.cgi?transpose)" mirrors the image along the image top-left to bottom-right diagonal.
  
      convert koala.gif  -transpose  transpose.gif

  
[![\[IM Output\]](transpose.gif)](transpose.gif)
  
While "[`-transverse`](../option_link.cgi?transverse)" mirrors the image along the image bottom-left to top-right diagonal.
  
      convert koala.gif  -transverse  transverse.gif

  
[![\[IM Output\]](transverse.gif)](transverse.gif)
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> Before IM v6.6.6-5 both the "`-transpose`" and the "`-transverse`" operators did not modify the virtual canvas offset of the image, relative to a larger virtual canvas that may have been present

### Rectangular Rotates

All four types of operations shown above, will essentially produce a mirror image of the original.
The "[`-rotate`](../option_link.cgi?rotate)" operator provides the other non-mirrored versions of the image, including the original image itself.
  
      convert koala.gif  -rotate   0  rotate_0.gif
      convert koala.gif  -rotate  90  rotate_90.gif
      convert koala.gif  -rotate 180  rotate_180.gif
      convert koala.gif  -rotate -90  rotate-90.gif
      convert koala.gif  -rotate 360  rotate_360.gif

[![\[IM Output\]](rotate_0.gif)](rotate_0.gif) [![\[IM Output\]](rotate_90.gif)](rotate_90.gif) [![\[IM Output\]](rotate_180.gif)](rotate_180.gif) [![\[IM Output\]](rotate-90.gif)](rotate-90.gif) [![\[IM Output\]](rotate_360.gif)](rotate_360.gif)

Note that "[`-rotate`](../option_link.cgi?rotate)" is a simple distort only if you use a rotation angle of a multiple of 90 degrees.
Any other angle will introduce other more complex pixel level distortions into the image.
See [Rotate](#rotate) below.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> You may notice that a positive angle of rotation is clock-wise, which seems to be logically incorrect.
> Internally however, it is mathematically correct and is caused by use a of negated Y-axis.
> That is the Y-axis goes from 0 at the top and positive downward.
> Because of this the coordinate system in reversed, and thus the angle of rotation is also reversed mathematically.
>
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> Digital photos can also be rotated to match the recorded [Camera Orientation](../photos/#orient) by using the "[`-auto-orient`](../option_link.cgi?auto-orient)" operator.
> This was added in IM v6.2.7-8.

### Rolling Images like a bad TV

  
You can also "[`-roll`](../option_link.cgi?roll)" an image horizontally (like a TV that is out of sync).
The amount of the roll (displacement of the image) is given in pixels.
  
      convert koala.gif  -roll +0+20  roll_horiz.gif

  
[![\[IM Output\]](roll_horiz.gif)](roll_horiz.gif)
  
Of course you can also roll the image sideways...
  
      convert koala.gif  -roll +30+0  roll_vert.gif

  
[![\[IM Output\]](roll_vert.gif)](roll_vert.gif)
  
Or by using a negative number of pixels, you can roll it in the opposite direction.
  
      convert koala.gif  -roll +0-20  roll-horiz.gif

  
[![\[IM Output\]](roll-horiz.gif)](roll-horiz.gif)

Rolls are particularly important for [Tiled Images](../canvas/#tile) as it repositions the tile origin, without destroying the images 'tilability'.
In fact that is exactly what the "[`-tile-offset`](../option_link.cgi?tile-offset)" setting defines, how much roll to apply to a tiling image as it is read in by the "[`-tile`](../option_link.cgi?tile)" option.
### Simple Rearrangements Summary

The most important aspect of all these operators is that you can add them all together in many different ways such that the result will be *exactly* as if no operation was performed at all.
  
      convert koala.gif -roll +25+0 -rotate 90  -flop \
              -roll +0-25  -flip  -rotate 90    original.gif

  
[![\[IM Output\]](original.gif)](original.gif)

------------------------------------------------------------------------

## Rotating and Shearing

While the [Simple Distortion Operators](#simple) (above) preserve the images size and color, the next set does not.
The results of these operators do not fit in the original size, or even the original raster grid of the image.
### Rotating Images -- Simple Image Rotation

As you saw above the "[`-rotate`](../option_link.cgi?rotate)" operator can perform simple, image preserving distorts, when you rotate image in units of 90 degrees.
  
With other angles however, the rotated image will not fit nicely into a rectangular image.
Consequently to ensure that no image data is lost, the size of the final image is enlarged just enough to accommodate the rotated image.
  
      convert koala.gif -rotate 30 rotate.jpg

  
[![\[IM Output\]](rotate.jpg)](rotate.jpg)

Note that the direction of rotate is clock-wise.
This may seem illogical mathematically, until you realize that the image coordinate system is relative to the top-left of the image instead of the mathematical norm of the bottom-left.
The result is the angle of rotation is the opposite of what you may logically expect.
This is important to keep in mind when dealing with any form of image rotation, compared to a mathematical rotation.
  
The extra space added by ImageMagick is colored with the current "[`-background`](../option_link.cgi?background)" color setting.
Allowing you to specify the color to fill into the corners.
  
      convert koala.gif -background lightblue -rotate 30 rotate_color.png

  
[![\[IM Output\]](rotate_color.png)](rotate_color.png)
  
Of course if you want to fill with the transparent color, you will need to ensure the image can handle transparency (by enabling adding an [Alpha Channel](../basics/#alpha)), and is saved to an image format that can handle transparency.
  
      convert koala.gif -alpha set -background none -rotate 30 rotate_trans.png

  
[![\[IM Output\]](rotate_trans.png)](rotate_trans.png)

If the extra space comes out black, then your output image output format does not allow the use of an alpha channel, (most likely the JPEG format), so the transparency defaults to black.
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> Before version 6.1.2, "[`-rotate`](../option_link.cgi?rotate)" did not handle transparency correctly, producing stripes of black and transparent in the corners of the rotated image.
> The workaround for this problem was rather complex, involving rotating the alpha channel separately to the colors.

But what if you don't what that extra space, wanting to preserve the images original size? Well you can use a centered "[`-crop`](../option_link.cgi?crop)" to return the image to its original size.

If you don't know what the original size was, you can use an alpha composition trick (see the '`Src`' compose method) to restore the image back to its original size.
  
        convert koala.gif -alpha set \( +clone -background none -rotate 30 \) \
                -gravity center  -compose Src -composite   rotate_resized.png

  
[![\[IM Output\]](rotate_resized.png)](rotate_resized.png)

The "[`-rotate`](../option_link.cgi?rotate)" operator also understands two extra flags.
If a '`>`' symbol is added to the rotate argument (before or after the number), then the image will only be rotated if the image is wider than it is taller.
That is a '`90>`' will only rotate 'landscape' (wide) style images into 'portrait' (tall) style images, so that all th images are 'portrait' style.

The other flag '`<`' does the opposite, only rotate images that are taller than it is wide.
For example '`90<`' will make sure all images are 'landscape'.

Another use of this flag is to rotate 'portrait' and 'landscape' images by different amounts.
That is you can just give two different "[`-rotate`](../option_link.cgi?rotate)" operations such that you angle 'portrait' one direction, and angle 'landscape' another direction.

Digital photos can also be rotated to match the [Camera Orientation](../photos/#orient) (based on the images EXIF meta-data) by using the "[`-auto-orient`](../option_link.cgi?auto-orient)" operator.
However remember saving back to JPEG format may not be a good idea.
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> The [Rotate Operator](#rotate) is actually implemented using [Simple Distorts](#simple) followed by three [Image Shears](#shear), a technique known as 'Rotate by Shear' (RBS) and first publish in research papers by Alan Paeth.

**Now for the bad news...** Because non-simple rotates are implemented as a sequence of [Shears](#shear) there are some subsequent effects that result from.
First areas added into the image corners are just directly filled in using the "[`-background`](../option_link.cgi?background)" color.
You can not control this using [Virtual Pixel Setting](../misc/#virtual-pixel), as you normally would with more complex distortion techniques.
(See the [SRT Distortion Method](../distorts/#srt))
  
#### Rotating a Thin Line - rotation color blurring

  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
>  Update: As of IMv6.7.3-4 the [Rotate Operator](#rotate) is now using [Distort Operator](../distort/#distort) and [Scale-Rotate-Translate (SRT) Distortion](../distorts/#srt).
  
As such the following examples no longer holds true.
  
However the library function that did rotates as 'shears' is still available and will hopefully be accessable using the [Shear Operator](#shear).
  
Also you can not control the mixing of colors during the [Image Rotation](#rotate) using the [Interpolation Setting](../misc/#interpolation).
Which means you can not preserve the original colors of the image.
  
For example here I rotated a simple vertical line of pixels by 17 degrees, which I then scaled so as to show the effect of the individual pixels in the resulting image.
  
      convert -size 10x30 xc: -draw 'line 5,0 5,30' \
              -background white   -rotate 17  -scale 500%  rotate_magnify.gif

  
[![\[IM Output\]](rotate_magnify.gif)](rotate_magnify.gif)

Note how the line seems to phase in and out in the rotated image, as it crosses pixel boundaries.
Not only that, but as rotate is implement using multiple shears (see note above), the line only phased in sharply every second pixel column.
The the result is a line that is not only more blurry than it needs to be, but has a gross 'beat' effect.

This 'rotation blur' is especially noticeable when you rotate small text and labels, either attached to or part of a photo, by very small angles.
Such lines contain lots of fine detail that 'disappears' in a regular and highly notice wave of blurring across the image.
  
The only direct solution to this problem is to use a [Pixel Mapping](../distorts/#mapping) technique, such as used by the [Scale-Rotate-Translate (SRT) Distortion](../distorts/#srt).
  
      convert -size 10x30 xc: -draw 'line 5,0 5,30' \
              -virtual-pixel white  +distort SRT 17 \
              -scale 500% rotate_SRT_magnify.gif

  
There are many other controls provided by the [General Distort Operator](../distorts/#distort) for things like filter control, point interpolation, output image size, and controls for [Image Layering](../layers/), that the older [Rotate Operator](#rotate), does not provide.
  
[![\[IM Output\]](rotate_SRT_magnify.gif)](rotate_SRT_magnify.gif)

An alternative method for generating an improved rotation result, which you can use when you don't have direct access to the rotation operator (such as in when using the [Polaroid Transform](../transform/#polaroid)), is to use the [Super Sampling](../distorts/#super_sample) technique.

Basically we apply the operation to an image that is at least twice (or more) the size of the final image size wanted.
After rotating the image, the image is resized down to its final size so as to produce a very sharp lines, edges, and much cleaner looking fonts.
See [Polaroid Transform](../transform/#polaroid) for an example of this.

The distort operator also provides an [Output Scaling](../distorts/#distort_scale) expert setting to allow you to generate a enlarged result from the distortion, to let you generate a [Super Sampled](../distorts/#super_sample) image for vastly improved results.

For a more deeper understanding of the various image rotation algorithms, how they work, and the issues involved see [Leptonica Rotation](http://www.leptonica.com/rotation.html).
And the examples used in [General Distortion Techniques](../distorts/#summary).

### Shearing Images -- Linear displacement

The "[`-shear`](../option_link.cgi?shear)" operator takes each row (or column) of pixels and slides them along so that each row (or column) is displaced by the same amount relative to the neighboring row (or column).
Its two arguments are given in terms of angles.

Just as with "[`-rotate`](../option_link.cgi?rotate)" the operation increases the size of the resulting image so as not to loose any information.

However shear is more complex in that it is really a double operation.
  
      convert koala.gif -background Blue  -shear 20      shear_rot.gif
      convert koala.gif -background Blue  -shear 20x0    shear_x.gif
      convert koala.gif -background Blue  -shear 0x50    shear_y.gif
      convert koala.gif -background Blue  -shear 20x50   shear_xy.gif
      convert koala.gif -background Blue  -shear 20x0  -shear 0x50   shear_xy2.gif
      convert koala.gif -background Blue  -shear 0x50  -shear 20x0   shear_yx.gif

[![\[IM Output\]](shear_rot.gif)](shear_rot.gif) [![\[IM Output\]](shear_x.gif)](shear_x.gif) [![\[IM Output\]](shear_y.gif)](shear_y.gif) [![\[IM Output\]](shear_xy.gif)](shear_xy.gif) [![\[IM Output\]](shear_xy2.gif)](shear_xy2.gif) [![\[IM Output\]](shear_yx.gif)](shear_yx.gif)

If you look at the results you will see that a full X-Y "[`-shear`](../option_link.cgi?shear)" (fourth image) is actually equivalent to the doing the the X shear first, followed by the Y shear (with an appropriate image trimming), as showin in the fifth or second last image).

Note that the ordering of the shears produce different results.

If only one number is provided (without any '`x`' in the argument, as in the first image) then "[`-shear`](../option_link.cgi?shear)" will apply it in both the X and Y directions as a sort of poor mans rotate.
  
The "[`-background`](../option_link.cgi?background)" color setting is of course used as the color for the extra space added.
  
      convert koala.gif  -background none  -shear 30  shear_trans.png

  
[![\[IM Output\]](shear_trans.png)](shear_trans.png)
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> Before IM version 6.1.2 "[`-shear`](../option_link.cgi?shear)" did not handle transparency.
> The workaround for for this problem was rather complex, involving shearing the alpha channel separately to the colors.

Note that using a "[`-shear`](../option_link.cgi?shear)" in this way is not a correct method for rotating an image.

To actually use shear to rotate an image properly, you would need to perform multiple shearing operations in the form of "`-shear {X}x{Y} -shear {X}x0 -crop ...`", however working out the proper values for the '`{X}`', '`{Y}`' and final trim requires some trigonometry.
The built-in "[Rotate Operator](#rotate)" (see above) is actually implemented in this way.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> Note that shearing in the X direction will not affect an images height, while shearing the the Y direction will not effect the images width.
> The result is that the area covered by some object within the image will not change (only the surrounding container holding the image).
>  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> The [Shear Operator](#shear) is implemented as a direct 'warping' (distorting pixels in individual rows and columns only) of the source image.
> As a consequence it does not use the [Interpolation Setting](../misc/#interpolate) or the the [Virtual Pixel Setting](../misc/#virtual-pixel).
>  
> As a result the areas added to the image is only filled by the current "[`-background`](../option_link.cgi?background)" color, and there is no method provided to preserve the original colors of the image.

For a alternative method that allows the use of image filters, interpolation, and virtual pixels see [Affine Distortion](../distorts/#affine).
For information on using Affine Matrices to implement shears, see [Affine Shearing](../distorts/affine/#affine_shear).
Neither method however allow you to specify the shears using angles arguments.

#### Isometric Cube using Shears

While shears aren't the nicest or simplest of operators to use, that does not mean you can't do fancy things with them.
The following is an example of using "[`-shear`](../option_link.cgi?shear)" to create a isometric cube.
  
      # Create some square images for the cube
      convert logo: -resize 256x256^ -gravity center -extent 256x256 top.jpg
      convert ../img_photos/pagoda_sm.jpg           -resize 256x256 left.jpg
      convert ../img_photos/mandrill_orig.png       -resize 256x256 right.jpg

      # top image shear.
      convert top.jpg -resize  260x301! -alpha set -background none \
              -shear 0x30 -rotate -60 -gravity center -crop 520x301+0+0 \
              top_shear.png

      # left image shear
      convert left.jpg  -resize  260x301! -alpha set -background none \
              -shear 0x30  left_shear.png

      # right image shear
      convert right.jpg  -resize  260x301! -alpha set -background none \
              -shear 0x-30  right_shear.png

      # combine them.
      convert left_shear.png right_shear.png +append \
              \( top_shear.png -repage +0-149 \) \
              -background none -layers merge +repage \
              -resize 30%  isometric_shears.png

      # cleanup
      rm -f top.jpg left.jpg right.jpg
      rm -f top_shear.png left_shear.png right_shear.png

  
[![\[IM Output\]](isometric_shears.png)](isometric_shears.png)

The above was developed from a simular [Windows Batch Example](../windows/#cube) by Wolfgang Hugemann &lt;ImageMagick@Hugemann.de&gt; in his [Using IM under Windows](../windows/) contribution to IM Examples.

Note that the above images are NOT correctly joined together.
They should use [Plus Alpha Composition](../compose/#plus), but are using over instead.
For more information see [Aligning Two Masked Images](../masking/#aligning).
As a result you can have problems aligning the three images correctly, producing gaps or image overlaps.

As the positioning is restricted to integer positioning this problem can be especially bad.
Using a much larger size with easier to manage coordinates, and a little fudging of the maths, can help in this case.
After the images have been merged together, resizing the result down to its final size will sharpen and clean up any slight mis-alignments along the joins.

Another simular example but using [Affine Distorts](../distorts/#affine), and using correct alpha composition, is [3d Cubes, using Affine Layering](../distorts/#cube3d).
A method that greatly simplifies the image processing needed to generate cubes like the above.

### Waving Images - Sine Wave Displacement

  
The "[`-wave`](../option_link.cgi?wave)" operator is like "[`-shear`](../option_link.cgi?shear)" in that it adds a 'linear displacement' to images.
However this operator will only displace columns of pixels vertically according to a sine wave function.
  
There are two arguments to the "[`-wave`](../option_link.cgi?wave)" operator.
The first is the maximum height or *amplitude* the pixels will be displace either up or down, while the second is the *wavelength* of the sine function in pixels.
  
      convert koala.gif -background Blue  -wave 10x64  wave.jpg

  
[![\[IM Output\]](wave.jpg)](wave.jpg)
  
Note that because pixels can be displaced up to the given *amplitude*, that much extra space will always be added to both the top and bottom of the image, even if that space is not actually needed.
  
For example by adjusting the arguments so that the *wavelength* is double the width of the image, you can make the image into a arc.
  
      convert koala.gif -background Blue  -wave 20x150  arched.jpg

  
[![\[IM Output\]](arched.jpg)](arched.jpg)
  
In this sort of case the unused space can be removed using either a "[`-chop`](../option_link.cgi?chop)", "[`-shave`](../option_link.cgi?shave)", or possibly even a "[`-trim`](../option_link.cgi?trim)" operation.
  
Lets clean up the previous example by using a negative amplitude to flip the arc over, and use "[`-chop`](../option_link.cgi?chop)" to remove the unused space the "[`-wave`](../option_link.cgi?wave)" operator added.
  
      convert koala.gif -background Blue  -wave -20x150  \
              -gravity South -chop 0x20 arched_2.jpg

  
[![\[IM Output\]](arched_2.jpg)](arched_2.jpg)
  
Of course the "[`-background`](../option_link.cgi?background)" color setting can be used to define the extra space added to the image.
  
      convert koala.gif -alpha set -background none  -wave 10x75  wave_trans.png

  
[![\[IM Output\]](wave_trans.png)](wave_trans.png)
  
As you can see from the above examples "[`-wave`](../option_link.cgi?wave)" only applies in the vertical or 'Y' direction.
If you want to add a wave in the X direction, you'll need to rotate the image before and after you apply the wave.
  
      convert koala.gif  -rotate -90 -background Blue  -wave -10x75 \
                         -rotate +90  wave_y.jpg

  
[![\[IM Output\]](wave_y.jpg)](wave_y.jpg)

The technique can be used to add a wave pattern or vibration to an image at any angle.
Examples of this is given in the [Vibrato Font](../fonts/#vibrato) and in the [Smoking Font](../fonts/#smoking).

One other limitation with "[`-wave`](../option_link.cgi?wave)", is that the wave only starts at zero.
That is the left most column is not displaced, while the next few rows are displaced downward (positive X direction), unless you give a negative *amplitude* for an initial vertical offset.
  
Basically the "[`-wave`](../option_link.cgi?wave)" operator does not (at this time) allow you to specify an offset for the start of the sine function.
This can be rectified however by adding, then removing, an image offset using "[`-splice`](../option_link.cgi?splice)".
  
      convert koala.gif  -splice 19x0+0+0 -background Blue  -wave 10x75 \
                         -chop   19x0+0+0     wave_offset.jpg

  
[![\[IM Output\]](wave_offset.jpg)](wave_offset.jpg)

While "[`-wave`](../option_link.cgi?wave)" will not make use of the current [Virtual Pixel Setting](../misc/#virtual-pixel) to define the color of the added areas, it will look at the current [Interpolation Setting](..misc/#interpolation) to map the colors from the source to the image generated.
This means wave will tend to blur pixels slightly in vertical bands across the image.

------------------------------------------------------------------------

## Circular Distortions

So far the image distortions have been rather mild, with very little stretching, expanding or compressing of the image data.
That is the data remains pretty well unchanged.

These next few image operators can result in a image that is so distorted, the original image can not be determined.
The colors are twisted into a blurry mess.

It also happens that they limit the distorting effects to a circular area with little to no distortion of the original image at the edge of the image rectangle.
That means, you can use these operators on a smaller area using the [Region Operator](../masking/#region), and the result will still blend into the original image without it looking like it was: cut out, warped and pasted back into place.

That is they the operators are known as a 'local' distortion, as they could be used to warp smaller areas of an image.

### Imploding Images

  
The "[`-implode`](../option_link.cgi?implode)" operator warps the image so as to pull all the pixels toward the center.
Its sort of like sticking a vacuum, or 'black hole' in the center of the image and sucking the pixels toward it.
  
Caution however is advised to only use very small values, to start with, and slowly increase those values until you get the desired result.
Most novice users tend to use too large a value and get disappointed by the result.
  
For example this is a typical image implosion...
  
      convert koala.gif -implode .6 implode.gif

  
[![\[IM Output\]](implode.gif)](implode.gif)
  
Using increasingly larger values will essentially suck all the pixels in the circle, into oblivion.
  
      convert koala.gif -implode 5 implode_big.gif

  
[![\[IM Output\]](implode_big.gif)](implode_big.gif)

However be warned that using any "[`-implode`](../option_link.cgi?implode)" value larger than '`1.0`' is also effected by the [Virtual Pixel Setting](../misc/#virtual-pixel), as the algorithm starts to make color references beyond the boundaries of actual image itself.
As the default the "[`-virtual-pixel`](../option_link.cgi?virtual-pixel)" setting is 'edge', the edge color or surrounding frame on an image can have a major effect on the result.

For example these two images are the same except one had white border added to it.
this basically shows the area which is using colors looked up from beyond the bounds of the image proper.
The area normally defined by the "[`-virtual-pixel`](../option_link.cgi?virtual-pixel)" setting.
  
      convert rose: -gravity center -crop 46x46+0+0 +repage \
                                                  -implode 3   implode_rose.gif
      convert rose: -gravity center -crop 44x44+0+0 +repage \
                    -bordercolor white -border 1  -implode 3   implode_rose_2.gif

  
[![\[IM Output\]](implode_rose.gif)](implode_rose.gif) [![\[IM Output\]](implode_rose_2.gif)](implode_rose_2.gif)

Using different [Virtual Pixel](../misc/#virtual-pixel) settings such as '`Background`' will produce the same effect as adding "[`-border`](../option_link.cgi?border)", but without enlarging the image.

Other [Virtual Pixel](../misc/#virtual-pixel) settings can produce much more interesting effects in the central imploded region.
For example using a '`Tile`' setting can add highly distorted copies of the image.

For example here I implode simple box image using this setting...
  
      convert -size 94x94 xc:red -bordercolor white -border 3 \
              -virtual-pixel tile     -implode 4   implode_tiled_box.gif

  
[![\[IM Output\]](implode_tiled_box.gif)](implode_tiled_box.gif)

More "[`-virtual-pixel`](../option_link.cgi?virtual-pixel)" effects are explored on [Implosion Effects of Virtual Pixels](../misc/#virtual_implode).

As the number of pixels being imploded into a small area increases, and the size of the implosion parameter gets very large, the results start to get a 'pixelated' look.
To get a better more consistent result, you can increase the number of pixels implode works with, using a technique called [Super-Sampling](../distorts/#super_sample).

Basically by using a larger image (enlarging the source image if necessary), doing the distortion, then shrinking the result to its final size you will produce a much better result.
  
      convert -size 94x94 xc:red -bordercolor white -border 3 \
              -virtual-pixel tile  -resize 400%  -implode 4 -resize 25% \
              implode_tiled_ss.gif

  
[![\[IM Output\]](implode_tiled_ss.gif)](implode_tiled_ss.gif)

As you can see you get a much smoother and more realistic result that shows the internal detail of the distortion much better.
However even super-sampling wil break down in extreme images like this, as it involved infinities.
If you look carefully you will see that a 'dotty' look returns, but only closer into the center.
  
By using a larger "[`-border`](../option_link.cgi?border)" around the image being imploded, and later removing it again, you can also warp the edges of an image, inward toward the center.
  
      convert koala.gif -bordercolor blue -border 20x20 \
              -implode .5   -shave 18x18  implode_border.jpg

  
[![\[IM Output\]](implode_border.jpg)](implode_border.jpg)
  
As of IM version 6.2.1 you can also use a transparent border, or image with transparency...
  
      convert koala.gif -bordercolor none -border 20x20 \
              -implode .5   -shave 18x18  implode_border_trans.png

  
[![\[IM Output\]](implode_border_trans.png)](implode_border_trans.png)

### Exploding Images

  
By using a negative value with the "[`-implode`](../option_link.cgi?implode)" operator, you can explode the image.
This is however more like magnifying the center of the image pushing all the mid-radius pixels out toward the edge, rather than a true explosion.
  
      convert koala.gif -implode -2 explode.jpg

  
[![\[IM Output\]](explode.jpg)](explode.jpg)
  
Using larger value will essentially enlarge the center most pixels of the image into a circle two-thirds the size of the smallest image dimension.
  
      convert koala.gif -implode -30 explode_big.jpg

  
[![\[IM Output\]](explode_big.jpg)](explode_big.jpg)
And here is a '[Super-Sampled](..distorts/#super_sample)', version.
  
      convert koala.gif -resize 400% -implode -30 \
              -resize 25% explode_big_ss.jpg

  
[![\[IM Output\]](explode_big_ss.jpg)](explode_big_ss.jpg)

The central color of the internal 'explosion' is set by the color of the center of the image (or region).
This means that by changing the colors around that point before exploding, you can control a 'flash' effect of the explosion.
See [Animations](#animations) below, for an animated example of this color control.

For another example of imploded images see user [hh](http://www.flickr.com/photos/ericosur/2708859259/) contributions on Flickr.

### Swirling Image Whirlpools

  
The "[`-swirl`](../option_link.cgi?swirl)" operator acts like a cake mixer.
It will warp the image around in a circle the number of degrees you give it as an argument.
  
      convert koala.gif -swirl 180 swirl.jpg

  
[![\[IM Output\]](swirl.jpg)](swirl.jpg)
  
By adding a border, and combining with "[`-implode`](../option_link.cgi?implode)" you can give the look of a whirlpool sucking the image up to oblivion.
  
      convert koala.gif -bordercolor white -border 20x20 \
              -swirl 180 -implode .3  -shave 20x20   whirlpool.jpg

  
[![\[IM Output\]](whirlpool.jpg)](whirlpool.jpg)

The key nature o fthis distortion is that the image will become rotated in the center by the angle you specify, while the circlur edge (like the [Implode Operator](#implode) above) remains uneffected.

At this time there is no parameter to specifiy an 'inner radius' to limit the swirl to a ring, rather than to a full disk.

I have animated these swirling effects, which you can see below in [Animations](#animations).

------------------------------------------------------------------------

## Animations (fun examples)

To finish off with lets generate some GIF animations of some of these distorts.
For these I generated some simple shells scripts to generate the animated image, which you can also download and play with, using your own test images.

This brings me to an important point.
If generating a series of images using these distorts, it is better to always distort from the original starting image, rather than incrementally distort the image over-n-over.

This is especially true of rotated images where there is some blurring of the result, though minimal in any individual operation, If you do it over an over however, this is the results.

All the scripts use a '**Generated "`convert`" Command**' technique, to create the animation.
That is a shell script creates a long single command, which is then executed.
This avoids the need to generate temporary files, though can be difficult to debug.

Another alternative is to use a method known as a [MIFF Image Streaming](../files/#miff_stream), which generates a individual images in a loop, and 'pipes' it into a final 'merging' command.
This is demonstrated more clearly in the examples [Programmed Positioning of Layered Images](../layers/#layer_prog) and [Pins in a Map](../layers/#layer_pins).

[![\[IM Output\]](animate_mixer.gif)](animate_mixer.gif)

The shell script "[`animate_mixer`](animate_mixer)" each frame is generated by using "[`-swirl`](../option_link.cgi?swirl)" on the original image.

The swirl is animated in one direction, then back again to form a continuous cycle.
This is actually a very typical example warping animation in IM.

A variation of this is to have the animation un-warp into a different but similar image.

[![\[IM Output\]](animate_whirlpool.gif)](animate_whirlpool.gif)

The shell script "`animate_whirlpool`", not only uses "`-swirl`" on each image frame, but also uses "[`-implode`](../option_link.cgi?implode)" with an increasing argument size, as well.

I used a '`lightblue`' border color for the added space used to show that the whole image will be 'sucked down the drain', though I should have used the same white background color instead, for a better, more realistic effect.

[![\[IM Output\]](animate_explode.gif)](animate_explode.gif)

An explosion in the middle of the image (see script "[`animate_explode`](animate_explode)".
The image is again enlarged so the whole image is exploded, and a colored dot is drawn at the center to define the final color.

[![\[IM Output\]](animate_flex.gif)](animate_flex.gif)

Using the shell script "[`animate_flex`](animate_flex)" the center of the image is flexed up and down by changing the amplitude of the "[`-wave`](../option_link.cgi?wave)" function both positive and negative.

[![\[IM Output\]](animate_flag.gif)](animate_flag.gif)

Using the shell script "[`animate_flag`](animate_flag)" I create a 'offset wave' animation to make the image wave like a flag.

The animation can be improved by also vertically offsetting each frame of the image so the left hand edge remains constant, and maybe adding a flag pole.
However that requires you to mathematically determine that offset, which can be tricky.

[![\[IM Output\]](animate_rotate.gif)](animate_rotate.gif)

The script "[`animate_rotate`](animate_rotate)" generated this rotating animation, but crops each frame with the original image as described above to preserve the original image size.
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> Update: As of IMv6.7.3-4 the [Rotate Operator](#rotate) is now using [Distort Operator](../distort/#distort) and [SRT Distortion](../distorts/#srt).
> As such the previous example will now produce the much less blurry result of the next example.

[![\[IM Output\]](animate_distort_rot.gif)](animate_distort_rot.gif)

As a comparison here is a koala rotation generated using the default settings and the "`-distort SRT {angle}`" command.
The script use to generate it is "[`animate_distort_rot`](animate_distort_rot)".
Note how much sharper the image is using this method of rotation, and the lack of rotational 'jitter' that is evident in the previous version.

#### Bonus Animations and Movies

[![\[IM Output\]](swirl_video.gif)](swirl_video.mpg) As a bonus *Florent Monnier* from France created a neat video using the "`-swirl`" distortion operator, made using a IM OCaml API script.
Select the GIF animation to the right to download the full version of the video.
You can also have a look at his [notes](swirl_video.txt) about the video.

*Can you make a good video demonstrating a distortion map technique? Do you know of one elsewhere on the net? Mail me.*

------------------------------------------------------------------------

Created: 14 January 2009 (distorts sub-division)  
 Updated: 11 October 2010  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/warping/`
