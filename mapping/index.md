# Image Mapped Effects

Distorting or modifying an image using some sort of secondary 'mapping' image that controls the process - be it replacing colors, variably blurring the image, or distorting images by specifying source coordinates absolutely or relatively.

------------------------------------------------------------------------

## Introduction {#intro}

As you have seen in the previous sections on [Composition](../compose/), [Simple Warping](../warping/), and [Distorting](../distorts/), you can modify images in many different ways.
However, they all are limited to the specific methods that have been built into ImageMagick.

You can even 'roll your own' image distortion using the ['FX' DIY Operator](../transform/#fx), or directly modify the values of an image using operators such as [Evaluate](../transform/#evaluate) or [Function](../transform/#function), or even the various [Level](../color_mods/#level) operators.

However, distortions take a lot of calculations (and time) to do their task, and if you plan to do the same task against multiple images, having IM repeat all those calculations can be a real waste of time.

The other aspect is that it is very hard to limit the effects of the distortion in a free form way.
You can't simply edit or modify the distortion that you want to apply. You have limited control.

**Image Mapping** is different.
You use an extra 'mapping' image to control what parts of an image is to be modified, and by how much, or in what way.
It does not have to modify the whole image, nor does it have to modify the image in some pre-defined or pre-programmed way.

You can create a 'map' that can modify an image in *ANY* posible way, without limitation.
You can also *edit* or further modify the mapping, to adjust or limit its effect, making it more complex, by merging different maps together, or just smooth or blur the effect.
And, finally, you can *save* the mapping to use it again later.
It is the 'map' image controls the results.

As the modification is 'map' controlled, there is usually very little calculation needed to be performed by ImageMagick, as such 'image mapping' is in general *very fast*.

It is also *repeatable*, as you can apply the same very complex map, to any number of images, to get the exact same modification.
That is to say you can apply it to a whole directory of images very quickly.

In essence, what *Image Mapping* does is move the slow, and complex mathematics of a particular effect from a specific image, to a more general 'map' image.
Once that 'map' is generated it can then be applied to a lot of actual images very quickly.

### What are Image Maps {#image_maps}

Mapping images are basically "Look Up Tables" or LUTs that define how a particular effect sould be applied to an image on an individual pixel by pixel basis.
That is, whether an effect is applied, and to what degree, is completely controlled by the image map.

Essentially, an image is an array of values, and what those values mean depends on the mapping process that is being applied.
They could indicate...

-   a direct replacement value (color lookup),
-   which image a color should come from (image masking),
-   how much a pixel should be lightened or darkened (highlighting),
-   how much to blur pixels at this location
-   specify the source coordinate (distortion),
-   or a location relative to the current position (displacement).

As you can see, you can do a lot of different things with an image map.  
However you may have noticed that some of these look remarkably like [Image Composition](../compose/), and you are right.
In some sense, image mapping is the merger of the mapping image with one or more other images.
In fact, many of the above image mapping techniques are simply implemented as various specialized compose methods!

However, true image composition is merging two real color images.
Image mapping involves using an image of values (a specialized gradient) to modify one (or more) images.

The hardest part is, of course, to generate a particular 'map' for a particular effect.
And this is what a lot of the work, effort and techniques that are present on this page are involved with.

Typically, this is done by using the various pre-existing operators and applying them to a [Gradient Image](../canvas/#gradient) of some kind.
Once you have a map however you can use it many times.

------------------------------------------------------------------------

## Color Lookup Tables {#color}

Color Lookup Tables (CLUTs) are the simplest form of '*Image Mapping*' to understand.
Basically a 'gray-scale' color value, of the source image, is used as a 'position' to lookup a replacement color value in a 'CLUT' which is simply a linear gradient of colors.

The result, in the simplest case (See the [CLUT Operator](../color_mods/#clut)), is a direct greyscale-to-color replacement mapping.

However it can do much more than this, and it is recommend you understand this technique before you proceed to much more complex techniques below.

See [Recoloring Images with Lookup Tables](../color_mods/#color_lut).

Another variation of this is the use a [Hald Color LUT](../color_mods/#hald) which lets you modify the full 3-dimensional color mapping of an image.

------------------------------------------------------------------------

## Lighting Effects {#lighting}

This is simply lightening and/or darkening an image using an image map (a grayscale image), and is typically regarded as a fairly normal [Lighting Composition](../compose/#light).
While it does not seem to be the case, it is still an image mapping technique.

------------------------------------------------------------------------

## Multi-image Masking {#multi-masking}

With two images, you can make use of three image [Composite Masking](../compose/#mask), to use a 'mask' image to select which image is to supply the results.
The 'mask' image is, in a sense, a very simple 'image map'.

However you can take this much further.
Instead of thinking of the 'mask' as selecting between two images, you can instead think of that image being the primary image that is being filled in by the other two image.
That is, replace white areas with one image and replace black areas with another image.

Now, if instead of a 'mask' you take the image as being a set of gray-scale levels, with each grey level selecting from some pattern that represents that gray-scale level.

The result is a method of 'dithering' images, replacing a gray-level with a pattern of a smaller number of colors.
This can be demonstrated very clearly in [DIY Dither Patterns and Threshold Maps](../quantize/#diy_dither).

Taking this one step further the image map can be used as a multi-image masking technique.
That is, the map is used to decide what image the pixel is to come from.
An example of doing this is shown in [Dithering with Symbol Patterns](../quantize/#diy_symbol).

The 'patterns' do not have to be small images, but could just as easily be full-sized images which the 'image map' is selecting from.

------------------------------------------------------------------------

## Variable Blur Mapping {#blur}

Added to ImageMagick version 6.5.4-0, the "`-compose`" method '`Blur`' provides you with a method of replacing each individual pixel by an Elliptical Gaussian Average (a blur) of the neighbouring pixels, according to a mapping image.

~~~{.skip}
composite -blur {Xscale}[x{Yscale}[+{angle}]] blur_map  image   result
convert image  blur_map  -compose blur \
    -define compose:args='{Xscale}[x{Yscale}[+{angle}]]' \
    -composite   result
convert image  blur_map  -compose blur \
    -set option:compose:args '{Xscale}[x{Yscale}[+{angle}]]' \
    -composite   result
~~~

Note that this [Image Composition](../compose) requires the use of an operational argument, which can be set in a number of ways.
See [Globally Defined Artifacts](../basics/#artifact) for more details.
By using a variable map to control the blur you can blur one part of an image, while leaving another part completely alone, or you can produce effects such as [Tilt-Shift Effect](../photos/#tilt_shift), where a real world image is made to appear more like a small artifical model.

For example, here I blur one half of a image of a koala while leaving the other half completely un-blurred...

~~~
convert -size 37x75 xc:black -size 38x75 xc:white +append  blur_map_bool.gif
convert koala.gif blur_map_bool.gif \
      -compose blur -define compose:args=3 -composite \
      blur_koala_bool.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](blur_map_bool.gif)](blur_map_bool.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](blur_koala_bool.gif)](blur_koala_bool.gif)

As you can see any pixel that was 'white' on the 'blur\_map' image was blurred using the maximum value of '*sigma*' given, while anything that was 'black' was not blurred at all.
In other words you have a masked blur - which could, of course, be done many ways.

The tricky part of the above is that only the areas blurred will take the extra time needed for the blurring operation.
Pixels which are not blurred, do not need this extra processing.
This makes the above much faster than either using a [Masked Composite](#mask) which is the same as blurring the whole image and merging the results.
This time saving can be even more important when dealing with large blurs of very small areas of an image.

What makes this blur mapping versatile is that it is variable across the image.
That is, if the blur mapping color is gray in color, than you will get a corresponding smaller blurred result, using a smaller 'neighbourhood', for that pixel.
Black, however, is not blurred, while white is maximally blurred, by the values given.

For example, let's make the koala progressively more blurry toward his feet...

~~~
convert -size 75x75 gradient:black-white blur_map_gradient.gif
convert koala.gif blur_map_gradient.gif \
      -compose blur -define compose:args=3 -composite \
      blur_koala_gradient.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](blur_map_gradient.gif)](blur_map_gradient.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](blur_koala_gradient.gif)](blur_koala_gradient.gif)

And here is the same blur again but showing how the blur varies with the height.

~~~
convert blur_map_bool.gif blur_map_gradient.gif \
      -compose blur -define compose:args=15 -composite \
     blur_edge_gradient.gif
~~~

[![\[IM Output\]](blur_map_bool.gif)](blur_map_bool.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](blur_map_gradient.gif)](blur_map_gradient.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](blur_edge_gradient.gif)](blur_edge_gradient.gif)

For a practical example of Variable Mapped Blurs, have a look at [Photo Tilt Shift Effect](../photos/#tilt_shift), and [Distance Blurred Shadow Font](../fonts/#var_blur).

Note that it is the neighbourhood around each individual pixel that is used to generate the 'blurred color' for that pixel.
That means that even though you may specify some part of an image to not be blurred, colors from that unblurred area may be used as part of the blur of surrounding pixels.

That is, just because an area is not blurred does not mean that colors from that area are not used as part of result of other blurred pixels.
That is, colors from the unblurred area can 'leak' into the surrounding blurred areas.
To blur a background without including foreground pixels, you need to use a [Read Mask Technique](../masking/#read_mask) to prevent them being read as part of the blur operation.

### Elliptical Blurring {#blur_ellipse}

The '`Blur`' compose setting uses a different technique to the normal [Blur or Gaussian Blur Operators](../blur/#blur), as it is implemented by using a Gaussian [Elliptical Area Resampling](../distorts/#area_resample) algorithm that was developed for scaled image resampling as part of [Generalized Distortion Operator](../distorts/#distort).

The elliptical area used for the neighbourhood resampling, also makes this method of blurring more versatile than a normal uniform 'circular' blur provided by the operators "`-blur`" and "`-gaussian-blur`".
The ellipse itself is defined by the '*width*', '*height*' of the sigma for the blurred area.
The ellipse can also be rotated from its orthogonal alignment by the given '*angle*' (clock-wise).

For example, in the following diagram we show how the blurred color of a single pixel will get its color from a rotated elliptical area, which is twice as large (its support factor) as the required width and height.
The pixels in this area are then weighted averaged together according to a [Gaussian Filter](../filter/#gaussian) (using an elliptical distance formula, to produce the blurred color.

~~~{.hide}
convert koala.gif \( +clone -size 75x75 xc: \
           -compose blur -define compose:args=5x1-30 -composite \) \
        -compose over -bordercolor blue -border 1x1    +append \
        -gravity North -background LightSteelBlue -splice 17x0 \
        -draw "stroke Firebrick fill None \
               path 'M 40,45  A 4,1 -30  0,0 40,55 \
                              A 4,1 -30  1,0 40,45 Z' " \
        -draw "stroke Firebrick fill None \
               path 'M 131,50 L 56,40 M 131,50 L 35,60' " \
        elliptical_average.gif
~~~

[![\[IM Output\]](elliptical_average.gif)](elliptical_average.gif)

As mentioned, this is exactly the same color lookup method that is used by the [Generalized Distortion Operator](../distorts/#distort) to generate the colors for its distorted images, as it allows for a scaled (and filtered) merge of an area of the source image into one pixel, especially in extreme distortions such as exampled in [Viewing Distant Horizons](../distorts/#horizon).
For more details of this process, see [Area Resampling](../distorts/#area_resample) and [Resampling Filters](../filter/#filter).

As an example of the elliptical controls available for variable blur mapping, let's use a black dot using the same gradient blur map we used before.
But this time we will scale a long thin horizontal ellipse '`30x0`', rather than a circle.
The '`x0`' may seem weird but basically means no vertical blurring should be seen, just an ellipse of smallest height needed to generate a good result.

~~~
convert -size 75x75 xc: -draw 'circle 36,36 36,8'  black_circle.gif
convert black_circle.gif blur_map_gradient.gif \
      -compose blur -define compose:args=15x0 -composite \
      blur_horizontal.gif
~~~

[![\[IM Output\]](black_circle.gif)](black_circle.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](blur_map_gradient.gif)](blur_map_gradient.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](blur_horizontal.gif)](blur_horizontal.gif)

As you can see, the amount of the blur is still varied with the map image provided, producing very little blur at the top of the image, and a lot of blur at the bottom.
But also notice that the bottom edge is blurred horizontally equally in both directions, but not vertically, producing a sharp cut off in the vertical direction.

By either rotating the long thin ellipse by giving a third *angle* argument, or by directly defining a vertical ellipse, you can blur the image vertically only...

~~~
convert black_circle.gif blur_map_gradient.gif \
      -compose blur -define compose:args=0x15 -composite \
      blur_vertical.gif
~~~

[![\[IM Output\]](blur_vertical.gif)](blur_vertical.gif)

Note, however, that the blur was not applied equally!
The top half appears less blurred than the bottom, because that is what the 'mapping image' told it to do.
This, in turn, distorts the image making it appear a little truncated by the blurring effect.

Finally, let's do this one more time but with a horizontal ellipse rotated by a fixed 45 degree angle.

~~~
convert black_circle.gif blur_map_gradient.gif \
      -compose blur -define compose:args=15x0+45 -composite \
      blur_angle.gif
~~~

[![\[IM Output\]](blur_angle.gif)](blur_angle.gif)

The image may appear very odd, but that is because the variable blur map is vertical while the blur itself is angled, producing the odd-looking effect, due to the way the ellipse angle and the angle of the blur map do not align.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> Note that using long thin ellipses like this is actually a lot faster that using a single large circle.
> In fact, the "`-blur`" operator gets its speed by using two separate horizontal and vertical blurs, whereas the "`-gaussian`" blur operator does a full 2 dimensional [convolution](../morphology/#convolve) in a simliar way to the '`Blur`' composition method just described.

### Blur with Variable Aspect Ratio {#blur_aspect}

So far, we have varied the size of the elliptical area used for the blur using 'blur map'.
However, while the size of the ellipse and even its angle can be rotated, its shape and angle remain fixed.

Now the 'blur map' is an image that is composed of three color channels: red, green, and blue.
As we used a greyscale image, all three color channels had the same values.
However, internally the width of the ellipse is scaled by just the red channel value, while the height is scaled by the green channel value.
Any effect of the blue channel value is typically ignored except in a special case which we will look at later.

This means the elliptical shape or its 'aspect ratio' can be varied by using different maps for the individual red and green channels.
As with a normal blur map, a zero (or 'black' in just that channel) value will result in minimal width or height, while a maximum value (or 'white') will result in the blur amount given.

For example, here I can divide the image so that two quarters of the image are blurred horizontally (red channel is maximal) while making the other areas blur vertically (green channel is maximal).

For this example, I generated width and height maps separately, before [Combining](../color_basics/#combine) them into a single and now colorful 'blur map'.
In normal practice, you can create the map in any way you like, or even use pre-prepared maps for specific blur effects.

~~~
convert -size 2x2 pattern:gray50 -sample 75x75! blur_map_r.gif
convert blur_map_r.gif -negate blur_map_g.gif
convert blur_map_r.gif blur_map_g.gif -background black \
      -channel RG -combine blur_map_aspect.gif
convert black_circle.gif blur_map_aspect.gif \
      -compose blur -define compose:args=10x10 -composite \
      blur_aspect.gif
~~~

[![\[IM Output\]](blur_map_r.gif)](blur_map_r.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](blur_map_g.gif)](blur_map_g.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_map_aspect.gif)](blur_map_aspect.gif)  

[![\[IM Output\]](black_circle.gif)](black_circle.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](blur_map_aspect.gif)](blur_map_aspect.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_aspect.gif)](blur_aspect.gif)

You can, of course, still set a fixed angle to the ellipse.

~~~
convert black_circle.gif blur_map_aspect.gif \
      -compose blur -define compose:args=15x15+45 -composite \
      blur_aspect_angle.gif
~~~

[![\[IM Output\]](blur_aspect_angle.gif)](blur_aspect_angle.gif)
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> :WARNING:
> Before IM version 6.5.8-8 a bug was found in the handling of an angled vertical elliptical blur.

### Blur with Variable Angle {#blur_angle}

So far, the angle of the ellipse used for blurring the image has been a constant angle over the whole image.
That is the ellipse used for the blur has always been at the same angle, even though the aspect ratio of the ellipse can be varied by modifying the red and green channels of the blur map.

As of IM v6.5.8-8, you can provide two angle values in the blur arguments.
This allows you to vary the angle of the ellipse across the image, according to the values in the blue channel of the 'blur map'.
The first angle argument is used to define the angle for a zero ('0' or 'black') value in the blue channel, while the second angle given is used to define the maximum ('QuantumRange' or 'white') value of the blue channel.

If only one angle value is given, then that angle is used to set the angles for both zero and maximum 'blue' channel value which basically means the angle becomes fixed, regardless of what value is present in the blue channel of the 'blur map' image.
This is why in previous examples, the angle has been constant.

For example, here I use a horizontally blurring ellipse, but then vary the angle of the ellipse using the blue channel over the angle range from '+0' to '+360' around the center of the image.
The map generation uses a polar gradient, the details of which can be found in [Distorted Gradients](../canvas/#gradient_distort).

Note how when placing that gradient into the blue channel, I use the "`-background`" color setting with the [Combine Operator](../color_basics/#combine) to ensure both the red and green channels are set to a maximum ('white') value, so it does not scale the angled ellipse.

~~~
convert -size 100x300 gradient: -rotate 90 \
      +distort Polar '36.5,0,.5,.5' +repage -flop gradient_polar.jpg
convert gradient_polar.jpg -background white \
      -channel B -combine blur_map_angle.jpg
convert koala.gif blur_map_angle.jpg \
      -compose blur -define compose:args=5x0+0+360 -composite \
      blur_rotated.jpg
~~~

[![\[IM Output\]](gradient_polar.jpg)](gradient_polar.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_map_angle.jpg)](blur_map_angle.jpg)

[![\[IM Output\]](koala.gif)](koala.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](blur_map_angle.jpg)](blur_map_angle.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_rotated.jpg)](blur_rotated.jpg)

The result is, as you can see, a rotationally blurred image.

Compare the result with the blur mapping that was used.
At the top of the image the angle, the gradient was either white or black, which with the arguments used means the ellipse was angled at either 0 or 360 so the ellipse remained horizontal.
At the bottom the gradient was pure gray, so an angle in the middle of the range given was used, or 180 degrees.
This means the ellipse is again horizontal.
But, at the sides of the image, the gradient was either 25% or 75% gray, thus the angle was either 90 or 270 degress making the ellipse rotate vertically.
All the other angles follow through causing the ellipse to rotate smoothly around the image.

However the center of the resulting image was blurred really weirdly! That is because the ellipse size remained constant and does not get appropriately smaller toward the middle of the image.

The solution is to also set the ellipse size using the red and green channels.
For example...

~~~
convert -size 106x106 radial-gradient: -negate \
      -gravity center -crop 75x75+0+0 +repage gradient_radial.jpg
convert gradient_radial.jpg gradient_radial.jpg gradient_polar.jpg \
      -channel RGB -combine blur_map_polar.jpg
convert koala.gif blur_map_polar.jpg \
      -compose blur -define compose:args=10x0+0+360 -composite \
      blur_polar.jpg
~~~

[![\[IM Output\]](gradient_radial.jpg)](gradient_radial.jpg)
![ +](../img_www/plus.gif)
[![\[IM Output\]](gradient_radial.jpg)](gradient_radial.jpg)
![ +](../img_www/plus.gif)
[![\[IM Output\]](gradient_polar.jpg)](gradient_polar.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_map_polar.jpg)](blur_map_polar.jpg)

[![\[IM Output\]](koala.gif)](koala.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](blur_map_polar.jpg)](blur_map_polar.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](blur_polar.jpg)](blur_polar.jpg)

A much better result.

Note, however, that while the result looks good, the blurring ellipse is not properly curved in an arc as it should be for a true rotationally blurred image.
As such, the above is only an approximation of a true rotational blur, but for small blur distances (equating to blur angle) it quite good.
The better way to do rotational blurs is to use a special [Polar-Depolar Distortion Technique](..distorts/#rotation_blur), or the currently miss-named [Radial Blur Operator](../blur/#radial-blur).

By changing the angle range used for the ellipse angle (blue channel) you can easily convert the above into a radial blur that becomes more blurry with distance from the center.

~~~
convert koala.gif blur_map_polar.jpg \
      -compose blur -define compose:args=5x0+90+450 -composite \
      blur_radial.jpg
~~~

[![\[IM Output\]](blur_radial.jpg)](blur_radial.jpg)

But you can also do much more than these radial/rotational blurs, as you can rotate and scale the blur anywhere by any amount over the whole image.
You have total control.

For example, you can make a very weird mixture of the two by using different angle range so the angle of the blur ellipse does not match the angle around the image center.

~~~
convert koala.gif blur_map_polar.jpg \
      -compose blur -define compose:args=10x0+0+180 -composite \
      blur_weird.jpg
~~~

[![\[IM Output\]](blur_weird.jpg)](blur_weird.jpg)

Basically, you now have complete control of the how and what parts of the image will be blurred.
And with the use of templates you can create a whole library of blurring effects.

------------------------------------------------------------------------

## Distorting Images using Image Mapping {#distort}

With the various distortion operators described in the previous sections of IM Exampled (such as [Simple Image Warping](../warping/) and [General Image Distortions](../distorts/)), you are restricted to just the various types distortions that have been programmed into the IM graphics library, generally using specific mathematical equations and formulas.

However, there are times when you want to design your own distortion in a more freeform and less mathematical way.
For example, to generate a more complex distortion, such as mapping an image into a particular shape, or with a particular complex lens effect, that is easier to draw than to define mathematically.
Sometimes you just want to be able to repeat your distortion over a large number of images and avoid having to re-calculate the distortion over and over.

The solution is to pre-calculate your distortion, and save it as special look-up table (LUT) in the form of a grayscale image.

That is for each output pixel, we look-up the LUT, then use that value to look-up the color from the source image. That is three steps are needed.

1.  Look-up up each destination pixel in the LUT
2.  Map the LUT value to the source image location (two methods)
3.  Look-up the color from the source image

This image can be applied repeatedly very quickly over many different images, without needing to re-calculate it all the time.
That is, you do all your calculations into a set of look-up table images, applying all the heavy calculations, distortions and other image warping effects.
Then you can apply the pre-calculated distortion maps to any number of images, as many times as you like, quickly and easily.

As an image is used for the 'lookup table' of the distortion, you can create, or modify the distortion map using an image editor, such as '`Gimp`' or '`Photoshop`', giving you the freedom to do some really fancy and complex distortions.
  
There are two major ways of defining a distortion LUT.

One method is where the values (or colors) of the LUT represent the pixel coordinate to look-up from the source image.
That set of values represents the **absolute** coordinates of the source pixel to place in this position on the destination image.
See next section on [Absolute Distortion Maps](#lut_absolute).

The other method seems harder, but is actually more versatile.
In this case, the LUT image values represent coordinate offset, relative to the current position.
Gray means no offset; White a maximum positive offset, and Black a maximum negative offset.
That is, the values represent a **displacement** from from the current position to the lookup coordinate of the source image to use.
See [Displacement Maps (Relative Lookup Maps)](#displacement_maps) below.

Both methods have advantages and disadvantages, as you will see.

------------------------------------------------------------------------

## Absolute Distortion Lookup Maps {#distortion_maps}

*FUTURE:*

Start with a red-green 'gradient' that represents the image coordinates, and distort that.
The result is a map of distorted image coordinates.
That is the essence of an absolute distortion map.

Creating an **Absolute Distortion LUT Map** is the simpler of the two methods to both understand, create distortion LUT maps for, and to apply.
However, as you will see, it has very serious drawbacks making them less practical than a [Relative Displacement Map](#displace).
Before proceeding, you need to understand that distort maps, like just about all the distortion methods we have seen, are applied as a [Reverse Pixel Mapping](#mapping).
That is, we don't map a source pixel to a destination coordinate, but use it to lookup the source image from the destination image coordinates.

What this means is, that for each pixel in the destination image, we look-up the color of the pixel from the source image, using the distortion method being applied.
In this case, the method is to look-up the source coordinate from the provided Look-up Table Image.

Unfortunately, at this time, IM can not directly handle such distortion maps.
However, we can use the [FX, General DIY Operator](../transform/#fx) to do do all three steps.

First, let's start with some basic definitions, of what the LUT will mean.

Any 'black' pixel in the LUT image (value 0.0) will be thought of as the left-most pixel or '`0`' X coordinate of the source image, while anything that is 'white' in the LUT (value 1.0), is to be thought of as the right-most pixel (the width of the source image).
Note that this LUT will only look-up the X, or horizontal, position of color in the source image.
It will not change the vertical, or Y, positions of colors.

So, let's try this with a simple plain gray-scale horizontal gradient for the LUT.

~~~{.hide}
convert -size 75x75 gradient: -rotate 90 map_gradient_x.gif
~~~

~~~
convert koala.gif \( -size 75x75 gradient: -rotate 90 \) \
      -fx 'p{v*w,j}'      distort_noop.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](map_gradient_x.gif)](map_gradient_x.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_noop.gif)](distort_noop.gif)

Note that this did not make any real changes in mapping the source image to the destination image.
That is because the X coordinate that we looked up from the distortion map, was the same position we were looking up the color for.

However, by simply flipping the gradient over, the look-up of the pixels is also flipped, creating a mirror image.
That is, white is on the left and 'black' is on the right, and a horizontal gradient across the image.

~~~{.hide}
convert -size 75x75 gradient: -rotate -90 map_gradient-x.gif
~~~

~~~
convert koala.gif \( -size 75x75 gradient: -rotate -90 \) \
      -fx 'p{v*w,j}'      distort_mirror_x.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](map_gradient-x.gif)](map_gradient-x.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_mirror_x.gif)](distort_mirror_x.gif)

If we take the original gradient and compress it using a contrast enhancement operator, we can get a much more useful distortion.

~~~
convert -size 75x75 gradient: -rotate 90 \
      -sigmoidal-contrast 8,50%      map_compress.gif
convert koala.gif  map_compress.gif -fx 'p{v*w,j}'  distort_compress.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](map_compress.gif)](map_compress.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_compress.gif)](distort_compress.gif)

Notice that the sides of the distortion are stretched while the center is compressed.
We can expand this to two dimensions by using 2 distortion maps, one to adjust the X coordinate, the other for the Y coordinate.

~~~
convert map_compress.gif -rotate 90 map_compress_y.gif
convert koala.gif  map_compress.gif map_compress_y.gif \
      -fx 'p{u[1]*w,u[2]*h}'   distort_compress_2D.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](map_compress.gif)](map_compress.gif) [![\[IM Output\]](map_compress_y.gif)](map_compress_y.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_compress_2D.gif)](distort_compress_2D.gif)

As you can see, the above recreated a variation of the implosion method, though only by compressing the images along the X and Y axis (simultaneously), rather than radially as the [Implode](#implode) operator does.

#### The NO-OP Distortion Map revisited {#noop_distortion_maps}

Before we get any further, I would like to just step back a moment and have another look at the the 'noop' example above.
This actually will blur the image slightly, as the formula as I have outlined is actually not exactly correct.

Basically to do a perfect 'copy' of the original image, you need to map a 'white' (or 1.0) value from the LUT to the exact right-most (or bottom-most) pixel. This pixel is located at width or height of the source image minus 1.

The following command shows a correct "[`-fx`](../option_link.cgi?fx)" absolute distortion LUT mapping formula, and a simple method of testing that 'no-op' distortion map for accuracy.

~~~
convert -size 75x75 pattern:gray50 \( gradient: -rotate 90 \) gradient: \
      -fx 'p{u[1]*(w-1),u[2]*(h-1)}'    distort_fx_check.gif
~~~

[![\[IM Output\]](distort_fx_check.gif)](distort_fx_check.gif)

The image used in the test above is a grayscale 'checks' pattern that will highlight any failure in a no-op distortion, whether that distortion is caused by the mapping image, or inaccuracies of the LUT mapping formula.
Either case will appear as a blurring of the pixels into a grey color either across the whole image, or in bands or spots.
If the formula above is correct, the exact same original checker board pattern (as shown) should be reproduced.

However, it should be pointed out these slight inaccuracies are unimportant when you are actually applying a map with an actual distortion.
As such, you can usually ignore this minor adjustment in the LUT mapping, unless such inaccuracies can become important, such as if you have undistorted areas in the LUT map you are applying that you want to preserve as accurately as possible.

### Problems with Distortion Maps {#distortion_problems}

The two maps we generated can, as in the previous example, be thought of as two separate distortions, one in the X direction and the other in the Y direction.
In fact this is quite a valid thing to do.

However you can also view the two maps as representing a single distortion of both X and Y absolute coordinates.
This is how you must picture a distortion involving rotation.
For example...

~~~
convert -size 75x75 gradient: -background black -rotate 45 \
      -gravity center -crop 75x75+0+0 +repage  map_rot45_x.png
convert map_rot45_x.png  -rotate 90              map_rot45_y.png
convert koala.gif  map_rot45_x.png   map_rot45_y.png \
      -fx 'p{u[1]*w,u[2]*h}'      distort_rot45.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45_x.png)](map_rot45_x.png)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45_y.png)](map_rot45_y.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](distort_rot45.gif)](distort_rot45.gif)

And we now have another way of rotating any image.

The biggest problem with this technique is that by creating our distortion maps using rotates, we introduced some oddly colored pixels along the sides of the diagonal edges.
In the last example this caused some random pixels to be added in a line along the bottom right corner of the image.

These 'random' colors are anti-aliasing values that the rotate introduced to produce a 'better' image.
However for distortion maps, anti-aliased edge pixels can cause a real problem.
Now we can try to better define the colors at the edges of the rotated LUT images.
In this case, we can generate a larger gradient image, then cropping the rotation down to the correct size.

~~~
convert -size 100x20 xc:white xc:black -size 115x75 gradient: \
      +swap -append   -rotate 45 \
      -gravity center -crop 75x75+0+0 +repage   map_rot45b_x.png
convert map_rot45b_x.png  -rotate 90              map_rot45b_y.png
convert koala.gif  map_rot45b_x.png   map_rot45b_y.png \
      -fx 'p{u[1]*w,u[2]*h}'      distort_rot45_better.png
~~~

[![\[IM Output\]](koala.gif)](koala.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45b_x.png)](map_rot45b_x.png)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45b_y.png)](map_rot45b_y.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](distort_rot45_better.png)](distort_rot45_better.png)

In this way, all the pixels in the LUT are defined properly, including all the edges of the rotated LUT gradients.
However that is not the only problem.
We have, in the process, fully defined all pixels, including the pixels in the corners of the rotated image.
These pixels are technically undefined.
They have no meaning to the final distorted image.

And this represents the biggest problem with using an LUT to specify the absolute coordinates to get from the source image.
You have no way of specifying what IM should do in these undefined areas.
You can't just specify an extra color as these are just a simple gray-scale image that uses the full range of values for the LUT.

### Set an Undefined Pixel Border {#undefined_border}

There are a number of ways to solve this 'undefined' pixel problem.
The first, and probably the simplest, is to specify what color the pixels surrounding the image should be, using [Virtual Pixel Setting](../misc/#virtual).
For example using a [White Virtual Pixel](../misc/#white).

~~~
convert -size 100x20 xc:white xc:black -size 117x77 gradient: \
      +swap  -append -rotate 45 \
      -gravity center -crop 77x77+0+0 +repage  map_rot45f_x.png
convert map_rot45f_x.png  -rotate 90             map_rot45f_y.png
convert koala.gif -virtual-pixel white \
      map_rot45f_x.png   map_rot45f_y.png  -fx 'p{u[1]*w,u[2]*h}' \
      distort_rot45_final.gif
~~~

[![\[IM Output\]](koala.gif)](koala.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45f_x.png)](map_rot45f_x.png)
![ +](../img_www/plus.gif)
[![\[IM Output\]](map_rot45f_y.png)](map_rot45f_y.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](distort_rot45_final.gif)](distort_rot45_final.gif)

So, let's have a look at a particular example using this technique.

### Hourglass Distortion Map {#hourglass}

Now, I wanted a one dimensional distortion map, that scaled each row of the image differently based on that row's vertical coordinate... sort of producing a real carnival fun house mirror distortion that makes fat people look very thin.
In other words, a sort of hourglass distortion.

This is quite a complex LUT image, and after a lot of fiddling I came up with the following expression to generate the height variable, but horizontally linear gradient map.

~~~
convert -size 100x100 xc:  -channel G \
      -fx 'sc=.15; (i/w-.5)/(1+sc*cos(j*pi*2/h)-sc)+.5' \
      -separate  map_hourglass.png
~~~

[![\[IM Output\]](map_hourglass.png)](map_hourglass.png)
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> When generating grayscale gradients, you can make the -fx operator 3 times faster, simply by asking it to generate only a single color channel, such as the '`G`' or green channel in the above example.
> This channel can then be [Separated](../color_basics/#separate) to form the required gray-scale image.
> This can represent a very large speed boost, especially when using a very complex "`-fx`" formula.

The '`sc`' is the scaling factor for the hourglass (value ranges from 0 to 0.5), and allows you to adjust the magnitude of the distortion.

Now let's apply this map to the built-in "`rose:`" image.

Note that the 100x100 pixel map does not match the 70x46 pixel image.
This complicates things, as we will need to scale the current pixel in the source image by the appropriate amount to match the distortion map we give, to look-up the location of that pixel's color.

~~~
convert rose:   map_hourglass.png \
      -fx 'p{ v.p{i*v.w/w,j*v.h/h}*w,  j}'  distort_hourglass.png
~~~

[![\[IM Output\]](distort_hourglass.png)](distort_hourglass.png)

If you look at this carefully, the pixel's X coordinate '`i`' is multiplied by the width of the distortion map image '`v.w`', and divided by the original image's width '`w`', to produce '`i*v.w/w`'.
The same thing happens for the pixel's Y coordinate, '`j*v.h/h`'.
This re-scales the pixel coordinate in the destination image to match the distortion LUT image.
The looked up coordinate is then scaled by multiplying the LUT value with the source image's width, to become the X coordinate for the color look-up.

If you have both an X and a Y distortion map, then you will have to repeat the scaled look-up for the Y map.
Of course, we have the same 'edge' distortions we saw previously, so let's change the [Virtual Pixel Setting](../misc/#virtual) to transparency.

~~~
convert rose: -alpha set  -virtual-pixel transparent -channel RGBA \
      map_hourglass.png  -fx 'p{ v.p{i*v.w/w,j*v.h/h}.g*w, j}' \
      distort_hourglass2.png
~~~

[![\[IM Output\]](distort_hourglass2.png)](distort_hourglass2.png)

Note the use of the "[`-channel`](../option_link.cgi?channel)" setting to ensure that "`-fx`" will work with and return alpha channel (transparent) values from the source image.
Specifically the transparent virtual pixels.
Also note that when looking up the distortion map we ony looked up from the green channel (using '`v.p{}.g`').
If this is not done, the same channel as being processed from the source image will be used, and for the map 'alpha' is not defined.
This distortion map could be made even better by using a non-linear gradient so the image remains rectangular, with more distortion at the edges than in the middle, to give it a more 'rounded' or 'cylindrical' look.

*Anyone like to give this a go? Mail me.*

### Set Undefined Pixels using a Mask {#undefined_masking}

A more general way of solving the 'undefined pixel' problem, is to define a map of what pixels are actually a valid defined result in the distortion.
In other words, a masking image.
For example...

~~~
convert -size 75x75 xc:white -background black -rotate 45 \
      -gravity center -crop 75x75+0+0 +repage  map_rot45b_m.png
convert distort_rot45_better.png map_rot45b_m.png \
      +matte -compose CopyOpacity -composite   distort_rot45_masked.png
~~~

[![\[IM Output\]](distort_rot45_better.png)](distort_rot45_better.png) ![ +](../img_www/plus.gif) [![\[IM Output\]](map_rot45b_m.png)](map_rot45b_m.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_rot45_masked.png)](distort_rot45_masked.png)

Now we have three images involved with the distortion map, and the results are getting very complex indeed.
Of course, in a typical situation, you probably will not need to go that far, but for the general case you do.

### Unified Distortion Image {#distortion_unified}

You may, however, have noticed that all three maps are greyscale images.

This means it is quite reasonable to merge all the maps into a single distortion map image.

For example, let's map the 'X distortion map' to the '`red`' channel, the 'Y map' to the '`green`', and the mask to the '`alpha`' or transparency channel, which makes it easier to handle.

~~~
convert map_rot45b_x.png map_rot45b_y.png \( map_rot45b_m.png -negate \) \
      +matte -channel RGA -background black -combine  map_rot45u.png
~~~

[![\[IM Output\]](map_rot45b_x.png)](map_rot45b_x.png) [![\[IM Output\]](map_rot45b_y.png)](map_rot45b_y.png) [![\[IM Output\]](map_rot45b_m.png)](map_rot45b_m.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](map_rot45u.png)](map_rot45u.png)

  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> The '`blue`' channel in the [Combined Channel Image](../color_basics/#combine) is not defined, so takes its value from the current "[`-background`](../option_link.cgi?background)" color, which I preset to '`black`', or a value of zero, in the above.

Now let's apply this unified distortion map to our koala image.
This unfortunately requires two image processing steps, one to distort the image, and one to mask the result.

~~~
convert koala.gif -matte   map_rot45u.png \
      \( -clone 0,1  -fx 'p{v.r*w,v.g*h}' \
     +clone -compose Dst_In -composite \) -delete 0,1 \
      distort_rot45_unified.png
~~~

[![\[IM Output\]](koala.gif)](koala.gif) [![\[IM Output\]](map_rot45u.png)](map_rot45u.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](distort_rot45_unified.png)](distort_rot45_unified.png)

There is still an unused channel (`blue`) in the 'unified distortion map' image.
One logical use for it is as a means to add highlights and shadows to the distorted image - see [Overlay highlights](../compose/#overlay).

You can see this technique applied in the [Spherical Distortion Map](#spherical) example below.

### Spherical Distortion Map {#spherical}

In the previous [Hourglass Distortion Map](#hourglass) example, I generated a gradient which was horizontally scaled by a cosine curve.
With a little more work, you can generate a spherical shape instead...

~~~
convert -size 100x100 xc:  -channel R \
      -fx 'yy=(j+.5)/h-.5; (i/w-.5)/(sqrt(1-4*yy^2))+.5' \
      -separate  +channel     sphere_lut.png
~~~

[![\[IM Output\]](sphere_lut.png)](sphere_lut.png)

Note, however, that the above is not strictly accurate.
The compressed gradient remains a liner gradient, just compressed to fit within a circle.
A more accurate representation would probably require the creation of a non-linear gradient.
Which would, in absolute position terms, be an 'arccos()' function.

Now this mapping also has some large areas which would be classed as invalid, so we will need some type of masking to define what pixels will be valid and invalid in the final image.
A simple circle will do in this case.

~~~
convert -size 100x100 xc:black -fill white \
      -draw 'circle 49.5,49.5 49.5,0'    sphere_mask.png
~~~

[![\[IM Output\]](sphere_mask.png)](sphere_mask.png)

And, to complete, we also need a shading highlight, such as developed in [Overlay Highlights](../transform/#shade_overlay), for use by [Overlay](../compose/#overlay) or [Hardlight](../compose/#hardlight) composition...

~~~
convert sphere_mask.png \
      \( +clone -blur 0x20 -shade 110x21.7 -contrast-stretch 0% \
     +sigmoidal-contrast 6x50% -fill grey50 -colorize 10%  \) \
      -composite sphere_overlay.png
~~~

[![\[IM Output\]](sphere_overlay.png)](sphere_overlay.png)

Remember the above shading will only matter within the bounds of the sphere object, so the fact that the shade overflows those bounds is not important.
Actually, if you would like to try and come up with a better spherical shading, that produces an even better ball-like image, I would love to see it.

So, let's apply all three images: X coordinate LUT, Overlay Shading, and Transparency Mask; to an actual image of the right size (for simplicity).

~~~
convert lena_orig.png -resize 100x100   sphere_lut.png   -fx 'p{ v*w, j }' \
      sphere_overlay.png   -compose HardLight  -composite \
      sphere_mask.png -alpha off -compose CopyOpacity -composite \
      sphere_lena.png
~~~

[![\[IM Output\]](lena_orig.png)](lena_orig.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](sphere_lena.png)](sphere_lena.png)

This particular example shows the most powerful aspect of an [Absolute Distortion Map](#distortion_map).
You can define a gradient on any freeform object (not necessarily mathematically), so that any image can be mapped onto that object, whether it be curves, wrinkles, folds, etc.
Simply put, once you have the object mapping worked out you can map any image onto its surface.

Then to make it more realistic looking, you can overlay a second mapping, to add highlights, shadows, edges, and other features.

Of course, as all three images are grayscale, you can combine them into a single [Unified Distortion Map](#distortion_unified) image, for easy storage.
In this case, I'll make it a more spherical distortion by re-using the X coordinate distortion LUT for the Y coodinate as well.

~~~
convert sphere_lut.png   \( +clone -transpose \) \
      sphere_overlay.png   \( sphere_mask.png -negate \) \
      -channel RGBA  -combine    spherical_unified.png
~~~

[![\[IM Output\]](spherical_unified.png)](spherical_unified.png)

It is a rather pretty map.
But if trying to interpret it, remember that: the 'red' and 'green' channels are the X and Y coodinate LUT, 'blue' is the highlight and shadow effects overlay, and the transparency channel holds the invalid pixel mask for the final image.

And here I apply the complete 2-dimensional unified LUT to another image...

~~~
convert mandrill_grid_sm.jpg   spherical_unified.png  \
      \( +clone  -channel B -separate +channel \) \
      \( -clone 0,1    -fx 'p{ v.r*w, v.g*h }' \
     -clone 2   -compose HardLight -composite  \
     -clone 1  -alpha on  -compose DstIn -composite \
      \) -delete 0--2       spherical_mandrill.png
~~~

[![\[IM Output\]](mandrill_grid_sm.jpg)](mandrill_grid_sm.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](spherical_mandrill.png)](spherical_mandrill.png)

So now you can easily apply this distortion to lots of images, without needing all the original calculations and image processing used to generate the map.

### Circular Arc Distortion Map {#circlar_arc}

Just to show just what is really possible by using positional distortion maps, here is an absolute distortion LUT, similar to what is provided by the ['Arc' Distortion Method](#arc) above.

Basically, instead of calculating the coordinate mappings for each and every pixel in each and every image being distorted, we save those calculated coordinates into the two X and Y coordinate gray-scale LUT maps.

That is, we pre-calculate the whole distortion into a simpler look-up table image, allowing it to be applied over, and over, and over, without needing further square roots or trigonometric functions.

~~~
convert -pointsize 30 -font Candice label:Anthony -trim +repage \
      -gravity center -resize 95x95 -crop 100x100+0+0\! \
      -flatten text_image.jpg
convert -size 100x100 xc: -channel G  -fx 'atan(j/(i+.5))*2/pi' \
      -separate   -flip -flop       map_p_angle.png
convert -size 100x100 xc: -channel G  -fx '1-hypot(i,j)/(w*1.6)' \
      -separate   -transverse       map_p_radius.png
convert text_image.jpg   map_p_angle.png map_p_radius.png \
      -fx 'p{u[1]*w,u[2]*h}'    distort_p_curved.jpg
~~~

[![\[IM Output\]](text_image.jpg)](text_image.jpg)  

Color Source
  
![ +](../img_www/plus.gif)  
  
[![\[IM Output\]](map_p_angle.png)](map_p_angle.png)  
Angle - X Map
  
![ +](../img_www/plus.gif)  
  
[![\[IM Output\]](map_p_radius.png)](map_p_radius.png)  
Radius - Y Map
  
![==&gt;](../img_www/right.gif)  
  
[![\[IM Output\]](distort_p_curved.jpg)](distort_p_curved.jpg)  
Curved Text

Of course, generating that distortion map was difficult, but once it has been done once, using any means you like (even artistically using an image editor like "`Gimp`" ), you can then reuse it on a huge number of images.

### Polar Distortion Map {#polar}

Sometimes you may need the destination image to be defined by the distortion map, rather than the source image, just to make things work correctly.

For example, if we want to map some text into a circle (also known as a polar transform), you really need to be able to use an image that is about 3 to 4 times longer than it is high (high aspect ratio) or the result will not be very readable.

To do that, we place the distortion map images before the color source image, so that the first (X map) image will be used to set the size of the final result, rather than the input source image.

~~~
convert -size 100x100 xc:  -channel G \
    -fx 'atan2(i-w/2,h/2-j)/pi/2 + .5' \
    -separate  map_p_angular.png
convert -size 100x100 xc:  -channel G \
    -fx 'rr=hypot(i-w/2,j-h/2); (.5-rr/70)*1.2+.5' \
    -separate  map_p_radial.png
convert -font Candice -gravity center -size 200x50 \
    label:'Around  the  World'    text.jpg
convert map_p_angular.png map_p_radial.png text.jpg \
         -fx 'u[2].p{ u*u[2].w, v*u[2].h }' distort_p_circle.jpg
~~~

[![\[IM Output\]](map_p_angular.png)](map_p_angular.png)  
Angular - X Map
  
![ +](../img_www/plus.gif)  
  
[![\[IM Output\]](map_p_radial.png)](map_p_radial.png)  
Radial - Y Map
  
![ +](../img_www/plus.gif)  
  
[![\[IM Output\]](text.jpg)](text.jpg)  
Color Source
  
![==&gt;](../img_www/right.gif)  
  
[![\[IM Output\]](distort_p_circle.jpg)](distort_p_circle.jpg)  
Circled Text

Essentially, the color source image can now be any size or aspect ratio, and things will be handled correctly, however you may need to adjust the generation of the distortion map to handle the source image's aspect ratio correctly.
In generating the above maps, the value '`70`' controls the final size of the circle, along which the mid-line is placed.
The '`1.2`' value, on the other hand, controls the vertical scaling of the image into the circle, allowing you to adjust the height of the distorted text.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Remember this "[`-fx`](../option_link.cgi?fx)" expression requires the distortion maps to be given first, and the color source to be given as the third (index 2) image.
> However, this will also mean that any meta-data that is stored in the source image will also be lost.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> The problem with this distortion map is that there is a very sharp disjunction of colors in the 'X map' caused by an asymptote in the mathematics.
> This line must remain sharp when you do any color look-up, or resizing of the map, to produce a larger image.
> That is, you will need to ensure that any resize or interpolated look-up of this map does not produce a grey look-up color along that asymptotic line.
  
If you do generate grey look-ups along this line, you will get a line of colored pixels (looked up from the middle of the image) in your final result.

Because of this, it is recommended you always generate this distortion map at the size you need for the final image, and never use any scaling technique previously shown.

You can use this for other effects too, like a circular checkerboard...

~~~
convert map_p_angular.png map_p_radial.png \
      -size 150x90 pattern:checkerboard \
      -fx 'u[2].p{ u*u[2].w, v*u[2].h }'   distort_check_circle.gif
~~~

[![\[IM Output\]](distort_check_circle.gif)](distort_check_circle.gif)

Try some of the other [Built-In Patterns](http://www.imagemagick.org/script/formats.php#builtin-images) that IM provides with the above for other interesting effects.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> The above clearly shows the limits of image distortions using "[`-fx`](../option_link.cgi?fx)".
> Near center of the image, the radial lines are becoming aliased as pixel merging of a large areas into a single pixel does not take place.
> On the other hand, the edges of the image, particularly the corners, show an appropriate blurring of the radial lines.

> The cause is that "[`-fx`](../option_link.cgi?fx)" (and most older distortion methods) only do simple unscaled interpolated look-ups of the colors in the source image.
> This means that as the image scales smaller the source image pixels are not merged together to produce the correct color for the destination pixel.
  
> This is not a problem for areas of enlargement (as in the corners) only of extreme compression (center).
> As such, one solution is the use of [Super Sampling](super-sample), but all this does is postpone the problems to a higher level of compression.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> The same asymptotic line in the distortion map also produces a sharp color change along that line in the above example.
> Compare that line with the other radial lines which get very fuzzy around the edge of the image due to interpolated look-up.

> This may be a problem when generating a circular pattern with a tileable image (such as the above), and may require some special handling to avoid visible differences in that part of the image.

> To avoid this, it may be better to distort the top half of the image separately to the bottom half so as to avoid the asymptotic region.

------------------------------------------------------------------------

## Relative Lookup Displacement Maps {#displacement_maps}

As you can see, an [Absolute Distortion Map](#distortion_maps) is reasonably easy to create and use.
However, it has a serious problem when a distortion has 'undefined' regions, or areas where the distortion goes 'outside' the normal bounds of the source image.
A more serious problem is that you are always dealing with gradents, which define the absolute coordinates for the color lookup.
No part of the mapping image is simple, or clean, or easy to modify or edit by hand.
Special techniques and mathematics are needed in their creation and use.
That generally means there is very little in the way of 'artistic' development involved.

There is, however, another method of using a Lookup Table, to specify the coordinates in which to get the final color, namely by using a **Relative Displacement Map**.

Instead of the 'map' defining the exact coordinate in which to lookup each pixels color from the source image, it instead defines an offset or *displacement* relative to the current position.

Now, an offset could be a positive or negative value, and a negative value requires a little trickiness to encode into a color value.
So what they do is define 'pure gray' as being a zero displacement of the coordinate, i.e. no change.
They then make 'black' mean a maximum negative displacement, and 'white' mean a maximum positive displacement.

This can be hard to describe, so let's look at an example. First we create a test image to 'displace'.

~~~
convert -font Candice -gravity center -size 150x50 \
    label:'Anthony'    label.jpg
~~~

[![\[IM Output\]](label.jpg)](label.jpg)

Now I'll use some 'magick' to create a 'pure gray' image which includes a some 'pure white' area and a 'pure black' area.
  
~~~
echo "P2 5 1 255\n 127 0 127 255 127" |\
   convert - -scale 150x50\! +matte   displace_map.jpg
~~~

[![\[IM Output\]](displace_map.jpg)](displace_map.jpg)

Now, to use this image as a 'displacement map', we get the 'gray value' from the displacement map, and add it either (or both) the X and Y coordinate.
That is we 'displace' the lookup by a relative amount from the current position.
The 'value' is handled in a special way, so that a 'pure-gray' will mean a zero displacement of the lookup point (just the Y coodinate in this case) but a 'maximum displacement' is used for a 'white' (positive) or 'black' (negative) value.

For example, let's apply the displacement map to our "label" image.

~~~
convert label.jpg  displace_map.jpg  -virtual-pixel Gray \
    -fx 'dy=10*(2v-1); p{i,j+dy}'   displaced.jpg
~~~

[![\[IM Output\]](displaced.jpg)](displaced.jpg)

As you can see, the various sections of the image look like they 'moved' according to the color of the displacement map.
A 'white' region will add the given 'displacement value' to the lookup point, so in that area each pixel looks up the source image '10' pixels 'south-ward' (positive Y direction).
As a result, it looks as if the source image moved upward.
Remember it is the lookup that is displaced, NOT the actual image itself, which is why it appeared to move upward or a negative direction for white.

A similar effect was also seen for the areas with a 'black' displacement.
The source image appeared to move downward, because the lookup displacement was done in a negative direction.
Think about it carefully.

You will also notice that the 'displaced lookup' can actually look beyond the normal image bounds allowing you to use a [Virtual Pixel](../misc/#virtual-pixel) setting to control these out of bounds pixels. In the above I just requested that a gray pixel be returned.

The 'maximum displacement' value '`10`' in the above example is very important, and is the maximum relative distance any part of the source image appears to move, for a 'pure white' or 'pure black' displacement value in the mapping image.
You can not displace the lookup, and thus the input image anything further than this value.

Other shades of gray between the maximum white or black values and the central no-displacement 50% gray value, will displace the lookup by an appropriate amount.
As such, a 25% gray value will displace the lookup by 1/2 the displacement value in the negative direction, while a 75% gray will displace by 1/2 that value in the positive direction.

This value is a key difference between an [Absolute Distortion Map](#distortion_map) and [Relative Displacement Map](#displacement_map).
You can increase or decrease the relative displacements, making the image more or less distorted, simply by changing the displacement value, without needing to change the displacement map at all.

Also as a 'zero-displacement' map is just a solid 50% or pure gray, and not a complex gradient, you can start with a simple gray image, and artistically lighten or darken areas to generate the desired displacements.
You can do this simply by drawing shapes or areas, rather then needing a complex and exact mathematical formula.

And finally as all the displacements are relative, wild values such as produced by edge-effects does not produce wild or random pixel colors.
In fact, as you will see, smoothing or blurring [Displacement Maps](#displacement_map) is actually a good thing as it removes the disjoint or discontinuous 'cutting' effect you can see in the above example.

**In summary** Displacement maps are much more controllable, and artistic, providing localized displacements without the need for complex and exacting mathematics, and are very forgiving with regard to mistakes, edge effects, or even displacement map blurring.

It is ideal for simple 'displacement' type distortions such as when generating effects like water, waves, distorting mirrors, the bending of light, lens-like effects, or frosted or bubbles glass effects.
On the other hand, highly mathematical distortions such as 'polar', rotational, and 'perspective' distortions, or other real-world 3-d type mappings, are not easily achieved.
That is not to say it is impossible, as later we will show that you can, in fact, convert between the two styles of maps - it is just more difficult.

## Composite Displacement Operator {#composite_displace}

In the last example, the [DIY FX Operator](../transform/#fx) was used to do the displacement mapping.
Naturally this is a very slow operator.

However, the IM "`composite`" command does allow the use of a special type of image composition method "`-displace`" to do [Displacement Mapping](#displacement_maps) in a faster way.

Here is how you use it...

~~~{.skip}
composite {displacement_map}   {input_image} \
    -displace {X}x{Y}  {result}
~~~

Note the order.
The '*displacement\_map*' is given before the destination image being modified.
The '*X*' and '*Y*' values define the direction and 'maximum displacement' that will be used for 'white' and 'black' colors in the given displacement map.
You can define either one, or both values, so as to allow you to displace in any particular direction.

For example, here is the same Y displacement example we had above, but this time displaced using the "`composite`" command.

~~~
composite displace_map.jpg label.jpg  -virtual-pixel Gray \
    -displace 0x10  displaced_y.jpg
~~~

[![\[IM Output\]](displaced_y.jpg)](displaced_y.jpg)
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> :WARNING:
> If your image does not produce the same result, probably in this case no change from the input image, then you have older IM that dates from before version 6.2.8.
> Upgrade as soon as possible - see [Displacement Map Bugs](../bugs/displace/) for details.

> If you must use an IM version before this, always use the two map image form of the operator, supplying both an overlay (X displacement) image and a mask (Y displacement) image.
> See below for a 2 displacement command synopsis.

The "`composite`" "`-displace`" operator also allows you to position the overlay/mask displacement map images over a larger input or background image, according to "`-geometry`" "`-gravity`" settings, the areas not overlaid by the displacement map will be left, as is.
However,  the displacement map's offsets can still reference areas outside the overlaid part of the image, duplicating them.
However, due to a quirk in the way in which the "`composite`" "`-tile`" setting works, you may not get quite the results you expect.
It is thus not a recommended setting to use with [Displacement Mapping](#displacement_maps).

### Simple Displacement Examples {#displace_simple}

A displacement map of raw areas of colors, without any smooth transition will generaly produce disjoint (discontinuous) displacements between the different areas in the resulting image, just as you saw above.

You can, in fact, produce a displacement map that 'fractures' as if you were looking into a cracked mirror, using this technique.
For example see the [Fractured Mirror](#displace_mirror) below.

You can produce nicer and smoother results if the colors smoothly flow from one area to another.
For example, by blurring the displacement map you generate a wave-like transtion between the displaced areas...

~~~
convert displace_map.jpg  -blur 0x10   dismap_wave.jpg
composite dismap_wave.jpg label.jpg -displace 0x10 displaced_wave_y.jpg
~~~

[![\[IM Output\]](dismap_wave.jpg)](dismap_wave.jpg)  
 [![\[IM Output\]](displaced_wave_y.jpg)](displaced_wave_y.jpg)

Rather than simply displace the image in a Y direction you can also use a map to displace the image in a X direction resulting in a sort of compression wave.

~~~
composite dismap_wave.jpg label.jpg  -displace 10x0  displaced_wave_x.jpg
~~~

[![\[IM Output\]](displaced_wave_x.jpg)](displaced_wave_x.jpg)

By using the same displacement map for both X and Y directions, we can add both a compression wave as well as an amplitude wave.

~~~
composite dismap_wave.jpg label.jpg -displace 10x10 displaced_wave_xy.jpg
~~~

[![\[IM Output\]](displaced_wave_xy.jpg)](displaced_wave_xy.jpg)

Note that the image is still displaced in a single direction, resulting in the above image being stretched on the downward slope, and squeezed together on the upward slope.
That is, the distortion is at a angle or 'vector' with some horizontal as well as vertical components.

You can see that this effect is remarkably like it is underwater, with the image being distorted by gentle ripples on the water's surface.

A distortion map, however, can contain multiple copies of the original image, just as you can in a reflected or refracted images...

~~~
echo "P2 3 1 255\n 255 127 0 " | convert - -scale 150x50\! dismap_copy.jpg
composite dismap_copy.jpg label.jpg  -displace 66x0  displaced_copy.jpg
~~~

[![\[IM Output\]](dismap_copy.jpg)](dismap_copy.jpg)  
[![\[IM Output\]](displaced_copy.jpg)](displaced_copy.jpg)

You can also create mirrored flips or flops of parts of the image, by using gradients.
For example, here you can use a linear displacement map, to copy pixels from one side of the image to the other.

~~~
convert -size 50x150 gradient: -rotate -90  +matte  dismap_mirror.png
composite dismap_mirror.png label.jpg  -displace 150x0  displaced_mirror.jpg
~~~

[![\[IM Output\]](dismap_mirror.png)](dismap_mirror.png)  
[![\[IM Output\]](displaced_mirror.jpg)](displaced_mirror.jpg)

Can you figure out how this displacement map works?
As a hint, figure out what displacement the left-most and the right-most edges have, then see how the rest of the image fits into that.

However, as you are again using a gradient image, you lose the simplicity of displacement maps.
As such, mirrors are either better done using a direct [Flip Operation](../warping/#flip) on the image, or by using a [Absolute Distortion Map](#distortion_maps) instead.

Note that by flipping the gradient over, you shrink the image.

~~~
convert -size 50x150 gradient: -rotate 90  +matte  dismap_shrink.png
composite dismap_shrink.png label.jpg  -displace 150x0  displaced_shrink.jpg
~~~
  
[![\[IM Output\]](dismap_shrink.png)](dismap_shrink.png)  
[![\[IM Output\]](displaced_shrink.jpg)](displaced_shrink.jpg)

The above also demonstrates a particular problem that displacement maps have.
When an area, or all, of an image gets compressed by more than 50%, you will start to generate [Aliasing Artefacts](../filter/#aliasing).
This is particularly noticable in the staircased 'aliased' edges that is clearly visible.

As previously discussed, one solution to this is to [Super Sample](../distorts/#super_sample) the number of pixels being used to generate each output pixel.
To do that, we enlarge both the image and displacement map, then resize the resulting image back to its more normal size.
This will allow more pixels to take part in the setting of a specific pixel in the result, and thus produce a better image.

For example...

~~~
convert dismap_shrink.png  label.jpg -resize 200% miff:- |\
   composite  -   -displace 400x0  miff:- |\
   convert  -   -resize 50%   displaced_resized.jpg
~~~

[![\[IM Output\]](displaced_resized.jpg)](displaced_resized.jpg)

A much better and smoother result.

### Graphing a gradient {#displace_graph}

Directly resulting from the above examples was an idea that by using Y displacements of a simple line, you can generate a graph of the colors of a displacement map.
For example, here I generate a mathematical `sinc()` function (which is defined as '`sin(x)/x`'), and graph that gradient by using it as a displacement map...

~~~
convert -size 121x100 xc: -fx 'sin(i*24/w-12)/(i*24/w-12)/1.3+.2' \
                                                    gradient_sinc.gif
convert -size 121x100 xc: -draw 'line 0,50 120,50'     graph_source.gif
composite gradient_sinc.gif graph_source.gif \
                                     -displace 0x49   displace_graph.gif
~~~

[![\[IM Output\]](gradient_sinc.gif)](gradient_sinc.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](graph_source.gif)](graph_source.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](displace_graph.gif)](displace_graph.gif)

As you can see it works, though I wouldn't like to use it for mathematical plots.
Better to use a proper graphing package.
This technique, however, is useful as a dirty method of plotting the intensities of a row or column of pixels in an image.

What it does do is show how large differences in displacements can easily produce a discontinuity or non-smooth result.
Basically, as each individual pixel in the "graph source" is only looked at one at a time, without averaging, a large difference in the displaced lookup from one pixel to the next, can produce a large color change in the result.
The moral is that displacement work best not only with smooth displacement maps, but also with displacing images that contains large areas or shades of color.
It does not work so well for sharp thin lines.

Of course you can improve things by again [Super Sampling](../distort/#super_sample) the distort map...

~~~
convert  gradient_sinc.gif graph_source.gif -resize 400% miff:- |\
   composite  -   -displace 0x196  miff:- |\
      convert  -   -resize 25%   displace_graph_2.gif
~~~

[![\[IM Output\]](displace_graph_2.gif)](displace_graph_2.gif)

The result is a lot better, though not as good as what can be achieved using a graphing package.
Still, only ImageMagick was used in its creation.
Here is another version of the same graph, but this time using a solid color, which works a lot better than displacing a thin line.

~~~
convert -size 121x50 xc:white xc:black -append \
      gradient_sinc.gif  +swap   -resize 400% miff:- |\
composite  -   -displace 0x196  miff:- |\
  convert  -   -resize 25%   displace_graph_3.gif
~~~

[![\[IM Output\]](displace_graph_3.gif)](displace_graph_3.gif)

### Area Displacement (Linear) {#displace_areas}

Let's try a more logical displacement problem... moving an area of an image in a straight line from one location to another.

As we have seen, a 'pure gray' image will not cause any displacement, while a 'white' color will cause a positive lookup displacement from the source image.

For example, let's create such an image....

~~~
convert -size 75x75 xc:gray50 -fill white \
      -draw 'circle 37,37 37,20'  dismap_spot.jpg
~~~

[![\[IM Output\]](dismap_spot.jpg)](dismap_spot.jpg)

Now when we apply this image the contents of the area marked should have a copy of whatever appears in the direction of the given displacement value.
So, let's try a displacement value of *X*+10 and *Y*+10 or '`10x10`'...

~~~
composite dismap_spot.jpg koala.gif -displace 10x10  displace_spot.png
~~~

[![\[IM Output\]](dismap_spot.jpg)](dismap_spot.jpg) ![ +](../img_www/plus.gif) [![\[IM Output\]](koala.gif)](koala.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](displace_spot.png)](displace_spot.png)

As you can see, the contents of the marked area now contains a copy of the image that was `+10,+10` pixels to the South-East - basically an image of the koala's 'tail'.
In other words, within the circle the image was displaced North-East, or `-10,-10` pixels.
Remember the displacement is of the lookup, so the source image is shifted by a negative amount due to the [Reversed Pixel Mapping](../distort/#mapping).
The image displaces in the reverse direction!

Note also, that it is the image within the area marked that is moved.
You are not displacing the image marked, but displacing the image *INTO* the area marked.
And finally note the sharp discontinuity at the edges of the circle. Areas inside the marked area are moved, while the areas outside remain exactly as they were.

These are the facts, so they are worth repeating:

**Displacement is in the reverse to the displacement value.**

**Only the areas marked not gray will be displaced.**

**Sharp color changes produce sharp image discontinuities.**

So, let's try something more practical.
Let's move the center between the nose and eyes of the koala, located at '`32,22`', to the center of our white (full positive displacement) circle at '`37,37`'.
That needs a displacement value of '`-5,-15`' - remember it is a reversed direction...

~~~
composite dismap_spot.jpg koala.gif -displace -5x-15  displace_head.png
~~~

[![\[IM Output\]](displace_head.png)](displace_head.png)

And there we have a nicely centered copy of the central part of the koala's head.

But the image is still 'disjoint', and using a negative value is not very nice.
The solution is to use a black spot instead, but also to blur the edges of that spot.
Also let's make it larger to encompass more of the koala's head.
So here is out 'positive movement spot' image...

~~~
convert -size 75x75 xc:gray50 -fill black \
      -draw 'circle 37,37 37,17'  -blur 0x5  dismap_area.jpg
~~~

[![\[IM Output\]](dismap_area.jpg)](dismap_area.jpg)

You do not want to blur the image too much or the center of the spot will no longer be a flat black color.
Alternatively, you could just [Normalize](../color_mods/#normalize), [Reverse Level Adjust](../color_mods/#level) the image to ensure that the drawn area is black, and surrounding parts are perfect grays.
You will see this done a lot in later examples.

Now let's repeat that last 'head' displacing using our black 'fuzzy spot' displacement map.

~~~
composite dismap_area.jpg koala.gif -displace 5x15  displace_area.png
~~~

[![\[IM Output\]](displace_area.png)](displace_area.png)

As you can see, we move the image `+5,+15` into the 'fuzzy' area, but this time the border of the area is smoother and connected to the rest of the image.
Of course, the ears on the edge of the circle were distorted by the fuzzy edge, and the body of the koala compressed as well, but it is still a lot better than what we had before.

To prevent the 'tearing' of the image you see on the trailing side, or leaving copies of the displaced part, you want to expand that spot, or make a more complex gradient type of displacement image.

For example, suppose you want to move the koala's head from its starting position at '`32,22`', to the center of the image at '`37,37`', or a movement of `+5,+15` pixels, but you want to adjust the whole image to this change, to give a much smoother effect.
To do this you will want the maximum displacement of black (a positive image displacement) at '`37,37`' and displacing by a value of `+5,+15`.
But you also want to the make sure the rest of the image remains intact by 'pinning' the corners at 50% gray.
That is perfect for a [Shepard's Interpolated Sparse Gradient](../canvas/#shepards).

~~~
convert -size 75x75 xc:  -sparse-color  Shepards \
      '37,37 black   0,0 gray50  74,74 gray50  0,74 gray50  74,0 gray50' \
      dismap_move.jpg
composite dismap_move.jpg koala.gif -displace 5x15  displace_move.png
~~~

[![\[IM Output\]](dismap_move.jpg)](dismap_move.jpg) ![ +](../img_www/plus.gif) [![\[IM Output\]](koala.gif)](koala.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](displace_move.png)](displace_move.png)

As you can see, you get a larger area of displacement spread over the whole image.
The result is a much more smoothly changing image than the tighter 'spot' method used before.
This is actually exactly equivalent to the [Shepard's Distortion](../distort/#shepards) but only for one moving control point.
It is also the exact same method used in Fred Weinhaus' script '`shapemorph`', but with some animation.

**In summary:** For small localized displacements, 'blurred spot' displacements can be used.
But for larger displacements over a longer distance, a larger smooth gradient displacement map should be used to prevent tearing or duplicating the source image.

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

### Simple Displacement Morphing {#simple_morph}

~~~{.skip}
Modifying the Size of Displacement Vectors

Two Image Morphing

Random 1D Displacements
~~~

### Rippled Water Reflections {#water_ripples}

As mentioned before, displacement maps are especially useful for generating water and glass-like distortions.

~~~{.hide}
convert flower_md.jpg -resize 150x -crop 150x80+0+0 flower.jpg
~~~

[![\[IM Output\]](flower.jpg)](flower.jpg)

For this example, I generated a small image by [Cropping](../crop/#crop) a flower image.
Now I want to make it look like it is sitting on some rippled water.

To generate ripples, I need a sine wave gradient of the same size which I can generate using the [Evaluate Sin Function](../transform/#evaluate_cos).
The number '`8`' represents the number of 'waves' that will be added to the gradient.

~~~
convert -size 150x80 gradient:  -evaluate sin 8  wave_gradient.png
~~~

[![\[IM Output\]](wave_gradient.png)](wave_gradient.png)

Now let's distort that image using an angled displacement vector, not just a simple vertical or horizontal distortion, so as to give it more emphasis.

~~~
composite wave_gradient.png  flower.jpg -displace 5x5 flower_waves.png
~~~

[![\[IM Output\]](flower_waves.png)](flower_waves.png)
  
Now that does not seem very interesting, but what if you flip that image, compress it vertically and append it to the original...

~~~
convert flower_waves.png -flip \
      flower.jpg  +swap -append  flower_waves_2.png
~~~

[![\[IM Output\]](flower_waves_2.png)](flower_waves_2.png)

Unfortunately, it still looks rather artificial.
The reason is that the reflection looks the same at both the top and bottom of the image.
It has no sense of 'depth' to it.
The reflection is also the same brightness as the original image which is rarely the case.

To make it more realistic you need to use a ripple pattern that varies in intensity.

The following uses some fancy [Gradient Mathematics](../transform/#gradient_math) to 'attenuate' the wave gradient we were using above.
That is, we made the wave pattern linearly smaller as it goes from top to the bottom.
This trickiness ensures that the waves finishes at the pure-gray or 'no displacement' color at the bottom of the image (which is later flipped).

~~~
convert -size 150x80 gradient: \
      \( wave_gradient.png \
     +clone -compose multiply -composite \) \
      \( -clone 0 -negate -evaluate divide 2 \
     -clone 1 -compose plus -composite \) \
      -delete 0-1      waves_decreasing.png
~~~

[![\[IM Output\]](waves_decreasing.png)](waves_decreasing.png)
  
So, let's apply this gradient, to form a new reflection of the flower.
I also darkened the reflected image slightly to represent some light being lost into the water itself, making it seem more like a water reflection.

~~~
composite waves_decreasing.png  flower.jpg \
    -displace 8x8 miff:- |\
   convert miff:-   -flip   +level 0,80% \
    flower.jpg  +swap -append   flower_in_water.png
~~~

[![\[IM Output\]](flower_in_water.png)](flower_in_water.png)

Note that as the distorted image is [Flipped](../warping/#flip) to form a reflection, the image will have less 'ripples' at the top of the 'water' closest to where it joins the original image, than at the bottom.
This gives the distortion a sense of distance from the viewer.

You can make it even more realistic by distorting the wave displacement maps with a slight rotation, arc, or just with 'random' displacements.
This will give the waves a more natural look, though it is better to do it before it is 'attenuated' so that the 'depth' is added afterward.
Try it, experiment, and let me know what you come up with.

~~~{.skip}
Animated Ripples -
  Using -function Sinusoid with phase changing

End with a polar-depolar version
~~~

------------------------------------------------------------------------

## 2-Dimensional Displacement Mapping {#displace_2d}

So far, all the displacement maps have only displaced the image in a single direction, though that direction can be at any angle by setting the appropriate '`XxY`' displacement value or 'vector'.

However, you can produce a much more complex displacement by using two distinct displacements for both the X and Y directions separately.
By doing this, each part of the image can move in completely different directions to each other.

However the "`composite`" command to this is is a little more complex.

~~~{.skip}
composite {X displacement} {input image} {Y displacement}+ \
    -displace {X}x{Y}    {result+}
~~~

Note the input image order.
It is caused by the need to abuse the "`composite`" option handling, and historical reasons.
It is vital you get this correct.
I am hoping to implement a nicer "`convert`" method for displacement mapping soon
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> :WARNING:
> Before IM v6.4.4 using 2 separate displacement maps for separate X and Y displacements was a hit or miss affair.
> It sometimes worked, and sometimes did not.
> It is not recommended to attempt to even try to use it on IM's older than this version.

### Cylindrical Displacement {#displace_cylinder}

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

~~~
convert rose: -background black -gravity south -splice 0x8 \
      \( +clone -sparse-color barycentric '0,0 black 69,0 white' \) \
      \( +clone -function arcsin 0.5 \) \
      \( -clone 1 -level 25%,75% \
         -function polynomial -4,4,0 -gamma 2 \
         +level 50%,0 \) \
      -delete 1 -swap 0,1  miff:- |\
  composite - -virtual-pixel black  -displace 17x7  rose_cylinder.png
~~~

[![\[IM Output\]](rose_cylinder.png)](rose_cylinder.png)

The above is very complex, but in essence, two separate displacements are being performed simultaneously - an X compression and a Y Displacement.

The key to remember is that the two map displacement control the lookups of both X and Y values.

I will annotate...

~~~{.skip}
rose:
      the image to wrap around the front half of a cylinder

-background black -gravity south -splice 0x8 \
      add extra space at the bottom for vertical displacement

\( +clone -sparse-color barycentric '0,0 black 69,0 white' \) \
      generate a gradient across the actual image part only
      which is 70 pixels wide

\( +clone -function arcsin 0.5 \) \
      generate the horizontal distortion needed - dead simple

\( -clone 1 -level 25%,75% -function polynomial -4,4,0 \
             -gamma 2 +level 50%,0 \) \
   generate a vertical displacement circular arc
   This is also very complex, so...
     -level 25%,75%
          compress gradient into 50% width
           that will be produced by the arcsin
     -function polynomial -4,4,0  -gamma 2
           the gamma 2 is equivalent to sqrt
           making the above   sqrt( -4u^2 + 4u )
     +level 50%,0
           set the displacement gradient so edges are not
           displaced, and center has black (move image down) displace

-delete 1 -swap 0,1  miff:- |\
     remove working gradient image, and get order correct for composite
      EG:    composite  X-map  image  Y-map  -displace XxY result

composite - -displace 17x7 show:
     Read in the three images, and displace the image.
     the value  17 = 1/4 width  for horizontal arcsin displacement
     and a vertical circular arc of 7 pixels (about 1/8 the original width)
     giving a rough 30 degree isometric view of cylinder

Result...  a rose wrapped correctly into a cylinder
~~~

This displacement distortion method has been built into the "`cylinderize`" script by Fred Weinhaus.

### Fractured Mirror {#displace_mirror}

You can create a 'fractured mirror' look to an image by generating random areas of X and Y displacements.

~~~
convert dragon_sm.gif -sparse-color voronoi '  \
          %[fx:rand()*w],%[fx:rand()*h]  red
          %[fx:rand()*w],%[fx:rand()*h]  lime
          %[fx:rand()*w],%[fx:rand()*h]  black
          %[fx:rand()*w],%[fx:rand()*h]  yellow
       ' -interpolate integer -implode 1     mirror_areas.gif
convert   mirror_areas.gif -channel R  -separate   mirror_dismap_x.gif
convert   mirror_areas.gif -channel G  -separate   mirror_dismap_y.gif

composite mirror_dismap_x.gif  dragon_sm.gif  mirror_dismap_y.gif +matte \
    -background white -virtual-pixel background -displace 7 \
                            mirror_displaced.gif

convert   mirror_areas.gif -edge 1 -threshold 20% \
    -evaluate multiply .7 -negate               mirror_cracks.gif
composite mirror_displaced.gif  mirror_cracks.gif -compose multiply \
                            mirror_cracked.gif
~~~

[![\[IM Output\]](mirror_areas.gif)](mirror_areas.gif) ![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](mirror_dismap_x.gif)](mirror_dismap_x.gif) [![\[IM Output\]](dragon_sm.gif)](dragon_sm.gif) [![\[IM Output\]](mirror_dismap_y.gif)](mirror_dismap_y.gif) ![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](mirror_displaced.gif)](mirror_displaced.gif) [![\[IM Output\]](mirror_cracks.gif)](mirror_cracks.gif)
  
![==&gt;](../img_www/right.gif) [![\[IM Output\]](mirror_cracked.gif)](mirror_cracked.gif)

Four randomly displaced areas are generated using a randomized [Voronoi Sparse Color](../canvas/#voronoi) image.
This is then given an [Implosion Distortion](../warping/#implode) to warp those areas into the center of the image.
As each of the four colored areas remain solid colors, each area will contain an undistorted, but displaced copy of the original image.
However, each area will have displaced the image in a different way, just as each shard of a fractured mirror would.
To finish off the mirror, [Edge Detection](../transform/#edge) is used to outline the edges of the regions and thus the fractured nature of the resulting image.
That is, the cracks are also made visible.

Of course, if I can find a better method of generating a more 'broken-like' displacement map, then the results of the above will also be a lot better.
Ideas anyone? Mail me.

### Shepards Displacement {#shepards}

### Random Displacements {#random}

### Lensing Effects {#lensing}

### Frosted Glass Effects {#frosted_glass}

### Dispersion Effects (rotated displacements) {#dispersion}

### Dispersion Effects with Randomized Displacement {#dispersion_displace}

------------------------------------------------------------------------

FUTURE: Other possible distort / displace mapping examples

-   Raytrace a gradient onto 3D objects so that later ANY image can be be mapped onto those objects.
    -   X and Y gradient mapped images
    -   Pure Gray Image for color, highlights and shading

---
title: Image Mapped Effects
created: 14 January 2009 (distorts sub-division)  
updated: 25 December 2009  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.7-7
url: http://www.imagemagick.org/Usage/mapping/
---
