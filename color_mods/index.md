# Color Modifications

**Index**
[![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
[![](../img_www/granitesm_right.gif) Converting Color to Gray-Scale](#grayscale) ![](../img_www/space.gif)
[![](../img_www/granitesm_right.gif) Image Level Adjustments](#levels) ![](../img_www/space.gif)
-   [Negating Images](#negate) (reversing black and white)
-   [Level Adjustment Operator](#level) (contrast and black/white adjustment)
-   [Reversed Level Adjustments](#level_plus) (de-contrasting)
-   [Gamma Level Adjustment](#level_gamma) (mid-tone adjustments)
-   [Gamma Operator Adjustment](#gamma) (gamma without level adjustments)
-   [Level Adjustments by Color](#level-colors) (adjust image levels using colors)
-   [Sigmoidal Non-linearity Contrast](#sigmoidal) (non-linear contrast adjustment)
-   [Miscellaneous Contrast Adjustments](#contrast_misc)

[![](../img_www/granitesm_right.gif) Adjustments Using Histogram Modification](#histogram) ![](../img_www/space.gif) (changing the histogram an image)
-   [Linear Histogram Stretching](#stretching)
-   [Normalize](#normalize) (auto-level stretching)
-   [Contrast Stretch](#contrast-stretch) (controlled stretching)
-   [Linear-Stretch](#linear-stretch) (alternative stretching)
-   [Histogram Redistribution](#hist_redist)
-   [Equalize](#equalize) (uniform histogram redistribution)
-   [Gaussian Redistribution](#gaussian_redist)
-   [Histogram Redistribution Methodology](#redist_method)

[![](../img_www/granitesm_right.gif) DIY Level Adjustments](#diy_levels) ![](../img_www/space.gif) (general tinting operators)
-   [DIY Mathematical Linear Adjustments](#linear)
-   [Mathematical Non-linear Adjustments](#non-linear)
-   ['Curves' Adjustments](#curves)

[![](../img_www/granitesm_right.gif) Tinting Midtones of Images](#tinting) ![](../img_www/space.gif) (general tinting operators)
-   [Uniform Color Tinting](#colorize)
-   [Midtone Color Tinting](#tint)
-   [Sepia Tone Coloring](#sepia-tone)
-   [Duotone Effect](#duotone)
-   [Color Tinting, DIY](#tint_diy)
-   [Color Tinting Overlay](#tint_overlay)

[![](../img_www/granitesm_right.gif) Global Color Modifiers](#color_mods)
-   [Modulate Brightness, Saturation, and Hue](#modulate)
-   [Modulate the Hue Color Cycle](#modulate_hue)
-   [Modulate DIY](#modulate_diy)
-   [Modulate in Other Colorspaces](#modulate_colorspace)
-   [Modulate in HCL Colorspace (from LUV)](#modulate_HCL)
-   [Color Matrix Operator](#color-matrix)
-   [Solarize Coloring](#solarize)

[![](../img_www/granitesm_right.gif) Recoloring Images with Lookup Tables](#color_lut) ![](../img_www/space.gif)
-   [Color Lookup Tables](#clut)
-   [Function to Color LUT conversion](#fx_to_lut)
-   [CLUT and Transparency Handling](#clut_alpha)
-   [Hald 3D Color Lookup Tables](#hald-clut)
-   [Hald CLUT Limitations](#hald_limits)
-   [Color Replacement using Hald CLUT](#hald_replacement)
-   [Full Color Map Replacement](#replace_colormap) (no solution, just ideas)

Here we look at techniques for modifying all the colors in an image as a whole. Whether it is to lighten or darken the image, or more drastic color modifications.
  
To explore these technqiues we will need a test image...  
 Don't worry above how I actually generated this image, it is not important for the exercise. I did design it to contain a range of colors, transparencies and other features, specifically to give IM a good workout when used.
  
[![\[IM Output\]](test.png)](test.png)
*If you are really interested in the commands used to generate this image you can look at the special script, "`generate_test`", I use to create it.*
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
*WARNING: The color processes below generally assumes the image is using a linear colorspace. Most images are however saved using a sRGB or Gamma corrected colorspace, as such to get things right colorspace correction should also applied first.*

------------------------------------------------------------------------

## Converting Color to Gray-Scale

Gray scale images can be very useful for many uses, such as, furthering the processing of the original image or for use in background compositions. The best method of converting an image to gray-scale is to just ask IM to convert the image into a gray-scale [Color Space](../color_basics/#colorspace) representation for the image.
  
      convert  test.png  -colorspace Gray   gray_colorspace.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](gray_colorspace.png)](gray_colorspace.png)

Note how the blue is much darker than the red, due the weighting to match the intensity as they seem to appear to the human eye. That is, '`red`' is quite a bright color compared to '`blue`' which looks darker.
  
This is equivelent to the use of the '`rec709luma`' conversion formula with the dedicated "`-grayscale`" operator (Added IM v6.8.3-10).
  
      convert test.png  -grayscale rec709luma  gray_grayscale.png

  
[![\[IM Output\]](gray_grayscale.png)](gray_grayscale.png)
The '`rec709luma`' value is just one of many greyscaling formula that has been defined for use by the "`-intensity`" setting (see below).
  
Here for example is the other common greyscaling formula '`rec601luma`'
  
      convert test.png  -grayscale rec601luma  gray_grayscale_601.png

  
[![\[IM Output\]](gray_grayscale_601.png)](gray_grayscale_601.png)
As you can see there is a slight different in intensity levels for the different red, green and blue color channels.
  
 However there a many other methods, and meanings of 'gray-scale'...
  
For example, you can drain all the color out of the image by using the [Modulate Operator](#modulate), to set all color saturation levels to zero.
  
      convert test.png  -modulate 100,0  gray_modulate.png

  
[![\[IM Output\]](gray_modulate.png)](gray_modulate.png)
This essentually converts the image to the HSL colorspace, and extracts the grayscale '`Lightness`' value from that colorspace. However using a "`-define modulate:colorspace`" you can specify other colorspace models to use. See [Modulate in Other Colorspaces](#modulate_colorspace) below.
Note how the IM '`green`' color I used for the center colored disk in my test image is not actually a pure green, such as used in the colored rainbow, but the half-bright green defined by the new [SVG -- Scalable Vector Graphics](http://www.w3.org/TR/SVG12/) standard. If you need a pure RGB green you can use the color '`lime`' instead. See [Color Name Conflicts](../color_basics/#color_conflicts) for more detail.
  
Another way is to use the [FX DIY operator](../transform/#fx) to average the three channels together to get a pure mathematical meaning of gray-scale.
  
      convert test.png -fx '(r+g+b)/3' gray_fx_average.png

  
[![\[IM Output\]](gray_fx_average.png)](gray_fx_average.png)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The average of sRGB channel values also equivelent to the intensity channel of '`OHTA`' colorspace (red channel). Or the 'I' channel of HSI. colorspace.*
  
Another technique is to simply add all three channels together (a color measure known as manhatten distance) and while the resulting image will not loose information due to 'quantum rounding' effects, you may loose information about the brightest colors. Unfortunately, you also loose the transparency channel, too.
  
      convert test.png -separate \
              -background black -compose plus -flatten   gray_added.png

  
[![\[IM Output\]](gray_added.png)](gray_added.png)
  
You can use the same adding channels technique to control the weighting of the individual color channels. For example this is one DIY formula that you can use...
  
      convert test.png -fx '0.3*r+0.6*g+0.1*b' gray_diy.png

  
[![\[IM Output\]](gray_diy.png)](gray_diy.png)
  
You can also use 'intensity' if you want the same meaning within the "`-fx`" operator.
  
      convert  test.png  -fx intensity  gray_intensity.png

  
[![\[IM Output\]](gray_intensity.png)](gray_intensity.png)
  
However as the [FX DIY operator](../transform/#fx) is interpreted, it can run very very slowly. For more complex operations you can use the simpler [Evaluate Operator](../transform/#evaluate), "`-evaluate`".
For example here is a 2/5/3 ratio gray-scaled image, though again I make no attempt to preserve the transparency channel of the original image.
  
      convert test.png -channel R -evaluate multiply .2 \
                       -channel G -evaluate multiply .5 \
                       -channel B -evaluate multiply .3 \
                       +channel -separate -compose add -flatten gray_253.png

  
[![\[IM Output\]](gray_253.png)](gray_253.png)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
The above would suffer from 'quantization' effects for a ImageMagick compiled at a 'Q8' [Quality Level](../basics/#quality). That is because the results of the "`-evaluate`" will be saved into a small 8 bit integer, used for image values. Only later are those values added together with the resulting loss of accuracy.
  
An ImageMagick compiled with 'Q16', or better still the [HDRI](../basics/#hdri), quality compile options will produce a much more exact result. Another new alternative is the [Poly - Weighted Image Merging Operator](../layers/#poly), which will do the weighting and addition of the separated channel images in one operation, so avoiding 'quantum rounding' effects.
  
A similar technique can be used to generate a pure mathematical gray-scale, by directly averaging the three RGB channels equally.
  
      convert test.png -separate -average  gray_average.png

  
[![\[IM Output\]](gray_average.png)](gray_average.png)
However as you can see, I did not attempt to preserve the alpha channel of the resulting image.
Another fast alternative is to use the "`-recolor`" color matrix operator, which will let you specify the weighting of the three color channels.
  
      convert test.png -recolor '.2 .5 .3
                                 .2 .5 .3
                                 .2 .5 .3'   gray_recolor.png

  
[![\[IM Output\]](gray_recolor.png)](gray_recolor.png)
This doesn't affect transparency, but makes it a much better way of converting colors using a specific weighting.
Basically the first row of numbers is the channel weighting for the resulting images red channel, next 3 for green, and the final three numbers for blue.
  
You can also use "`-type`" to tell IM to treat the image as gray-scale, when either reading or writing the image.
  
      convert  test.png  -type GrayScaleMatte  gray_type.png

  
[![\[IM Output\]](gray_type.png)](gray_type.png)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The "`-type`" setting is generally only used as a guide when an image is being read or written to a file. As such its action is delayed to the final write of the image. Its effect is also highly dependant on the capabilities of the image file format involved and is used to override ImageMagick's normal determination during that process. See the [Type](../basics/#type) examples for more information.*
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.3.5-9 the above will have removed any transparency in the written image (equivalent of a "`-type Grayscale`") due to a bug. This was fixed as soon as I noted the problem and reported it. (There is a lesson here :-)*
  
 A much more interesting technique is to extract a variety of different meanings of brightness by extracting the appropriate [Color Channel](../color_basics/#channel) from various [Colorspace](../color_basics/#colorspace) representations of the image. Examples see [Grayscale Channels from Colorspace Representations](../color_basics/).
  

------------------------------------------------------------------------

## Image Level Adjustments

The most basic form of adjustment you can make to images are known as 'level' adjustments. This basically means taking the individual RGB color values (or even the alpha channel values) and adjusting them so as to either stretch or compress those values.
As only channel values are being adjusted, they are best demonstrated on a gray-scale image, rather than a color image. However if you adjust all the color channels of an image by the same amount you can use them with color images, for the purposes of either enhancing, or adjusting the image. Do not confuse this with the more automatic form of level adjustments, which we will look at in the next major section of examples below, [Normalize Adjustments](#normalize). This function will do exactly the same operation regardless of the actual content of the image. It does not matter if the image is bright, or dark, or has a blue, or yellow tint. The operations are blind to the actual image content.
![\[IM Graph\]](gp_noop.gif) In demonstrating these operations I will be using a modified "`gnuplot`" graph such as shown to the right, which I generate using a special script "`im_graph`". The graph has a red line which maps the given original 'x' value (representing the gray-scale value of the top most gradient) to the 'y' value shown. The resulting color gradient is also shown underneath the input linear gradient.
The graph shown to right is of the IM "`-noop`" operator which actually does nothing to an image. As such each of the image's color values are just mapped to exactly the same value without change. The lower gradient is thus the same as the upper gradient.
### Image Negation

The simplest and most basic global level adjustment you can make is to negate the image, using the "`-negate`" image operator.
Essentially this makes   white, black,   and   black, white,  , adjusting all the colors to match. That is, it will make the color red, its complementary color of cyan,   and blue, yellow, etc.
You can see this with the mapping graph shown below, as I use the "`-negate`" operator on both the 'test' image and the standard IM 'rose' built-in image. Note how the lower gradient in the mapping graph image is now reversed, so that black and white are swapped, and the same reversal appearing in the negated 'test' image.
  
      convert  test.png  -negate  test_negate.png
      convert  rose:     -negate  rose_negate.gif

  
[![\[IM Output\]](test.png)](test.png)  
 [![\[IM Output\]](rose.png)](rose.png)
  
![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_negate.gif) ![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](test_negate.png)](test_negate.png)  
 [![\[IM Output\]](rose_negate.gif)](rose_negate.gif)

Internally negate is actually rather stupid. It handles the three color channels independently, and by default ignores the alpha channel. If this was not the case, you would get a very silly result like this...
  
      convert  test.png -channel RGBA  -negate  negate_rgba.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](negate_rgba.png)](negate_rgba.png)

The image is negated, as you can see by the semi-transparent color gradient. But as the transparency channel has also been negated you loose all the opaque colors in the image. This is why the default setting for "`-channel`" is '`RGB`'. See [Color Channels](../color_basics/#channels) for more information.
You can limit the negation to just one channel, say the green color channel. This may not seem very useful, but at times it is vitality important.
  
      convert  test.png -channel green  -negate  negate_green.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](negate_green.png)](negate_green.png)

The "`-negate`" operator is actually its own inverse. Doing two negations with the same "`-channel`" setting cancels each other out.
  
      convert  negate_green.png  -channel green  -negate  negate_restore.png

[![\[IM Output\]](negate_green.png)](negate_green.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](negate_restore.png)](negate_restore.png)

Negation is extremely common in image processing, particularly when dealing with gray-scale images as a step before or after other processing options. As such I recommend you play with it and keep it in mind whenever you are doing anything, as working with negated images can solve some otherwise difficult problems.
### Direct Level Adjustments

The "`-level`" operator is the more general level adjustment operator. You basically give it two values a 'black\_point' and a 'white\_point', as well as an optional third value (gamma adjustment), which I will look at [later](#level_gamma).
What it does is map any color values in the image that is equal to or less than the 'black\_point', and make them black (or a 0 value). Similarly, any color values that are equal to or brighter that the 'white\_point' will make them white (or a Maximum value). The colors in between these two points are then 'stretched' linearly to fill the complete range of values.
The effect of this is to improve the contrast, enhancing the colors within an image. For example here is a 25% contrast enhancement of our test image, using the same values as shown by the graph.
As you commonly adjust both the black and white points by the same amount from the `0%` and `100%` amounts, you can just specify the 'black\_point' only. The white point will be adjusted by the same amount inward.
  
      convert  test.png  -level 25%,75%  test_level.png
      convert  rose:     -level 25%      rose_level.gif

  
[![\[IM Output\]](test.png)](test.png)  
 [![\[IM Output\]](rose.png)](rose.png)
  
![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_level.gif) ![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](test_level.png)](test_level.png)  
 [![\[IM Output\]](rose_level.gif)](rose_level.gif)

Note that `25%` is a huge contrast enhancement for any image, but it clearly shows what it does.
You don't have to change both the 'black' and 'white' points. Instead it is quite permissible to just adjust only one end of the color range. For example we can make a very light, or a very dark rose image.
  
      convert  rose:  -level 0,75%     rose_level_light.gif
      convert  rose:  -level 25%,100%  rose_level_dark.gif

![\[IM Graph\]](gp_level_lt.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_level_light.gif)](rose_level_light.gif) ![](../img_www/space.gif) ![\[IM Graph\]](gp_level_dk.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_level_dark.gif)](rose_level_dark.gif)

However I again warn you that the colors outside the given range are 'clipped' or 'burned', and as such will no longer be available for later image processing. This is the biggest problem with using a "`-level`" operator.
![\[IM Graph\]](gp_level-.gif) By using a negative value you can do some rough de-contrasting of an image.
What this means is that rather than providing a color value for the values to be mapped to 'black' and 'white' and thus stretching out the colors in between, you instead compress the color values so as to map the imaginary negative color to black or white. The result is a general graying of the image.
  
      convert  rose:  -level -25%  rose_decontrast.gif

  
[![\[IM Output\]](rose_decontrast.gif)](rose_decontrast.gif)
  
 This method of de-contrasting an image however is very inaccurate and not recommended, unless you have a IM older than version 6.4.2 where you don't have access to the new [Reversed Level Operator](#level_plus). ![\[IM Graph\]](gp_level_neg.gif)
You can use the "`-level`" operator to negate an image (as previously shown above, just by swapping the 'black' and 'white' point values given, using "`-level 100%,0`".
  
      convert  rose:  -level 100%,0  rose_level_neg.gif

  
[![\[IM Output\]](rose_level_neg.gif)](rose_level_neg.gif)
  
 ![\[IM Graph\]](gp_level_thres.gif) Or by setting them to the same value, you can effectively call all the color values in the image to be thresholded. Using "`-level`" to threshold an image is exactly the same as if you used a [Threshold Operator](../quantize/#threshold) with that value. The mapping graph shown right, shows the results of a "`-level 50%,50%`" operation, and its effect on a grayscale gradient.
  
      convert  rose:  -level 50%,50%  rose_level_thres.gif

  
[![\[IM Output\]](rose_level_thres.gif)](rose_level_thres.gif)
  
 Note that unlike "`-threshold`" the image is not automatically converted to a grayscale image when used with the default "`-channel`" setting.
The general nature of using level to linearly modify an image, makes the "`-level`" operator good for general gray-scale image modifications, and mask adjustments. Add the fact that you can modify individual channels (using the "`-channel`" setting) as opposed to the whole image, makes it one of the best color modification operators available to IM users.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*Note you can also use the [Evaluate and Function Operators](../transform/#evaluate) for a more direct mathematical modification of the color values, to achieve the same results for -level both + and - forms).*
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Be warned that the "`-level`" operator treats the transparency channel as 'matte' values. As such 100% is fully transparent and 0% is opaque. Please take this into account when using "`-level`" with a blurred shape image. This is most typically done after blurring an 'shape' image, to expand and stretch the results. For examples of this see [Soft Edges](../thumbnails/#soft_edges), and [Shadow Outlines](../blur/#shadow_outline).*
### Reversed Level Adjustments -- Decontrasting Images

As of IM version 6.4.2 the [Level Operator](#level) was expanded to provide a 'reversed' form "`+level`" (note the 'plus'). Alternatively you can use the original "`-level`" form of the operator but add a '`!`' to the level argument given (for older API interfaces).
The arguments for this variant is exactly the same, but instead of stretching the values so as to map the 'black\_point' and 'white\_point' to 'black' and 'white', it maps 'black' and 'white' to the given points. In other words "`+level`" is the exact reverse of "`-level`".
For example here we map 'black' to a 25% gray, and white to 75% gray, effectively de-contrasting the image in a very exact way, using the two methods of specifying the 'reversed' form.
  
      convert  test.png   +level 25%    test_level_plus.png
      convert  rose:      -level 25%\!  rose_level_plus.gif

  
[![\[IM Output\]](test.png)](test.png)  
 [![\[IM Output\]](rose.png)](rose.png)
  
![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_level+.gif) ![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](test_level_plus.png)](test_level_plus.png)  
 [![\[IM Output\]](rose_level_plus.gif)](rose_level_plus.gif)

If you compare the above "`+level 25%`" operation with the use of a a negative de-contrasting, "`-level -25%`" operator we showed previously, you will see that are not the same. The 'plus' version produces a much stronger de-contrasted image (it is greyer), but does so by mapping to the exact values you give the operator, and not the 'imaginary' values the 'minus' form used. This exact value usage is important, and one of the reasons why the 'plus' form of the operator was added.
Of course a '`25%`' is again a very large value, and it is not recommended for use with typical image work.
Note that the "`-level`" and "`+level`", are in actual fact the exact reverse of each other when given the same argument. That is, one maps values to the range extremes, while the other maps from the range extremes.
For example here we compress the colors of the test image using "`+level`", then decompress them again using "`-level`", so as to restore the image close to its original appearance.
  
      convert  test.png  +level 20%  -level 20%  test_level_undo.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_level_undo.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](test_level_undo.png)](test_level_undo.png)

The two images appear to be very very similar, and as I am using a high [quality](../basics/#quality) 'Q16' version of IM, you will be hard pressed to notice any difference at all. However the values may not be exactly the same, as you have effectively compressed the color values of the image to a smaller range of integers, and then restored them again. In extreme cases this can result in [Quantum Rounding Effects](../basics/#quantum_effects).
Doing these two operations in the opposite order (stretch, then compress the color values) will produce [Quantum Clipping Effects](../basics/#quantum_effects).
One other useful aspect of the "`+level`" operator is that you can completely compress all the color values in an image to the same gray-scale level.
  
      convert  test.png  +level 30%,30%  test_level_const.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_level_const.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](test_level_const.png)](test_level_const.png)

By specifying levels according to the values of specific colors for each individual channel, you can effectively convert a greyscale gradient into a specific color gradient. However this is rather difficult to calculate and do. As such a "`-level-colors`" operator has also been provided that will let you specify the black and white points in terms of specific colors rather than 'level' values. See [Level by Color](#level-colors) below.
### Level Gamma Adjustments

Both the above "`-level`" variants also allow you to use a third setting. The 'gamma' adjustment value. By default this is set to a value of `1.0`', which does not do any sort of mid-tone adjustment of the resulting image, producing a pure linear mapping of the values from the old image to the new image.
However by making this value larger, you will curve the resulting line so as to brighten the image, while shrinking that value will darken the image.
For example here I use just the 'gamma' setting to brighten and darken just the mid-tones of the image.
  
      convert  rose:  -level 0%,100%,2.0   rose_level_gamma_light.gif
      convert  rose:  -level 0%,100%,0.5   rose_level_gamma_dark.gif

![\[IM Graph\]](gp_level_glt.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_level_gamma_light.gif)](rose_level_gamma_light.gif) ![](../img_www/space.gif) ![\[IM Graph\]](gp_level_gdk.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_level_gamma_dark.gif)](rose_level_gamma_dark.gif)

Values generally range from 10 for a blinding bright image, to .2 for very dark image. As mentioned a value of `1.0` will make no 'gamma' changes to the image. However the special value of '`2.0`' (see above) can be used to get the square root of the images normalized color.
Both versions of the "`-level`" operate handles 'gamma' in the same way. This means you can combine the level adjustment of the 'black' and 'white' ends with a non-linear 'gamma' adjustment. You can also only adjust a single channel of an image. For example, here we give an image a subtle tint at the black end of just the blue channel, while using gamma to preserve the mid-tone color levels of the image.
  
      convert  test.png  -channel B +level 25%,100%,.6 test_blue_tint.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_level_blue.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](test_blue_tint.png)](test_blue_tint.png)

This specific example could be used to tint a weather satellite photo, where only the sea is pure black, while land is more grey. Other alternatives to this blue channel adjustment are given below in [DIY Mathematical Non-linear Adjustments](#non-linear).
### Gamma Operation Adjustments

The "`-gamma`" operator is also provided, and has exactly the same effect as the 'gamma' setting in the "`-level`" operator. However it will let you adjust the 'gamma' adjustment level for each individual channel as well.
Its real use is in adjusting the 'gamma' function of an image before performing linear operations on them. For more details see [Human Color Perception and Gamma Correction](../color_basics/#perception).
We can also use this function to brighten the image differently for each individual RGB channel.
  
      convert  rose:  -gamma 0.8,1.3,1.0  gamma_channel.gif

  
[![\[IM Output\]](gamma_channel.gif)](gamma_channel.gif)
As you can see this can be used to do some subtle tinting and color adjustments to an image, or correct images with contain too much of a specific color.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
For reasons about why you should used this function see [Gamma Correction](../color_basics/#gamma).
This function actually equivelent to the [Evaluate POW function](../transform/#evaluate_pow) but with the argument inverted. As such a "`-evaluate POW 2.2`" will actually do a "`-gamma 0.45455`" (0.45455 is equal it 1/2.2) operation, which is the reverse of a "`-gamma 2.2`".
  
 One of the less obvious uses of "`-gamma`" is to zero out specific image channels (see [Zeroing Color Channels](../color_basics/#zeroing)). Or color an image completely 'black', 'white' or some other primary color (see [Primary Colored Canvases](../canvas/#color_misc)).
### Level Adjustment by Color

The "`-level-colors`" operator was added to IM v6.2.4-1. Essentially, it is exactly the same as the [Level Operator](#level) we discussed above, but with the value for each channel specified as a color value.
That is, the "`-level-colors`" option will map the given colors to 'black' and 'white' and stretching all the other colors between them linearly. This effectively removes the range of colors given from the image.
And while this works, it is not particularly useful, as it is prone to fail for colors that have common values in some channel. For example, the colors '`DodgerBlue`' and '`White`' have the same color values in the blue channel. As such, "`-level-colors DodgerBlue,White`" may not always convert those colors to black and white.
The better technique in that case is to extract a greyscale image of the channel with the highest differences (such as red) and level or normalize that channel.
WARNING: watch out for 'transparent' colors.
  
 The plus form of the operator "`+level-colors`" on the other hand is extremely useful as it will map the 'black' and 'white' color to the given values compressing all the other colors linearly to fit the two colors you give.
For example lets map '`black`' and '`white`' to '`green`', and '`gold`'...
  
      convert  test.png  +level-colors green,gold   levelc_grn-gold.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](levelc_grn-gold.png)](levelc_grn-gold.png)

As you can see the grayscale gradient is remapped into a gradient bound by the colors given, and although colors outside a gray-scale range are also modified, they will also follow the basic style of the color range specified. This makes the "`+level-colors`" operator an extremely useful one, especially when mapping grayscale images.
If you only supply one colorname but include a comma, the missing color will default either to '`black`' or '`white`' as appropriate.
  
      convert test.png  +level-colors ,DodgerBlue   levelc_dodger.png
      convert test.png  +level-colors ,Gold         levelc_gold.png
      convert test.png  +level-colors ,Lime         levelc_lime.png
      convert test.png  +level-colors ,Red          levelc_red.png

      convert test.png  +level-colors Navy,         levelc_navy.png
      convert test.png  +level-colors DarkGreen,    levelc_darkgreen.png
      convert test.png  +level-colors Firebrick,    levelc_firebrick.png

[![\[IM Output\]](levelc_dodger.png)](levelc_dodger.png) [![\[IM Output\]](levelc_gold.png)](levelc_gold.png) [![\[IM Output\]](levelc_lime.png)](levelc_lime.png) [![\[IM Output\]](levelc_red.png)](levelc_red.png)  
 [![\[IM Output\]](levelc_navy.png)](levelc_navy.png) [![\[IM Output\]](levelc_darkgreen.png)](levelc_darkgreen.png) [![\[IM Output\]](levelc_firebrick.png)](levelc_firebrick.png)

This makes it easy to convert grayscale images into a gradient for any color you like. For example here I remap a black and white gradient to a red and white gradient, (note the ',' in the argument)...
  
      convert cow.gif   +level-colors red,   cow_red.gif

[![\[IM Output\]](cow.gif)](cow.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](cow_red.gif)](cow_red.gif)

This didn't just replace 'black' with 'red' but also re-mapped all the anti-aliased gray colors to an appropriate mix of 'red' and 'white', producing a very smooth result. [![\[IM Output\]](../color_basics/cow_replace_red.gif)](../color_basics/cow_replace_red.gif)
If I had just performed a simple [Direct Color Replacement](../color_basics/#replace) converting pure black colors to red, I would end up with the horrible image (showen right). See [Fuzz Factor](../color_basics/#fuzz) for the example used to generate that image.
Of course if you want one of the colors to be made transparent instead you are better off using the [-alpha Shape](../masking/#alpha_shape) operator instead, as this requires you to transfer the gradient into the alpha channel.
  
 If you only specify a single color, without any 'comma' separator, that color will be used for both black and white points. That means all the colors in the image will be reset to that one color. (according to the current "`-channel`" setting limitations).
  
      convert  test.png  +level-colors dodgerblue  levelc_blue.png

  
[![\[IM Output\]](levelc_blue.png)](levelc_blue.png)
This is an identical result to using "`-fill DodgerBlue -colorize 100%`" to [Colorize Images](../colorize) (see below).
If you want to set the images transparency setting as well you will need to set "`-channel`" to include the transparency channel, OR set the [Alpha Channel](../basics/#alpha) to fully-opaque, using either "`-alpha opaque`" or "`-alpha off`".
  
      convert  test.png -channel ALL +level-colors dodgerblue levelc_blue2.png

  
[![\[IM Output\]](levelc_blue2.png)](levelc_blue2.png)
Also see [Blanking Existing Images](../canvas/#blank).
Here are a few more examples of using this to adjust or 'tint' a colorful image, rather than a gray-scale image.
  
      convert rose: +level-colors             navy,lemonchiffon  levelc_faded.gif
      convert rose: +level-colors        firebrick,yellow        levelc_fire.gif
      convert rose: +level-colors 'rgb(102,75,25)',lemonchiffon  levelc_tan.gif

[![\[IM Output\]](rose.png)](rose.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](levelc_faded.gif)](levelc_faded.gif) [![\[IM Output\]](levelc_fire.gif)](levelc_fire.gif) [![\[IM Output\]](levelc_tan.gif)](levelc_tan.gif)

In summary the "`+level-colors`" is a gradient color replacement, a linear tinting operator, and can also completely reset colors.
### Sigmoidal Non-linearity Contrast

From a PDF paper on '*[Fundamentals of Image Processing](http://www.cs.dartmouth.edu/~farid/tutorials/fip.pdf)*' (page 44) they present an alternative to using a linear contrast control (level), with one using gamma correction known as '*sigmoidal non-linearity contrast control*'.
The result is a non-linear, smooth contrast change (a 'Sigmoidal Function' in mathematical terms) over the whole color range, preserving the white and black colors, much better for photo color adjustments.
The exact formula from the paper is very complex, and even has a mistake, but essentially requires with two adjustment values. A threshold level for the contrast function to center on (typically centered at '`50%`'), and a contrast factor ('`10`' being very high, and '`0.5`' very low).
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
*For those interested, the corrected formula for the 'sigmoidal non-linearity contrast control' is...*
  
`         ( 1/(1+exp(β*(α-u)))              - 1/(1+exp(β))         ) / ( 1/(1+exp(β*(α-1)))                - 1/(1+exp(β*α)) )     `

  
Where **α** is the threshold level, and **β** the contrast factor to be applied.
  
The formula is actually very simple exponential curve, with the bulk of the above formula is designed to ensure that 0 remains zero and 1 remains one. That is, the graph always goes though the points 0,0 and 1,1. And the highest gradient of change is at the given threshold.
Here for example is a "`-fx`" implementation of the above formula, resulting from a very high contrast value of '`10`' and a '`50%`' threshold value. These values have been rolled into the floating point constants, to speed up the function.
  
      convert test.png  -fx '(1/(1+exp(10*(.5-u)))-0.006693)*1.013567' \
                  sigmoidal.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) ![\[IM Graph\]](gp_sigmoidal.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](sigmoidal.png)](sigmoidal.png)

  
Lucky for us IM v6.2.1 had this complex function built in as a new operator "`-sigmoidal-contrast`", allowing a much simpler application.
  
        convert test.png  -sigmoidal-contrast 10,50% test_sigmoidal.png

  
[![\[IM Output\]](test_sigmoidal.png)](test_sigmoidal.png)
  
As a bonus IM also provides the inverse, a 'sigmoidal contrast reduction' function (as plus '`+`' form of the operator), which if applied with the same arguments restores our original image (almost exactly).
  
        convert test_sigmoidal.png +sigmoidal-contrast 10,50% \
                                                 test_sigmoidal_inv.png

  
[![\[IM Output\]](test_sigmoidal_inv.png)](test_sigmoidal_inv.png)
And here we apply it to the rose image...
  
        convert  rose:  -sigmoidal-contrast 10,50%  rose_sigmoidal.gif

  
[![\[IM Output\]](rose_sigmoidal.gif)](rose_sigmoidal.gif)
I did say '`10`' was a very heavy contrast factor. In fact anything higher than this value can be considered to be more like a fuzzy threshold operation, rather than a contrast enhancement.
For a practical example of using this operator see the advanced ["Gel" Effects Example](../advanced/#gel_effects), where it is used to sharpen the bright area being added to a shaped area color.
### Miscellaneous Contrast Operators

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

       -contrast  and   +contrast
             Rather useless minor contrast adjustment operator

    -threshold
       Threshold the image, any value less than or equal to the given value is
       set to 0 and anything greater is set to the maximum value.

       Note that like level, this is a channel operator, but if the default
       'channel setting' is used only the gray-scale intensity of the image is
       thresholded producing a black and white image.

       convert rose: -threshold 45%  x:

       You can force normal channel behaviour, where each channel is thresholded
       individually buy using "-channel All"

       convert rose: -channel All -threshold 45%  x:

    -black-threshold
    -white-threshold
       This is like -threshold except that only one side of the threshold value is
       actually modified.

       For example, here anything that is darker than 30% is set to black.

       convert rose: -black-threshold 30%  x:
       convert rose: -white-threshold 50%  x:

       These operators however do not seem to be channel effected, so may only be
       suitable for gray-scale images!

------------------------------------------------------------------------

## Adjustments Using Histogram Modification

*This section was a joint effort by [Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html) and Anthony Thyssen.*
What is a histogram?
A histogram is a special type of graph. It simply sorts the color levels of the pixels in an image into a fixed number of 'bins' each of which span some small range of values. As such each bin contains a count of the number of color levels (pixel values) in the image that fall into that range.
The result is a representation of how the color values that make up an image are distributed, from black at the left, to white at at the right.
  
The histogram can be generated for each channel separately or as a global histogram which looks at values from all the channels combined. The result is often displayed as a image of a bar chart. In IM, this is done using the special [Histogram:](../files/#histogram) output format. For example...
  
      convert rose: histogram:histogram.gif

  
[![\[IM Output\]](histogram.gif)](histogram.gif)
But it can also be displayed as a line graph where the line connects the tops of the bars. This will be demonstrated later in the discussion below.
See [Histogram:](../files/#histogram) for more details of this special output format. This is recommended reading at this point as it is the best way to extract histogram information about images using IM.
A histogram chart's actual height has little actual meaning, since it is usually scaled so that the highest peak touches the top of the image. As such the height of each individual 'bar' is not relevant. What is much more important is the distribution of the histogram over the whole range, and how the relative heights relate to each other over the whole of the chart.
When looking at a histogram you would consider the following factors.
-   Does the histogram form one wide band of values? This means that the image makes wide use of the colorspace and thus has good contrast.
-   Or is it all in a tight group in the middle or at one end of the range? This means the image has a low contrast, making it look 'fogged' or 'grayed', or perhaps overly light or dark.
-   Does it form two or more peaks? As a result of highly different areas or regions in the image.
-   Where are most of the pixels? At the left, meaning the image is very dark. Or at the right, meaning it is very bright. Or spread out around the middle?
-   Are there regular gaps or empty spaces between individual bars? This usually means either the image has very few pixels, so it could not completely fill out the whole histogram, or the image was color reduced, or modified in some way, so as to produce those gaps.

Essentially a histogram is a simpler representation of an image, and as such it is much easier to change or adjust an image in terms of its histogram.
Almost any mathematical color transformation that one applies to an image will normally cause not only the image to be modified, but its histogram as well. These include linear operations such as the [Level Operator](#level) or non-linear operations such as the [Gamma Operator](#gamma), (see above). The mapping graphs we saw above represent how the graylevels in an image and thus how the image's histogram is to be transformed.
For example, lets make a low contrast image to demonstrate. However, the final result is that it not only modifies the image, but does so by modifying the image's histogram (by compressing it).
  
      convert chinese_chess.jpg -contrast -contrast -contrast -contrast \
              chinese_contrast.png

      convert chinese_chess.jpg     histogram:chinese_chess_hist.gif
      convert chinese_contrast.png  histogram:chinese_contrast_hist.gif

[![\[IM Output\]](chinese_chess.jpg)](chinese_chess.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](chinese_contrast.png)](chinese_contrast.png)  
 [![\[IM Output\]](chinese_chess_hist.gif)](chinese_chess_hist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](chinese_contrast_hist.gif)](chinese_contrast_hist.gif)

In the above case, "`-contrast`, is a simple [Level](#level) type operator that adds just a little more contrast to the image. the result of this is that the histogram itself is spread out more, causing it to cover the whole of the possible color range better.
You can also see from the histograms, before and after, that the colors will also end up with gaps and holes between the 'bins', due to the way in which the stretching was performed. Specifically it creates a 'histogram' with all the colors being places into 'bin'. These 'binned' colors are then modified as a whole, causing the image colors to be grouped together. It is not a particularly good way of handling image colors.
This operator however works blindly, without any knowledge of the image content or color distribution. It thus cannot be done without some user control, as the operator could very easily make any image it is applied to, worse, rather than better.
In this section we will look at image processing operators that examine the image's histogram as part of its decision making process. It then modifies images using the result this study, so as to enhance some quality of the image color distribution. As these operators make use of actual information coming from the image being processed, they can often be used more globally over many images with much checking by the user.
Operators of this type include automatic linear 'level' type operators such as "`-normalize`", "`-contrast-stretch`", and "`-linear-stretch`", but also non-linear ones such as "`-equalize`", and others that may eventually be included into ImageMagick such as [Fred Weinhaus's](http://www.fmwconcepts.com/fmw/fmw.html) script, "[redist](http://www.fmwconcepts.com/imagemagick/redist/)".
### Histogram Stretching

The simplest techniques, like the previous example simply stretch the histogram of the image outward to improve the color range. However instead of just blindly picking the *black-point* and *white-point* for [Level](#level) operation, they select points based on the images histogram.
Basically they count up the number of color values in each histogram bin, from each of the two ends, inward until they reach some threshold. These points will then be used as the *black-point* and *white-point* for the histogram (level) stretching.
*Diagram needed*
Basically the histogram counts provide the graylevel values that the stretch will force to black and white. This means that all pixels in the image that fall within the range of bins from pure black to the selected *black-point* bin's corresponding graylevel will end up pure black.
Likewise those pixels in the image that fall within the range of bins from from pure white to the *white-point* bin's corresponding graylevel will end up pure white.
The pixels that are outside these points however will have been stretched outside the possible color range of values, and as a result they will be simply be set to the range limits. That is these pixels are 'clipped' 'burned-in' as they are converted to the extreme of pure black or pure white color values.
As a result if the 'threshold' limits for selecting the *black-point* and *white-point* is set too high, you will get lots of black and white areas in the image, with the resulting histogram having large counts (tall bars) at the extreme end bins.
*Example of severe burn-in -- Chinese Chess Image?* **Summary of 'stretch' operators**...
-contrast-stretch, and -linear-stretch all generate a histogram (using 1024 bins) to determine the color position to stretch. as such it is not 'exact'. The other difference is how 'zero' is handled, and that -linear-stretch actually does a -level operation to do the stretch, while -contrast-stretch uses histogram bin values for color replacement stretching (which introduces a 1024 quantum rounding effect. -normalize uses -contrast-stretch internally.
A mathematically perfect normalization stretching operator is -auto-level. While a perfect 'white-point only' or 'black-point only' version is posible it has not been implemented at this time.
### Auto-Level - perfect mathematical normalization

The "`-auto-level`" finds the largest and smalled values in the image to use to stretch the image to the full Quantum Range. At no time will values become 'clipped' or 'burned' as a result of the histogram being stretch beyond the value range.
The "`-channel`" setting will determine if all channels are stretch equally 'in sync' (using the maximum and minimum over all channels) or separatally (each individual channel as a separate entity).
At this time the hidden color of fully-transparent pixels, are also used in determining the levels, which can cause some problems when transparency is involved. This is regarded as a bug.
    FUTURE: We actually need three modes of operation...
      synced color channels with 'alpha' (and 'read') masking.
      synced channels (as defined by channel)       (current default)
      individual separate channels   (currently if -channel is set by user)

It is a pure-mathematical histogram stretch just as the manual [Level Operator](#level) is. That is the minimum will be adjusted to zero and maximum to Quantum range, and a linear equation is used to adjust all other values in the image.
It does not use 'histogram bins' or any other 'grouping of values' that other methods may use for either determining the levels to be used, or other histogram adjustments.
### Normalize

The "`-normalize`" operator is the simplest of these three operators. It simply expands the grayscale histogram so that it occupies the full dynamic range of gray values, while clipping or burning 2% on the low (black) end and 1% on the on the high (white) end of the histogram. That is, 2% of the darkest grays in the image will become black and 1% of the lightest grays will become white.
This is not a large loss in most images, and the overall result is that the contrast (intensity range) of the image will be automatically maximized.
*A idealized diagram is needed here!*
*Example using chinese chess?*
Here we create a gray-scale gradient, and expand it to the full black and white range.
  
      convert -size 150x100 gradient:gray70-gray30 gray_range.jpg
      convert gray_range.jpg  -normalize  normalize_gray.jpg

[![\[IM Output\]](gray_range.jpg)](gray_range.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](normalize_gray.jpg)](normalize_gray.jpg)

  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
For practical reasons to do with JPEG color inaccuracies (see [JPEG Color Distortion](../formats/#jpg_color) for more details) and scanned image noise, "`-normalize`" does not expand the very brightest and darkest colors, but a little beyond those values. That is, it is equivalent to a "`-contrast-stretch`" with a value of '`2%,99%`' (see below).
  
This means if highest and lowest color values are very close together, "`-normalize`" will fail, an no action will be taken.
  
If you really want to expand the exact brightest and darkest color values to their extremes use "`-auto-level`" instead.
Up until IM version 6.2.5-5, "`-normalize`" worked purely as a grayscale operator. That is, each of the red, green, blue, and alpha channels were expanded independently of each other according to the "`-channel`" setting. As of IM version 6.2.5-5, if only the default "`+channel`" setting is given, then "`-normalize`" will tie together all the color channels, and normalizes them all by the same amount. This ensures that pixel colors within the image are not shifted. However, it also means that you may not get a pure white or black color pixel.
For example here we added some extra colors (a blue to navy gradient) to our normalization test image.
  
      convert -size 100x100 gradient:gray70-gray30 \
              -size  50x100 gradient:blue-navy  +append  color_range.jpg
      convert color_range.jpg -normalize  normalize.jpg

[![\[IM Output\]](color_range.jpg)](color_range.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](normalize.jpg)](normalize.jpg)

As you can see from the last example, for color images "`-normalize`" maximized all the channels together so one channel has a zero value, and another channel has a maximum value. That is, no black pixels were generated, as all the added blue colors already contain 'zero' values in the 'red' and 'green' channels. As such the lower bounds of the image did not expand.
  
If you want the old "`-normalize`" behaviour (before IM v6.2.5-5), you will need to specify any non-default "`-channel`" setting. For images that contain no alpha (or matte) channel, you can just use the '`all`' channel setting.
  
      convert color_range.jpg -channel all  -normalize   normalize_all.jpg

  
[![\[IM Output\]](normalize_all.jpg)](normalize_all.jpg)
  
Alternatively, you can normalize each channel as a separate image using the "`-separate`" operator (as of IM v6.2.9-2), then "`-combine`" them back into a single image again.
  
      convert color_range.jpg -separate -normalize -combine normalize_sep.jpg

  
[![\[IM Output\]](normalize_sep.jpg)](normalize_sep.jpg)
In these last two examples, we see that the grayscale areas of the image turned yellow, since the '`red`' and '`green`' channels were lightened, while the '`blue`' channel is only darkened slightly.
This brings use to an important point
**Normalise and other Histogram operators are really grayscale operators,  
 caution is needed when using it with color images.**

In actual fact, "`-normalize`" is just a subset of the more general "`-contrast-stretch`" with default values for black-point 2% and white-point=1%. So what is "`-contrast-stretch`"?
### contrast-stretch

The "`-contrast-stretch`" operator (added IM v6.2.6) is similar to "`-normalize`", except it allows the user to specify the number of pixels that will be clipped or burned-in. That is it provides you with some control over its selection of the '*black-point*' and '*white-point*' it will use for the histogram stretching. Thus the user specifies a count (or percent counts) of the darkest grays in the image become black and the count of the lightest greys to become white.
For example, this will replace both the top and bottom 15% of colors with their extremes (white and black), stretching the rest of the 70% of colors appropriately. The final result is to try to improve the overall contrast of the image.
  
      convert gray_range.jpg  -contrast-stretch 15%  stretch_gray.jpg

[![\[IM Output\]](gray_range.jpg)](gray_range.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](stretch_gray.jpg)](stretch_gray.jpg)

You can also easily see the 'burn' and 'clip' effects at the top and bottom of the above gradient, as those gray colors get stretched well beyond the limits of the color range.
  
And here I purposefully 'burn' 90% of the darker grays, leaving just 10% of the brightest pixels to be stretched into a tight linear gradient at the top of the image.
  
      convert gray_range.jpg  -contrast-stretch 90%x0%  stretch_black.jpg

  
[![\[IM Output\]](stretch_black.jpg)](stretch_black.jpg)
This can be quite useful in order to find the brightest 'N' pixels in an image, as they will be the only ones not 'burned' to a value of zero. (A better way is to use "`-threshold-black`")
One important aspect of "`-contrast-stretch`" is the use of zero for the *black-point* and *white-point* threshold counts. In this case, "`-contast-stretch 0`", will locate the minimum and maximum bins in the image's histogram. Since the counts actually begins at these bins, the result is simply to stretch the min and max bins to full black and full white. This will result in a contrast stretch with a minimum or possibly zero amount of clipping, with all the values in those 'bins' becoming 0 and maximum values.
![](../img_www/space.gif)
![](../img_www/space.gif)
![](../img_www/space.gif)
 
![](../img_www/space.gif)
![](../img_www/space.gif)
**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

### Linear-Stretch

In many ways "`-linear-stretch`" is very similar to the previous "`-contrast-stretch`" operator. Both functions can take black-point and white-point arguments as either raw counts or as percentages of the total number of pixels involved. However there are several important differences.
One difference has to do with how the default black-point and white-point is computed. With "`-contrast-stretch`". If only one value, the black-point, is provided, then the white point will be the same value. Thus "`-contrast-stretch 1`" is equivalent to "`-contrast-stretch 1x1`" and "`-contrast-stretch 1%`" is equivalent to "`-contrast-stretch 1x1%"`". However, with "`-linear-stretch`", if only one value, the black-point, is provided, then the white point will be the complement value.
That is, if the black-point is specified as a raw count, then the white-point will be the total pixels in the image minus the black-point count. Likewise, if the black-point is specified as a percent count, then the white-point will be, 100% minus the black-point percentage count. Thus "`-linear-stretch 1%`" will be equivalent to "`-linear-stretch 1x99%`".
The second difference has to do with where counts begin. Consider a histogram with 256 bins (some 'bins' which may have zero counts) going from graylevel 0 to graylevel 255. In "`-contrast-stretch`", counts start at zero with the lowest (min) and highest (max) populated bins in the image (which may or may not be at bin 0 or bin 255 in the histogram). Thus a black-point of 10% will cumulate counts from all bins after the min bin until it reaches 10% and stretch the black side from that graylevel. Thus the amount burned-in at the black side of the histogram will end up being 10% plus what was already found in the darker 'bins' before it. Likewise with counting from the bright side of the histogram.
With "`-linear-stretch`", the count starts at the ends of the histogram, namely, at bin 0 and bin 255. Thus the amount burned-in at the dark side will always be the black-point value and the amount of burn-in at the bright side will always be the white-point value.
As an example, lets take a gradient of 100 pixels and look at its histogram.
  
      convert -size 1x100 gradient: \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_hist_mod.txt.gif)](grad_hist.txt)

As expected every bin is equally populated with a single pixel, producing a count of 1. (To see the full listing click on the output text image above).
Now lets do the same after using "`-contrast-stretch 10x10%`"
  
      convert -size 1x100 gradient:   -contrast-stretch 10x10%  \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_cs_hist_mod.txt.gif)](grad_cs_hist.txt)

And now "`-linear-stretch 10x10%`".
  
      convert -size 1x100 gradient:   -linear-stretch 10x10%  \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_ls_hist_mod.txt.gif)](grad_ls_hist.txt)

So we confirm that for "`-contrast-stretch 10x10%`" we get 11 pixels at each end. That is equivalent to the count in the end bins plus 10% of the image pixels, which is equal to 10 pixels. So 10+1=11 pixels burned-in. On the other hand, in "`-linear-stretch`", the end bins end up containing containing only 10 pixels or 10% of the image.
One consequence of the aforementioned difference is that "`-contrast-stretch 0x0`" may change the image, if the lowest and/or highest populated bins are not the end bins at 0 and 255. In this case, the image will be stretched between the graylevels corresponding to those bins. On the other hand, "`-linear-stretch 0x0`" will never change the image.
For example, lets take the gradient and compress its graylevels by 10% on each end. That is, we will move black-point up 10% to graylevel 26 and white-point down 10% to graylevel 230.
  
      convert -size 1x100 gradient:   +level 10x90%  \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_lv_hist_mod.txt.gif)](grad_lv_hist.txt)

Now, lets apply "`-contrast-stretch 0x0`" to the above de-contrasted gradient
  
      convert -size 1x100 gradient: -level 10x90%  -contrast-stretch 0x0  \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_cs0_hist_mod.txt.gif)](grad_cs0_hist.txt)

And now "`-linear-stretch 0x0`"
  
      convert -size 1x100 gradient: -level 10x90%  -linear-stretch 10x10% \
              -depth 8 -format "%c" histogram:info:

  
[![\[IM Text\]](grad_ls0_hist_mod.txt.gif)](grad_ls0_hist.txt)

So we see that the original image had a histogram that did not span the full dynamic range of 0 to 255. It only went between graylevels 26 and 230. But after applying "`-contrast-stretch 0x0`", it was stretched to full dynamic range. On the other hand, "`-linear-stretch 0x0`" made no change in the resulting histogram.
The third difference is that "`-contrast-stretch`" is channel sensitive, whereas "`-linear-stretch`" is not.
That means that with "`-contrast-stretch`" any one or more channels can be changed without affecting the others. Thus if no channel is specified, the overall histogram from all the channels will be used to modify all the channels in the same manner so that no color shifts are produced.
However, if "`-channel RGB`" is specified, then each channel will be stretched separately and the result will depend upon the end bins in each channel. If they are different, then a color shift will be produced between the individual channels in the resulting image.
With "`-linear-stretch`", all the channels will be processed in a common way, thus assuring that no color shifts of the channels relative to each other will be produced.
So lets get a verbose identify and the histogram of a real image.
  
      convert port.png  -verbose -identify +verbose  histogram:port_hist.gif

  
[![\[IM Text\]](info_port_mod.txt.gif)](info_port.txt)
  
[![\[IM Output\]](port.png)](port.png)  
 [![\[IM Output\]](port_hist.gif)](port_hist.gif)

We see that none of the channels of the above image span the full dynamic range. Also note that each of the channels spans a uniquely different range of values.
Now lets apply "`-contrast-stretch 1x1%`" without a "`-channel`" setting.
  
      convert port.png -contrast-stretch 1x1% \
              -write histogram:port_cs1_hist.gif   port_cs1.png

[![\[IM Output\]](port_cs1.png)](port_cs1.png) [![\[IM Output\]](port_cs1_hist.gif)](port_cs1_hist.gif)

In the above result, the image is stretched consistently across all the channels. Thus, there are no color shifts between channels. Now let's do the same but with "`-channel RGB`".
  
      convert port.png  -channel RGB  -contrast-stretch 1x1% \
              -write histogram:port_cs1rgb_hist.gif    port_cs1rgb.png

[![\[IM Output\]](port_cs1rgb.png)](port_cs1rgb.png) [![\[IM Output\]](port_cs1rgb_hist.gif)](port_cs1rgb_hist.gif)

In the above result, because we set "`-channel RGB`", rather than use the default channel setting, the image is stretched differently for each channel. This causes a color shift between channels.
Now let's apply "`-linear-stretch`" without a "`-channel`" setting.
  
      convert port.png   -linear-stretch 1x1% \
              -write histogram:port_ls1_hist.gif \
              port_ls1.png

[![\[IM Output\]](port_ls1.png)](port_ls1.png) [![\[IM Output\]](port_ls1_hist.gif)](port_ls1_hist.gif)

In the above result, the image is stretched consistently across all the channels. So there is no color shift between channels. Now let's do the same, but with "`-channel RGB`".
  
      convert port.png  -channel RGB  -linear-stretch 1x1% \
              -write histogram:port_ls1rgb_hist.gif    port_ls1rgb.png

[![\[IM Output\]](port_ls1rgb.png)](port_ls1rgb.png) [![\[IM Output\]](port_ls1rgb_hist.gif)](port_ls1rgb_hist.gif)

In the above result with "`-linear-stretch`", the image is stretched consistently across all the channels and "`-channel RGB`" is ignored. Thus there is no color shift between channels and the result is identical to that above without "`-channel RGB`".
 
![](../img_www/space.gif)
### Histogram Redistribution

Histogram redistribution is a non-linear technique that redistributes the bins in a histogram in order to achieve some particular shape. The two most common shapes are uniform (flat) and Gaussian (bell-shaped), although Hyperbolic and Rayleigh are other types of distributions have also been used.
### Equalize - Uniform Histogram Redistribution

For the case of a uniform distribution, the histogram bins are shifted, spaced and combined so that on average the histogram has a flat or constant height across the whole range. This is called histogram equalization. The IM function, "`-equalize`", does this.
Unfortunately, it operates on each channel separately, rather than applying the same operation to all channels. As such, color shifts are possible, when it is applied to RGB colorspace.
Here is an example of histogram equalization using the IM function -equalize. Notice the color balance shift from the equalization on each channel independently.
  
      convert zelda.png  -write histogram:zelda_hist.gif \
              -equalize  -write histogram:zelda_equal_hist.gif \
              zelda_equal.png

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_equal.png)](zelda_equal.png)  
 [![\[IM Output\]](zelda_hist.gif)](zelda_hist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_equal_hist.gif)](zelda_equal_hist.gif)

You may note that the histogram does not look very uniform. But if we convert the resulting image to grayscale and display its histogram, its histogram looks a bit more uniform in comparison to the original image's grayscale histogram
  
      convert zelda.png  -colorspace gray   histogram:zelda_ghist.gif

      convert zelda_equal.png  -colorspace gray \
              histogram:zelda_equal_ghist.gif

[![\[IM Output\]](zelda_ghist.gif)](zelda_ghist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_equal_ghist.gif)](zelda_equal_ghist.gif)

The other way to approach redistributing the bins is by using a transformation look up table that is generated from the separate cumulative histograms of each channel and the desired integrated distribution curve. If one does not want any color shifts between channels, then one uses the combined histogram from all the channels of the image. An approximation is simply to use the histogram of the image after converting it to grayscale.
[Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html) has developed a script, called "[redist](http://www.fmwconcepts.com/imagemagick/redist/)" that does just that. It redistributes the histogram of an image into a uniform distribution, while appling the same change to all color channels equally.
  
      redist -s uniform zelda.png  zelda_uniform.png

      convert zelda_uniform.png   histogram:zelda_uniform_hist.gif

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_uniform.png)](zelda_uniform.png)  
 [![\[IM Output\]](zelda_hist.gif)](zelda_hist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_uniform_hist.gif)](zelda_uniform_hist.gif)

Note how the results different from the IM built-in "`-equalize`" operator. Specifically, all the colors are preserved, without the color shift you saw previously.
What the script does is work on the grayscale histogram, which it then applies to all the color channels, so that all the colors are kept together.
For comparison with the IM "`-equalize`" histograms, lets show the grayscale histogram results here, too. Note that the redistributed histogram appears to be a bit more leveled out (flat, or uniform) than that of IM equalize.
  
      convert zelda.png  -colorspace gray   histogram:zelda_ghist.gif

      convert zelda_uniform.png  -colorspace gray \
              histogram:zelda_uniform_ghist.gif

[![\[IM Output\]](zelda_ghist.gif)](zelda_ghist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_uniform_ghist.gif)](zelda_uniform_ghist.gif)

*FUTURE: Add examples of equalizing in other colorspaces! That is, the grayscale channel in HSL, HSB and CMYK colorspaces.*
### Gaussian Redistribution

Equalizing a histogram is not the only way of changing the histogram distribution of an image. Actually it isn't normally very useful, except in computer vision applications.
Here is the same image, but transformed so its histogram has a Gaussian (bell-shaped) distribution. The values used here are a 60% gray mean, with a 60 sigma roll-off to either side of that mean.
  
      redist -s gaussian 60,60,60  zelda.png \
             zelda_gaussian.png

      convert zelda_gaussian.png -colorspace gray \
              histogram:zelda_gaussian_ghist.gif

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_gaussian.png)](zelda_gaussian.png)  
 [![\[IM Output\]](zelda_ghist.gif)](zelda_ghist.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_gaussian_ghist.gif)](zelda_gaussian_ghist.gif)

From the resulting grayscale histogram, you can see that the image is modified so its colors follow a Gaussian bell curve type of distribution.
For photos, this produces a more 'natural' looking result. The image will not only have been contrast optimized, but also adjusted in brightness so most of the pixels in the image have about a 60% grayscale brightness.
### Histogram Redistribution Methodology

So how does this type of direct histogram adjustment work?
Basically it computes the histogram of the current image and that of the desired distribution. It then works out how the graylevel value of each 'bin' needs to be changed so that the counts in the bins best follow the desired distribution. Some bins may be shifted darker, while others may be shifted lighter.
This is actually quite an involved process, so lets go though it step by step.
  
 First, we need to get the actual histogram data from ImageMagick, rather than a graphic image of the histogram. Note that the data is from all the color values, combined into a grayscale. This was done so as to distribute all the channels together, and adjust the image overall brightness to follow to the desired curve.
  
      convert zelda.png -colorspace gray \
             -depth 8 -format "%c" histogram:info:- |\
        tr -cs '0-9\012' ' ' |\
          awk '# collect the histogram data.
               { bin[$2] += $1; }
               END { for ( i=0; i<256; i++ ) {
                       print bin[i]+0;
                     }
                   } ' > zelda_hist_data.txt

      # get the maximum count for any one histogram 'bin'
      max_count=`sort -n zelda_hist_data.txt | tail -n 1`

      # convert histogram into a profile graph of the data
      echo "P2 256 1 $max_count" | cat - zelda_hist_data.txt |\
        im_profile -s - zelda_hist_graph.gif

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_hist_graph.gif)](zelda_hist_graph.gif)

To collect the data I take the 'comment' meta-data from the histogram image, which IM includes just for this purpose. The data is then cleaned to leave just the raw numbers (using a program called "`tr`", short for 'translate'). This raw data is then given to another utility program called "`awk`", which is used to collect the actual histogram counts for each bin.
So that we can look at the results, I also process the histogram counts into a gradient image (via the [NetPBM, PGM text grayscale](../formats/#netpbm) image file format, and display it as a line graph using the "`im_profile`" script. Essentially this is just a different way of generating a histogram image, though this time directly from a numerical data file.
Now that we have the histogram data in a text file, we also need the histogram of the function we want the redistributed data to match. In this case, it is a Gaussian distribution with a mean value of 153 (60% gray) and sigma width of 60. Both values are in terms of the 256 range of the histogram 'bins'.
  
      awk '# AWK to generate gaussian distribution graph
            BEGIN { mean = 153;   sigma = 60;
                    fact = 1/(2*(sigma/256)^2);
                    expo = exp(1);
                    for ( i=0; i<256; i++ ) {
                      print int(65535*expo^(-(((i-mean)/256)^2)*fact));
                    }
                  }' /dev/null  > gaussian_hist_data.txt

       # convert gaussian data into a profile graph
       echo "P2 256 1 65535" | cat - gaussian_hist_data.txt |\
         im_profile -s -b - gaussian_hist_graph.gif

[![\[IM Output\]](gaussian_hist_graph.gif)](gaussian_hist_graph.gif)

The histograms above are interesting and reflect the image's original histogram distribution and the histogram's desired state. But for conversion purposes, this form of histogram, while good for us to understand, is not very useful for our purposes.
Actually, what we really need are the cumulative histograms. These histograms are very similar to a normal histogram, except that each 'bin' in the histogram is a count of its 'bin' plus all the 'bins' that came before it, starting at 0. That is, each 'bin' is an 'accumulation' or count of all the darker 'bins'.
These are actually easier to generate directly from the original image. So lets repeat the process, but computing and saving the 'cumulative' counts.
  
      convert zelda.png -colorspace gray \
             -depth 8 -format "%c" histogram:info:- |\
        tr -cs '0-9\012' ' ' |\
          awk '# Collect the cumulative histogram for an image
                   { bin[$2] += $1; }
               END { for ( i=0; i<256; i++ ) {
                       cum += bin[i];
                       print cum;
                     }
                   } ' > zelda_cumhist_data.txt

      total_count=`tail -n 1 zelda_cumhist_data.txt`
      echo "P2 256 1 $total_count" | cat - zelda_cumhist_data.txt |\
        im_profile -s - zelda_cumhist_graph.gif

      awk '# AWK to generate gaussian distribution cumulative graph
            BEGIN { mean = 153;   sigma = 60;
                    fact = 1/(2*(sigma/256)^2);
                    expo = exp(1);
                    for ( i=0; i<256; i++ ) {
                      gas[i] = expo^(-(((i-mean)/256)^2)*fact);
                      total += gas[i]
                    }
                    for ( i=0; i<256; i++ ) {
                      cum += gas[i];
                      print int(65535*cum/total);
                    }
                  }' /dev/null  > gaussian_cumhist_data.txt

      total_count=`tail -n 1 gaussian_cumhist_data.txt`
      echo "P2 256 1 $total_count" | cat - gaussian_cumhist_data.txt |\
        im_profile -s -b - gaussian_cumhist_graph.gif

  
[![\[IM Output\]](zelda_cumhist_graph.gif)](zelda_cumhist_graph.gif)  
Image Cumulative  
Histogram
  
[![\[IM Output\]](gaussian_cumhist_graph.gif)](gaussian_cumhist_graph.gif)  
Gaussian Cumulative  
Histogram

Now what we need to do is convert the image's cumulative histogram into the gaussian cumulative histogram. To do this, each gray value in the input image is used to find its 'normalized' cumulative value. This is then mapped to the same cumulative value in the gaussian distribution and then its corresponding gray value is found.
This diagram should make the mapping process clearer...
![\[diagram\]](../img_diagrams/redist_working.jpg)

The following command does the lookup for every possible 8-bit color value, in order to generate a Color Look Up Table, or CLUT. This special image can then be used to map the color values in the original image to the new values needed to redistribute the image's histogram.
  
      # Generate a CLUT to Redistribute the Histogram
      paste  zelda_cumhist_data.txt   gaussian_cumhist_data.txt |\
        awk '# AWK to generate gaussian distribution graph
                  { bin[NR] = $1;   gas[NR] = $2;  }
              END { k=0;  # number of pixels less than this value
                    print "P2 256 1 65535";
                    for ( j=0; j<256; j++ ) {
                      while ( k<255 &&
                                gas[k]/gas[255] <= bin[j]/bin[255] ) {
                        k++;
                      }
                      print 65535*k/255;
                    }
                  }' |\
          convert pgm:- gaussian_clut.png

      convert zelda.png   gaussian_clut.png -clut   zelda_redist.png

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_redist.png)](zelda_redist.png)  
 [![\[IM Output\]](zelda_hist_graph.gif)](zelda_hist_graph.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_redist_graph.gif)](zelda_redist_graph.gif)

As you can see, converting a histogram of an image to attempt to follow a specific distribution function, such a gaussian bell curve, is quite an involved and highly numerical process.
Here it is all in one rather long and complex command...
  
      convert zelda.png -colorspace gray \
             -depth 8 -format "%c" histogram:info:- |\
        tr -cs '0-9\012' ' ' |\
          awk '# AWK to generate gaussian distribution graph
                { # just read in image histogram into a 'bin' table
                      bin[$2] += $1;
                    }
                END { # Generate Gaussian Histogram
                      mean = 153;   sigma = 60;
                      fact = 1/(2*(sigma/256)^2);
                      expo = exp(1);
                      for ( i=0; i<256; i++ ) {
                        gas[i] = expo^(-(((i-mean)/256)^2)*fact);
                      }
                      # Convert normal histograms to cumulative histograms
                      for ( i=0; i<256; i++ ) {
                        gas[i] += gas[i-1];
                        bin[i] += bin[i-1];
                      }
                     # Generate Redistributed Histogram
                     k=0;  # number of pixels less than this value
                     print "P2 256 1 65535";
                     for ( j=0; j<256; j++ ) {
                       while ( k<255 &&
                                gas[k]/gas[255] <= bin[j]/bin[255] ) {
                         k++;
                       }
                       print 65535*k/255;
                     }
                    }' |\
            convert zelda.png   pgm:-  -clut   zelda_gaussian_redist.png

[![\[IM Output\]](zelda.png)](zelda.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](zelda_gaussian_redist.png)](zelda_gaussian_redist.png)

Just some final words on the above technique.
-   Using "`awk`" to do the calculations to speed up Fred Weinhaus's "`redist`" script were suggested and contributed by Anthony Thyssen.
-   To apply the above redistribution technique to generate a 'uniform', or 'equalized' distribution, the function histogram is simply a constant. This in turn results in a an integrated distribution that is simply the formula `y = x`, or simply a diagonal straight line. Applying the same conversion technique leads to a CLUT image that turns out to be identical to the input image's cumulative histogram.
    In other words, for an equalization of the histogram, you can simply convert the image's cumulative histogram into a CLUT and apply it to the image directly.
-   Most Image processing packages, including ImageMagick at this time, apply the transformation formulae directly to the values in the image itself, rather than generate an intermediate CLUT. However as histograms and thus cumulative histograms have a limited size (256 'bins' typically), that can lead to serious errors, since the image color values may be rounded off, during the process.
    However with ImageMagick, we generate an intermediate CLUT (containing those same round off errors), and then convert the original un-rounded image values though the prepared CLUT using a linear interpolation of the values. As a result of this interpolation, the color values of the new image is more accurate, as they have not been rounded off or 'bin'ed during processing.

The above will hopefully eventually be built into ImageMagick. In the mean time Fred Weinhaus's "[redist](http://www.fmwconcepts.com/imagemagick/redist/)" script is available to do the task.
You may also be interested in Fred's "[retinex](http://www.fmwconcepts.com/imagemagick/retinex/)" script, which attempts to make similar automatic enhancements to images, in localized regions of the image, rather than globally as this technique does.

------------------------------------------------------------------------

## DIY Level Adjustments

### Mathematical Linear Histogram Adjustments

The various basic forms of [Level Adjustments](#level) shown above linearly adjust the colors of the image.
These changes can be applied mathematically as well. For example by multiplying the image with a specific color, we set all pure white areas to that color. So lets just read in our image, create an image containing the color we want, then multiply the original image with this color using the IM free-form "`-fx`" or [DIY Operator](../transform/#fx).
  
      convert test.png  -size 1x1 xc:Yellow \
              -fx 'u*v.p{0,0}'    fx_linear_white.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_linear_white.png)](fx_linear_white.png)

By getting "`-fx`" to read the color from a second '`v`' image makes it easy to change the color, without needing to convert colors to RGB values for use in the mathematics.
If you were using a fancy graphical image processing package like "`Gimp`" and "`Photoshop`" the above operation would have been applied to an image by adjusting the images color histogram graph 'curve'.
[![\[IM Output\]](fx_linear_white_plot.gif)](fx_linear_white_plot.jpg) For example to the right is a "`gnuplot`" generated graph (See the script "`im_histogram`") of the mathematical formula showing what happens to just one of the three RGB channels. The original color (green line) is remapped to a darker color (red line) linearly.
Linearly tinting the black colors is also quite simple. For example to linear map '`black`' to a gold like color '`rgb(204,153,51)`', (while leaving '`white`' as '`white`'), would require a mathematical formula such as...
              result = 1-(1-color)*(1-intensity)

This formula negates the colors, multiples the image with the negated color wanted, and negates the image back again. The result is tinting of the black side of the gray scale, leaving white unchanged.
  
      convert test.png  -size 1x1 xc:'rgb(204,153,51)'  \
              -fx '1-(1-v.p{0,0})*(1-u)'   fx_linear_black.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/multiply.gif) [![\[IM Output\]](fx_linear_black_plot.gif)](fx_linear_black_plot.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_linear_black.png)](fx_linear_black.png)

A "[gnuplot](http://www.gnuplot.info/)" histogram graph of the remapping formula is also displayed in the above for your reference.
With a slightly more complicated formula you can linearly replace both the '`black`' and '`white`' end of the grayscale with specific colors.
  
      convert test.png  -size 1x2  gradient:gold-firebrick \
              -fx 'v.p{0,0}*u+v.p{0,1}*(1-u)'   fx_linear_color.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/multiply.gif) [![\[IM Output\]](fx_linear_color_plot.gif)](fx_linear_color_plot.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_linear_color.png)](fx_linear_color.png)

The "`-size 1x2 gradient:color1-color2`" in the above is only used to generate a two color pixel image for the "`-fx`" formula to reference. The first color replaces white, while the second replaces black, while all others are interpolated between white and black. As is typical of a gray-scale operator, each RGB channel is treated as a separate gray scale channel, though the linear interpolation is different for each channel.
This by the way is exactly equivalent to the [Level Adjustments by Color](#level-colors) operator "`+level-colors`"
  
However unlike "`+level-colors`", the colors to use can of course come from any image source, and not just the color names provided as an argument. However even direct use of color names is possible.
  
      convert test.png   -fx "yellow*u+green*(1-u)"  fx_linear.png

  
[![\[IM Output\]](fx_linear.png)](fx_linear.png)
### Mathematical Non-linear Histogram Adjustments

While linear color adjustments are important, and faster methods are available, there are many situations where a linear 'level' adjustment, is not what is wanted, and this is where the "`-fx`" [DIY Operator](../transform/#fx), becomes more useful.
Well an alternative formula for linear adjustment is "`-fx 'v.p{0,1}+(v.p{0,0}-v.p{0,1})*u'`", which has the advantage that the '`u`' can be replaced by a single random function '`f(u)`' to produce non-linear color change.
This lets you do more interesting things. For example what if in the last example you wanted to push all the colors toward the '`black`' side, resulting in the image being a more '`firebrick`' color.
  
      convert test.png -size 1x2  gradient:gold-firebrick \
              -fx 'v.p{0,1}+(v.p{0,0}-v.p{0,1})*u^4'  fx_non-linear.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/multiply.gif) [![\[IM Output\]](fx_non-linear_plot.gif)](fx_non-linear_plot.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_non-linear.png)](fx_non-linear.png)

In a more practical example, Adelmo Gomes needed a color adjustment for a automated [Weather Map Recoloring](http://members.aol.com/landsatcd/MOREHTML/colorize.html) script he was developing.
In this case he wanted to tint pure black parts of the image to a .25 blue, but leave the rest of the gray-scale alone, especially the white and mid-tone grays of the image. Only the blue color needed such adjustment, which he currently was doing by hand in an image editor.
For example you could use a quadratic formula like '`u^2`' to tint the black end of the histogram to a '`.25`' blue color. Only the blue channel needs to be modified, so the value was inserted directly into the formula.
  
      convert test.png  -channel B  -fx '.25+(1-.25)*u^2'  fx_quadratic.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/multiply.gif) [![\[IM Output\]](fx_quadratic_plot.gif)](fx_quadratic_plot.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_quadratic.png)](fx_quadratic.png)

However while this produced a reasonable result it does darken the mid-tone grays slightly, producing a sickly off-yellow color.
To avoid this a 'exponential' function can be used instead, to give better control of the tinting process.
  
      convert test.png  -channel B  -fx '.3*exp(-u*4.9)+u'  fx_expotential.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/multiply.gif) [![\[IM Output\]](fx_expotential_plot.gif)](fx_expotential_plot.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fx_expotential.png)](fx_expotential.png)

Again the graph show how blue channel was modified to give black a distinctive dark blue tint.
The second value ('`4.9`') is the falloff back to a linear '`+u`' graph. The smaller this value is the slower the fall off, and the more linear the adjustment becomes. The larger the value, the more dramatic the 'fall-off'. The value may need to be adjusted for different color values, so this is not a good general formula for general black color tinting, but perfect for tinting weather maps.
Generally if you can express the color adjustment you want mathematically, you can then use "`-fx`" operator to achieve the results you want.
### 'Curves' Adjustments

![\[diagram\]](../img_diagrams/curves_gui.gif) Normally in a graphical photo editor you would be presented with a histogram 'curves' chart such as I have shown to the left. The user can then edit the 'curve' by moving four (or more) control points, and the histogram adjustment function will follow those points.
The control points generally specify that the first grayscale level is after adjustment to become the second grayscale level. So a point like 0.0,0.2 basically means that a 0% gray (black) should after adjustment be a 20% gray level.
Now IM does not allow you to directly specify 'control points' to generate a 'curve' adjustment, what it wants is the mathematical formula of that 'curve' generated. Lucky for us there are programs that can generate that curve formula from the control points, including "`gnuplot`", "`fudgit`", "`mathematica`", and "`matlab`", as well as many more mathematical software packages.
The following is one method you can use to generate the formula from four control points using "`gnuplot`" which is a standard extra package you can install on most linux distributions, as well as windows.
  
      ( echo "0.0 0.2";  echo "1.0 0.9"; \
        echo "0.2 0.8";  echo "0.7 0.5"; )   > fx_control.txt

      ( echo 'f(x) = a*x**3 + b*x**2 + c*x + d'; \
        echo 'fit f(x) "fx_control.txt" via a, b, c, d'; \
        echo 'print a,"*u^3 + ",b,"*u^2 + ",c,"*u + ",d'; \
      ) | gnuplot 2>&1 | tail -1             > fx_funct.txt

  
[![\[Data\]](fx_control.txt.gif)](fx_control.txt)
Control Points
![==&gt;](../img_www/right.gif)
[![\[Gnuplot\]](fx_funct_plot.gif)](fx_funct_plot.jpg)
  
[![\[Gnuplot\]](fx_funct.txt.gif)](fx_funct.txt)
Gnuplot Fitted FX Function

  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
Note that the number of parameters ('`a`' to '`d`' in above) needed for curve fitting, must equal the number of control points you provide. As such if you want five control points you need to include another '`e`' term to the function.
  
If your histogram curve goes though the fixed control points `0,0` and `1,1`, you really only need two parameters as '`d`' will be equal to '`0`', and '`c`' will be equal to '`1-a-b`'.
A more detailed usage guide to the above specifically for Windows users, but works for linux users too, has been posted on [StackOverflow: IM Curves using Gnuplot on Windows](http://stackoverflow.com/questions/27468172/).
As you can see from the extra "`gnuplot`" generated image above, the function generated fits the control points perfectly. Also as it generated a "[-fx](../option_link.cgi?fx)" style formula it can be used as is as an IM argument.
  
For example...
  
      convert test.png    -fx "`cat fx_funct.txt`"     fx_funct_curve.png

  
[![\[IM Output\]](fx_funct_curve.png)](fx_funct_curve.png)
To make it easier for users to convert control points into a histogram adjustment function, I have created a shell script called "`im_fx_curves`" to call "`gnuplot`", and output a nicer looking polynomial equation of the given the control points. Gabe Schaffer, also provided a perl version (using a downloaded "`Math::Polynomial`" library module) called "`im_fx_curves.pl`" to do the same thing. Either script can be used.
For example here is a different curve with 5 control points...
  
        im_fx_curves  0,0.2  0.3,0.7  0.6,0.5  0.8,0.8  1,0.6  > fx_curve.txt

  
[![\[Gnuplot\]](fx_curve_plot.gif)](fx_curve_plot.jpg)
  
![==&gt;](../img_www/right.gif)
  
[![\[Gnuplot\]](fx_curve.txt.gif)](fx_curve.txt)

However the FX function is very slow. But as of IM 6.4.8-9 you can now directly pass the discovered coefficients of the fitted polynomial expression directly into a [Polynomial Function Method](../transform/#function_polynomial).
You can generate the comma separated list of coefficients using "`im_fx_curves`" with a special '`-c`' option...
  
        im_fx_curves -c  0,0.2  0.3,0.7  0.6,0.5  0.8,0.8  1,0.6  > coefficients.txt

  
[![\[Gnuplot\]](fx_curve_plot.gif)](fx_curve_plot.jpg)
  
![==&gt;](../img_www/right.gif)
  
[![\[Gnuplot\]](coefficients.txt.gif)](coefficients.txt)

  
For example lets apply those curves to our test image...
  
      convert test.png  -function Polynomial `cat coefficients.txt`  test_curves.png

  
[![\[IM Output\]](test_curves.png)](test_curves.png)
A more practical example of this method is detailed in the advanced ["Aqua" Effects](../advanced/#aqua_effects) example.
An alternative away generating 'curves' is looked at in the IM Forum Discussion [Arbitrary tonal reproduction curves](../forum_link.cgi?f=1&t=22224&p=92056).

------------------------------------------------------------------------

## Tinting Images

### Uniformly Color Tinting Images

Typically tinting an image is achieved by blending the image with a color by a certain amount. This can be done using an [Evaluate Operator](../transform/#evaluate) or [Blend Images](../compose/#blend) techniques, but these are not simple to use.
Lucky for us a simpler method of bleeding a uniform color into an image is available by using the "`-colorize`" image operator. This operator blends the current "`-fill`" color, into all the images in the current image sequence. The alpha channel of the original image is preserved, with only the color channels being modified.
For example lighten an image (gray scale or otherwise) we use "`-colorize`" to blend some amount of white into the image, making it brighter without saturating the image completely.
  
      convert test.png  -fill white -colorize 50%  colorize_lighten.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](colorize_lighten.png)](colorize_lighten.png)

Similarly we can use a '`black`' fill color to darken an image.
  
      convert test.png  -fill black -colorize 50%  colorize_darken.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](colorize_darken.png)](colorize_darken.png)

To gray both ends of the image toward the mid-tones, you would use a specific gray fill color. The color '`gray50`' is the exact middle color of the RGB color spectrum.
  
      convert test.png  -fill gray50 -colorize 40%  colorize_grayer.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](colorize_grayer.png)](colorize_grayer.png)

This is also often used as an method of 'de-contrast' such as what the [Reverse Level Adjustment Operator](#level_plus) provides, though with less control.
The "`-colorize`" operator also allows you to specify dissolve percentages for each of the three color channels separately. This is useful for linearly darkening (or lightening) an image in a special way.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.7.9 the "`-colorize`" operator did not modify the alpha channel at all. From that version onwards, as you can see above, it now uniformly tints all pixels including fully transparent pixels.*
  
One common use of the "`-colorize`" operator is to simply replace all the colors in an existing image (tinting '`100%`'), but preserve the transparency (alpha) shape of the image, so as to produce a colored mask. However from IM v6.7.9 you will need to protect the alpha channel from this operator by disabling it, then re-enabling the alpha channel. (See [Alpha On](../masking/#alpha_on) for more details).
  
For example...
  
      convert test.png -alpha off \
              -fill blue -colorize 100% \
              -alpha on  colorize_shape.png

  
[![\[IM Output\]](colorize_shape.png)](colorize_shape.png)
  
Without this protection, colorize would have fully-blanked the canvas to the given color...
  
      convert test.png -fill blue -colorize 100% colorize_blank.png

  
[![\[IM Output\]](colorize_blank.png)](colorize_blank.png)
However if there is a posibility of using a verion of IM older than IM v6.7.9 I recommend you include a "`-alpha opaque`" or "`-alpha off`" operation in the above to ensure the resulting image is the completely blank image you expect.
Note that you can blank canvases faster using [Level Adjustments by Color](#level-colors) operator with a single color, rather than a range of colors. See also [Blank Canvases](../canvas/#blank).
### Midtone Color Tinting

While the [Colorize operator](#colorize) applies the "`-fill`" color to tint all the colors in an image linearly, the "`-tint`" operator applies the "`-fill`" color in such a way as to only tint the mid-tone colors of an image.
The operator is a grayscale operator, and the color is moderated or enhanced by the percentage given (0 to 200). To limit its effects it is also adjusted using a mathematical formula so that it will not effect black and white. but have the greatest effect on mid-tone colors of each color channel.
A "`-tint 100`" essentially will tint a perfect gray color so that it becomes half the intensity of the fill color. A lower value will tint it to a darker color while a higher value will tint it so toward a perfect match of that color.
  
      convert  test.png  -fill red  -tint 40 tint_red.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](tint_red.png)](tint_red.png)

The green color in the test image is not a true RGB green, but a Scaled Vector Graphics '`green`', which is only half as bright as a true green color. As such it is also a mid-tone color, and thus is affected by the "`-tint`" operator, becoming darker, unlike red and blue color spots of the test image.
Also you can tint the individual color components, by using a comma separated list of percentages. For example "`-tint 30,40,20,10`". This however can be tricky to use and may need some experimentation to get right. Better to specify the color you want for perfect 50% grays.
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
[![\[IM Output\]](tint_plot.gif)](tint_plot.jpg) The "`-tint`" operator works by somehow taking the color and percentages given then then adjusting the individual colors in the image according to the "`-fill`" colors intensity, as per the following formula. (see graph right)
  
`f(x)=(1-(4.0*((x-0.5)*(x-0.5))))`

  
A quadratic function, the result of which is used as vector for the existing color in the image. As you can see gives a complete replacement of the color for a pure mid-gray, with no adjustment for either white or black.
  
Or lower level operators that you can use to DIY this sort of thing, see [FX Operator](../transform/#fx), as well as [Evaluate and Function Operators](../transform/#evaluate).
The tinting operator is perfect to adjust the results of the output of "`-shade`", (See [Shade Overlay Highlight Images](../transform/#shade_overlay)), such as the examples in [3d Bullet Images](../advanced/#3d-bullets).
You can also use "`-tint`" to brighten or darken the mid-tone colors of an image. This is sort of like a 'gamma adjustment' for images, though not exactly.
For example using a tint value greater than 100 with a '`white`' color will brighten the mid-tones.
  
      convert  test.png  -fill white  -tint 130 tint_lighter.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](tint_lighter.png)](tint_lighter.png)

While a value less than 100 will darken colors.
  
      convert  test.png  -fill white  -tint 70 tint_darker.png

[![\[IM Output\]](test.png)](test.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](tint_darker.png)](tint_darker.png)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
At this time, the a pure mid-tone gray color will not be mapped to the "`-fill`" color.
  
The percentage argument is not a 'blend percentage' but really more a 'brightness percentage'. It will for example not work at all for a 'black' fill color.
  
I do not know why it was designed this way or the history behind it. It does however make exact control of the final colors when tinting grayscale images, very awkward.
  
Using [Overlay Compostion Tinting](#tint_overlay) below will provide a more exact (though very linear, rather than parabolic) color tinting of mid-tone grays.
### Sepia Tone Coloring

A special photographic recoloring technique, "`-sepia-tone`" is basically consists to converting the image into a gray-scale, and coloring all the mid-tones to a special brown color.
  
      convert rose:   -sepia-tone 65%     sepia-tone.jpg

  
[![\[IM Output\]](sepia-tone.jpg)](sepia-tone.jpg)
The argument given is the gray-scale 'mid-point' that is to become the closest to the sepia-tone color, which is similar to the color '`Goldenrod`'.
The most common use of this is to generate a [Duotone Effect](#duotone) so as to generate 'old looking' photos (See wikipedia on [Sepia Tone](http://en.wikipedia.org/wiki/Sepia_tone#Sepia_toning)).
For example here I [Tint](#tint) a contrast enhanced gray-scale rose image, using various colors, to achieve similar sepia-tone like effects. Which color you should use on the exact effect you are looking for.
  
      convert rose: -colorspace gray -sigmoidal-contrast 10,40%  rose_grey.jpg
      for color in      goldenrod  gold  khaki  wheat
      do
        convert rose_grey.jpg  -fill $color   -tint 100    sepia_$color.jpg
      done

[![\[IM Output\]](rose_grey.jpg)](rose_grey.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](sepia_goldenrod.jpg)](sepia_goldenrod.jpg) [![\[IM Output\]](sepia_gold.jpg)](sepia_gold.jpg) [![\[IM Output\]](sepia_khaki.jpg)](sepia_khaki.jpg) [![\[IM Output\]](sepia_wheat.jpg)](sepia_wheat.jpg)

I myself find that mixing or blending a sepia-tone image, with the original, so as to reduce its effect can also produce a better 'faded' effect.
  
      convert rose:  \( +clone -sepia-tone 60% \) -average  sepia-tone_blended.jpg

  
[![\[IM Output\]](sepia-tone_blended.jpg)](sepia-tone_blended.jpg)
See also [Hald Color Lookup Tables](#hald-clut) for a method by which you can save much more complex color change variations, such as the last example above.
### Duotone Effect

A 'duotone' is a printing method where you mix the grayscale of an image (black ink) with some other color to produce a better result, with a limited budget or printing equipment. For example the reason all the old photos you see today have a sepia-tone look about them, is because sepia-tone inks survived and did not deteriorate, or fade with time. Other 'black and white' images formats faded into uselessness. See the [Sepia Tone Operator](#sepia-tone) above.
Another duotone technique known as 'Cyanotype' (more commonly known as 'blue-prints') became widely used as method of making large scale copies of the original black and white architect drawings. Remember this tenchique was used long before the invention of lazers and from that photo-copying (and Xerox).
For more information see the Wikipedia entry for [Duotone](http://en.wikipedia.org/wiki/Duotone), also [Fake duotones vs Real duotones](http://www.fromdesignintoprint.com/?p=152).
The above [Tint Operator](#tint) however produces a reasonable facsimile of the duotone effect, just as it did for a sepia-tone like effect above.
  
      convert rose: -colorspace gray -sigmoidal-contrast 10,40%  rose_grey.jpg
      for color in      blue  darkcyan  goldenrod  firebrick
      do
        convert rose_grey.jpg   -fill $color   -tint 100    duotone_$color.jpg
      done

[![\[IM Output\]](rose_grey.jpg)](rose_grey.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](duotone_blue.jpg)](duotone_blue.jpg) [![\[IM Output\]](duotone_darkcyan.jpg)](duotone_darkcyan.jpg) [![\[IM Output\]](duotone_goldenrod.jpg)](duotone_goldenrod.jpg) [![\[IM Output\]](duotone_firebrick.jpg)](duotone_firebrick.jpg)

Note that I generally chose a darker version of the 'duotone' color, but you can also adjust this using the argument of the [Tint Operator](#tint). The brightness and contrast can also be adjusted using the arguments of the [Sigmoidal Contrast Operator](#sigmoidal-contrast).
Another more exacting way of generating a duotone from three colors (the black-point, mid-point and white-point colors) is to use a [Color Lookup Table](#clut) (see below).
Here is just a quick example where I create a very unusual duotone using the colors '`Black`', '`Chocolate`', and '`LemonChiffon`' for the duotone. And yes the black-point color is typically left black, which is why it is usally called *duo*-tone.
  
      convert -size 1x1 xc:Black xc:Chocolate xc:LemonChiffon \
                                       +append     duotone_clut.gif
      convert -size 20x256 gradient: -rotate 90   duotone_clut.gif \
              -interpolate Bicubic -clut       duotone_gradient.gif
      convert rose_grey.jpg   duotone_clut.gif \
              -interpolate Bicubic -clut       rose_duotone.jpg

[![\[IM Output\]](duotone_clut.gif)](duotone_clut.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](duotone_gradient.gif)](duotone_gradient.gif)  
 [![\[IM Output\]](rose_grey.jpg)](rose_grey.jpg) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](duotone_clut.gif)](duotone_clut.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_duotone.jpg)](rose_duotone.jpg)

The advantage of the above is an exact control of the mid-point color (unlike [Tint](#tint) which isn't exact). You can also use any the three colors you like directly, just as in the above example, or use an expanded gradient of the colors for finer control of the colors between the three (or more) control points.
The technique also provides you with a very compact way of storing the specific duotone effect, for repeated and future usage.
Also see [Hald Color Lookup Tables](#hald-clut) for more complex method of saving color changes, that go beyond coloring greyscale images.
### Color Tinting, DIY

One of the biggest problems with "`-tint`" is that it is a grayscale (or vector) operator. That is, it handles each of the red,green,blue channels completely separately to each other. That in turn means that a primary and secondary color like '`blue`' or '`yellow`' are not affected by "`-tint`", even though all the gray levels are.
However thanks to various channel mathematical transforms such as the [FX Operator](../transform/#fx) and the faster [Evaluate and Function Operators](../transform/#evaluate), you can generate your own color overlays to modify the image. That is, to [Tint](#tint) the image in a similar what that the [Colorize Operator](#colorize) does.
For example, here I convert an image's gray-scale brightness level into a semi-transparent overlay of the specific color wanted.
  
      convert test.png  \( +clone -colorspace gray \
                   -function polynomial -4,4,0 -background Gold -alpha shape \) \
              -composite   tint_diy_compose.png

  
[![\[IM Output\]](tint_diy_compose.png)](tint_diy_compose.png)
Warning, this does not preserve image transparency correctly, but it will work fine for fully-opaque images.
Note that unlike tint, any color can be used, including '`black`' as the color is not treated as a vector addition, but an alpha composition. The result is not quite the same as what you would get for a normal tint.
### Color Tinting Overlay

The special [Alpha Composition](../compose/#compose) methods '`Overlay`' and '`Hardlight`' were actually designed with color (and pattern) tinting in mind. These compose methods also will replace mid-tone grays leaving black and white highlights in the image alone.
  
For example here I quickly generate a colored overlay image, and compose it to tint the original image.
  
      convert test.png \( +clone +matte -fill gold -colorize 100% \) \
              -compose overlay -composite  tint_overlay.png

  
[![\[IM Output\]](tint_overlay.png)](tint_overlay.png)
As you can see the alpha composition does not preserve any transparency of the original image, requiring the use of a second alpha composition operation to fix this problem.
  
      convert test.png \
              \( +clone +matte -fill gold -colorize 100% \
                 +clone +swap -compose overlay -composite \) \
              -compose SrcIn -composite  tint_overlay_fixed.png

  
[![\[IM Output\]](tint_overlay_fixed.png)](tint_overlay_fixed.png)
Using '`Overlay`' is much more linear form of tinting than the quadratic function used above, and like "`-tint`" is applied to each channel of the image separately such that primary and secondary colors are also left unchanged.
Also no adjustment control is provided by this alpha composition method, so if you want to control the level of tinting, you will need to adjust the overlay image transparency before applying the tint.
Of course unlike the other tinting methods I have shown so far, you are not limited to tinting a simple color, but can apply a tint using an image, or tile pattern.
  
      convert test.png \
              \( -size 150x100 tile:tile_disks.jpg \
                 +clone +swap -compose overlay -composite \) \
              -compose SrcIn -composite  tint_overlay_pattern.png

  
[![\[IM Output\]](tint_overlay_pattern.png)](tint_overlay_pattern.png)
This however is getting outside the scope of basic color handling so I'll leave image tinting at that.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
The alpha composition method '`HardLight`' will produce the same results as '`Overlay`' but with the source and destination images swapped.
  
This could have been used instead of the "`+swap`" in the last few examples.

------------------------------------------------------------------------

## Global Color Modifiers

### Modulate Brightness, Saturation, and Hue

The "`-modulate`" operator is special in that it modifies an image in the special HSL (hue-saturation-lightness) [colorspace](../color_basics/#colorspace). It converts each color pixel in into this color space and modifies it and converts it back to its original color space.
It takes three values (though later values are optional) as a percentage such that 100 will make no change to an image. For example..
  
      convert  rose:  -modulate 100,100,100  mod_noop.gif

  
[![\[IM Output\]](mod_noop.gif)](mod_noop.gif)
The first value, *brightness* is a multiplier of the images overall brightness.
  
      convert rose:   -modulate 0     mod_bright_0.gif
      convert rose:   -modulate 50    mod_bright_50.gif
      convert rose:   -modulate 80    mod_bright_80.gif
      convert rose:   -modulate 100   mod_bright_100.gif
      convert rose:   -modulate 150   mod_bright_150.gif
      convert rose:   -modulate 200   mod_bright_200.gif

[![\[IM Output\]](mod_bright_0.gif)](mod_bright_0.gif) [![\[IM Output\]](mod_bright_50.gif)](mod_bright_50.gif) [![\[IM Output\]](mod_bright_80.gif)](mod_bright_80.gif) [![\[IM Output\]](mod_bright_100.gif)](mod_bright_100.gif) [![\[IM Output\]](mod_bright_150.gif)](mod_bright_150.gif) [![\[IM Output\]](mod_bright_200.gif)](mod_bright_200.gif)

Note that while a brightness argument of '`0`' will produce a pure black image, you cannot produce a pure white image using this operator on its own.
The second value *saturation* is also a multiplier adjusting the overall amount of color that is present in the image.
  
      convert rose:   -modulate 100,0     mod_sat_0.gif
      convert rose:   -modulate 100,20    mod_sat_20.gif
      convert rose:   -modulate 100,70    mod_sat_70.gif
      convert rose:   -modulate 100,100   mod_sat_100.gif
      convert rose:   -modulate 100,150   mod_sat_150.gif
      convert rose:   -modulate 100,200   mod_sat_200.gif

[![\[IM Output\]](mod_sat_0.gif)](mod_sat_0.gif) [![\[IM Output\]](mod_sat_20.gif)](mod_sat_20.gif) [![\[IM Output\]](mod_sat_70.gif)](mod_sat_70.gif) [![\[IM Output\]](mod_sat_100.gif)](mod_sat_100.gif) [![\[IM Output\]](mod_sat_150.gif)](mod_sat_150.gif) [![\[IM Output\]](mod_sat_200.gif)](mod_sat_200.gif)

A saturation of '`0`' will produce a grayscale image, as was also shown in [Converting Color to Gray-Scale](#grayscale) above. The gray however mixes all three color channels equally, as defined by the HSL colorspace, as such does not produce a true 'intensity' grayscale.
Essentially small values produce more 'pastel' colors, while values larger than '`100`' will produce more cartoon-like colorful images.
Note that as the *brightness* and *saturation* are percentage multipliers, you would need to multiply by a very large number to change almost all the image color values to near maximum. That is you would need to use a *brightness* factor of close to one million, to make all colors except pure black, white.
#### Hue Modulation

The final value, *Hue*, is actually much more useful. It rotates the colors of the image, in a cyclic manner. To achieve this the *Hue* value given produces a 'modulus addition', rather than a multiplication.
However be warned that the hue is rotated using a percentage, and not by an angle. This may seem weird but "`-modulate`" has always been that way.
Conversion formulas between angle and the modulate argument is...
`hue_angle = ( modulate_arg - 100 ) * 180/100`  
 `modulate_arg = ( hue_angle * 100/180 ) + 100`

That means '`100`' (for all three arguments) produces no change. While a value of '`0`' or '`200`' will effectivally negate the colors in the image (but not the intensity).
For example...
  
      convert rose:   -modulate 100,100,0      mod_hue_0.gif
      convert rose:   -modulate 100,100,33.3   mod_hue_33.gif
      convert rose:   -modulate 100,100,66.6   mod_hue_66.gif
      convert rose:   -modulate 100,100,100    mod_hue_100.gif
      convert rose:   -modulate 100,100,133.3  mod_hue_133.gif
      convert rose:   -modulate 100,100,166.6  mod_hue_166.gif
      convert rose:   -modulate 100,100,200    mod_hue_200.gif

  
[![\[IM Output\]](mod_hue_0.gif)](mod_hue_0.gif)  
 0  
(red &lt;-&gt; cyan)
  
[![\[IM Output\]](mod_hue_33.gif)](mod_hue_33.gif)  
 33.3  
(red -&gt; blue)
  
[![\[IM Output\]](mod_hue_66.gif)](mod_hue_66.gif)  
 66.6
  
[![\[IM Output\]](mod_hue_100.gif)](mod_hue_100.gif)  
 100%  
 no-op
  
[![\[IM Output\]](mod_hue_133.gif)](mod_hue_133.gif)  
 133.3
  
[![\[IM Output\]](mod_hue_166.gif)](mod_hue_166.gif)  
 166.6  
(red -&gt; green)
  
[![\[IM Output\]](mod_hue_200.gif)](mod_hue_200.gif)  
 200  
 (same as 0)

As you can see a value of '`33.3`' produces a negative, or counter-clockwise rotation of all the colors by approximately 60 degrees, effectively mapping the red to blue, blue to green, and green to red.
Using values of '`0`' or '`200`' produces a complete 180 degree negation of the colors, without negating the brightness of the image.
Note that hues are cyclic, as such using a value of '`300`' will produce a 360 degree color rotation, and result in no change to the image.
For examples of using 'Hue Modulation' to modify colors in images see, [Chroma Key Masking](../photos/#chroma_key) and [Pins in a Map](../layers/#layer_pins).
These types of operations and more can also be applied using advanced [Color Space](../color_basics/#colorspace) techniques, such as using in [Recolor Matrix Operator](#recolor) (below), but for basic 'modulation' of an image, this operator greatly simplifies things.
For primary color swapping, either [Recolor Matrix Operator](#recolor), or channel swapping (see [Separate/Combine Operators](../color_basics/#combine)), is probably more accurate technique. Though it is much less versatile.
See also [Hald Color Lookup Tables](#hald-clut) for a method by which you can save color change variations, especially changes in Hue, for later reuse.
#### Modulate DIY

You can if really want to "Do It Yourself". You basically convert the image into the appropriate color space, modify the values, and convert back. Remember that in HSL [Color Space](../color_basics/#colorspace), the Green channel holds the Saturation value, and the Blue channel holds the Luminance value.
For example here is the equivalent to a "`-modulate 80,120`" (darken slightly, increase color saturation), using the default HSL colorspace...
  
      convert rose: -colorspace HSL \
              -channel B -evaluate multiply 0.80 \
              -channel G -evaluate multiply 1.20 \
              +channel -colorspace sRGB   modulate_channel.png

[![\[IM Output\]](rose.png)](rose.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](modulate_channel.png)](modulate_channel.png)

Of course if you modify the Hue (red channel) using this method you will need to ensure the final value 'wraps' around (a modulus), rather than simply clipping the value at the maximum or minimum value (both of which is the 'red' hue). As such it is probably easier to just directly use the [Modulate Operator](#modulate), for Hue modifications.
#### Modulate in Other Colorspaces

The biggest problem with "`-modulate`" is when handing images containing a lot of 'near white' colors. As it does its work in HSL colorspace, colors that are off-white will become more 'saturated' as the brightness is reduced. You can see this in the white leaf of the rose image above, which shows lots of color artifacts at a 50% darkening.
This is especially a problem when dealing with JPEG image formats, as it tends to generate off-white colors (actually all colors are generally slightly off in JPEG) due to its lossy compression algorithm. For example...
  
      convert wedding_party_sm.jpg  -modulate 85  modulate_off-white.png

[![\[IM Output\]](wedding_party_sm.jpg)](wedding_party_sm.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](modulate_off-white.png)](modulate_off-white.png)

The problem here is that in HSL all the off white colors were packed into a small 'white point' area of the color space used (a double cone). When brightness is then reduced the off-white colors get expanded as the cone of color expands, causing the off white color to generate a more colorful (saturated) set of off-white colors. That is, small variations in color are exaggerated.
The solution to this is to "`-modulate`" in the HSB colorspace, instead of HSL colorspace.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
The 'B' in HSB, means Brigthness, but is also commonally known as HSV, with using 'V' meaning Value. They are the same colorspace, but 'V' is a confusing term, as a value normally means 'a stored number'.
  
There is also a HSI colorspace, (using 'I' of Intensity) but it is uncommon, and not needed due to the addition of the HCL (where 'L' means Luminance) cyclic colorspace (see below).
In the HSB colorspace, 'white' is not a single point, but a large 'disk', and as such off-whites, are not 'close' to each other. As such when you reduce the brightness, the off-whites contract equally, reducing any slight color variations rather than expanding them. As such the whites just become gray, and not more colorful.
To modulate the image in HSB [Color Space](../color_basics/#colorspace) you can either use the DIY technique (see above) in that colorspace. Or with IM v6.5.3-7 and later, you can [Define an Operational Control](../basics/#define) of '`modulate:colorspace`' with one of the 'Hue' color spaces.
  
      convert wedding_party_sm.jpg \
              -define modulate:colorspace=HSB -modulate 85 \
              modulate_HSB.png

  
[![\[IM Output\]](modulate_HSB.png)](modulate_HSB.png)
Other 'Hue' colorspaces is HWB, and HCL (see next section).
Of course if you resized the image to this small size, an even better solution is NOT to save the image to JPEG, which was the cause of the off-white values. Better still don't save the image at all, until after you are finished, so you can keep all the color values at the best in-memory [quality](../basics/#quality) setting.
The reason HSB colorspace is not used by default for modulate, is because if you brighten an image in this colorspace the colors become more saturated, and bolder, rather than the image becoming more brilliant and whiter.
Here for example is a 150% brighten of the 'rose' image in the default HSL, and a specified HSB colorspace, for comparison.
  
      convert rose:          -modulate 150        mod_bright_HSL.gif
      convert rose: -define modulate:colorspace=HSB \
                             -modulate 150        mod_bright_HSB.gif

  
[![\[IM Output\]](mod_bright_HSL.gif)](mod_bright_HSL.gif)  
HSL
  
[![\[IM Output\]](mod_bright_HSB.gif)](mod_bright_HSB.gif)  
HSB

  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
Before IM v6.4.0-10 the "`-modulate`" operator actually did use HSB color space rather than HSL colorspace. This was changed because of a bug report by a user about the above situation.
  
The point is for some images you are damned if you use HSL, and for other images you are damned if you use HSB colorspace. It just depends on what you are attempting to do!
#### Modulate in LCHab and LCHuv Colorspace

Hue modulation (in HSL or HSB colorpsace) is actually regarded as rather crude. These colorspaces do not take into account a more realistic intensity of the colors. As such rotating between the hues 'blue' and 'yellow' will also generate very large brightness shifts. See [Wikipedia: Disadvantages to HSL Colorspace](http://en.wikipedia.org/wiki/HSL_and_HSV#Disadvantages).
One alternative is to do a Luminance preserving rotation as described on the [Grafica Obscura](http://www.graficaobscura.com) in the "Matrix Operations" Paper. This is complex as the color modifications are being done as part of the operation, as a single calculated matrix operation that is different depending on how much of a rotation is required.
As of IM v6.8.4-7 the [Modulate Operator](#modulate) can also handle the special colorspaces '**`LCHuv`**' and '**`LCHab`**' which are Cylindrical (Hue-Chroma) forms the the respective '**`Luv`**' and '**`Lab`**' colorspaces. see [Wikipedia, Cylindrical LUV, or LCHuv colorspace](http://en.wikipedia.org/wiki/CIELUV#Cylindrical_representation) and [The HCL Colorspace](http://hclcolor.com/) for more information.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The equivelent channels of '**`LCHuv`**' and '**`LCHab`**' colorspaces are reverse to those of the '**`HCL`**' and '**`HCB`**' colorspaces. That is the 'grayscale' intensity equivelent is in the first ('red') channel and Hue is in the third ('Blue') channel of the image.*
For example we do some hue rotations for the red rose using '**`LCHuv`**' colorspace. Compare these with the previous set for the '**`HSL`**' colorspace above.
  
      for i in   0 25 50 75 100 125 150 175;  do
        convert rose:  -define modulate:colorspace=LCHuv \
                                -modulate 100,100,$i     mod_lch_$i.gif
      done

  
[![\[IM Output\]](mod_lch_0.gif)](mod_lch_0.gif)  
 0% & 200%
  
[![\[IM Output\]](mod_lch_25.gif)](mod_lch_25.gif)  
 25%  
(red-&gt;blue)
  
[![\[IM Output\]](mod_lch_50.gif)](mod_lch_50.gif)  
 50%
  
[![\[IM Output\]](mod_lch_75.gif)](mod_lch_75.gif)  
 75%
  
[![\[IM Output\]](mod_lch_100.gif)](mod_lch_100.gif)  
 100%  
 no-op
  
[![\[IM Output\]](mod_lch_125.gif)](mod_lch_125.gif)  
 125%
  
[![\[IM Output\]](mod_lch_150.gif)](mod_lch_150.gif)  
 150%
  
[![\[IM Output\]](mod_lch_175.gif)](mod_lch_175.gif)  
 175%

Note that the hues are spread out differently to the more traditional Hue colorspaces. But more importantly, the intensity of the original image is preserved.
Because of this you will never cycle from a pure primary/secondary color to another pure primary/secondary color, as none of these have the same intensity. The progression of colors over the hues does however flow more smoothly with less sharp 'peaks' at the primary and secondary colors.
Here is a comparison of a simple hue rotation of red to blue for '`LCHuv`' and '`HSL`' in colorspace (using appropriate rotation percentages).
  
[![\[IM Output\]](rose.png)](rose.png)  
 Original
  
![](../img_www/right.gif)
  
[![\[IM Output\]](mod_lch_0.gif)](mod_lch_0.gif)  
 LCHuv  
 0%
  
[![\[IM Output\]](mod_hue_33.gif)](mod_hue_33.gif)  
 HSL/HSB  
 33.3%

Note how the blue is nowhere near as dark, but is a shade that better matches the shade of the original image.
You can also do the same in '**`LCHuv`**' though I found the hue spead more restrictive.
For more information on HCL colorspace hues, see the examples on [The LCH Color Wheel](../color_basics/#colorwheel_LCH).
![](../img_www/warning.gif)![](../img_www/space.gif)
Before IM v6.8.4-7 you would have used the colorspace '**`HCL`**' (introduced IM v6.7.9-1). This colorspace is exacty the same as '**`LCHuv`**' but with the channel order reversed so that 'Hue' was in the first channel, so as to better match '`HCL`' colorspace.
This spacial channel reversal allowed modulate to work properly, without it needing to understand different channel ordering for different colorspaces. This no longer required, so you can now use the more commonly known channel ordering for the cylindrical version of the '`Luv' colorspace.   `
![](../img_www/expert.gif)![](../img_www/space.gif)
*You can also use a '**`LCHab`**' (cylindrical version of the '`Lab') colorspace, however this version has discontinuities for   specific 'impossible' color values, especially in the green area.  It is not   recommended for use with the Modulate Operator.     `*
### Color Matrix Operator

The "`-color-matrix`" operator will recolor images using a matrix technique. That is to say you give it a matrix of values which represents how to linearly mix the various color channel values of an image to produce new color values.
Typical usage is to provide the operator with 9 values, which form three functions (rows) or three multipliers (columns). As such the first three numbers is the color formula for the red' channel. The next for 'green' and so on For example...
  
      convert rose: -color-matrix ' 1 0 0
                                    0 1 0
                                    0 0 1 '   matrix_noop.png

  
[![\[IM Output\]](matrix_noop.png)](matrix_noop.png)
Is equivalent to applying the equations...
  
`red'  `
  
`=  1 * red  +  0 * green + 0 * blue`
  
`green'`
  
`=  0 * red  +  1 * green + 0 * blue`
  
`blue' `
  
`=  0 * red  +  0 * green + 1 * blue`

In this particular case no change is made to the image. The matrix forms a special array, known as an 'identity matrix'.
By mixing up the rows you can use to swap the various channels around. For example here I swap the red and blue channel values.
  
      convert rose: -color-matrix ' 0 0 1
                                    0 1 0
                                    1 0 0 '  matrix_red_blue_swap.png

  
[![\[IM Output\]](matrix_red_blue_swap.png)](matrix_red_blue_swap.png)
Or simply copy the red channel to the other two channels, to extract or separate out the 'red channel' (Also see [Separating Channel Images](../color_basics/#separate))...
  
      convert rose: -color-matrix ' 1 0 0
                                    1 0 0
                                    1 0 0 '  matrix_red_channel.png

  
[![\[IM Output\]](matrix_red_channel.png)](matrix_red_channel.png)
or convert the image to gray-scale image using a 2/5/3 greyscale ratio (See [Converting Color to Gray-Scale](#grayscale))...
  
      convert rose: -color-matrix ' .2 .5 .3
                                    .2 .5 .3
                                    .2 .5 .3 '  matrix_grayscale.png

  
[![\[IM Output\]](matrix_grayscale.png)](matrix_grayscale.png)
  
 You can use a larger matrix of up to a set of 6 rows and columns. These correspond to the channels: '`Red`', '`Green`', '`Blue`', '`Black`' (if set), '`Alpha`' (if set), and a constant.
Note the channels: '`Black`' and '`Alpha`'; must still be provided if the matrix is that large, even though the value itself may not be present or used.
The last constant column is just a simple addition (or subtraction if negative) to the formula. The 6th row (if given) is simply ignored, and not used.
By default the 'matrix' definition follows the same structure as a [User Defined Morphology/Convolution Kernel](../morphology/#user) and is treated as being a 'square' kernel if no size geometry is specified. The offset of the kernel is currently not used.
The given 'array of values' is then overlaid on a larger '6x6 identity matrix' (a diagonal of 1's) before being applied to the image. This internal handling means that you can actually simply the matrixvalue by only a few row of numbers, rather than all of them.
This is especially useful when you need to include the 'constant' in the color calculations, or only want to modify one channel.
For example invert (negate) the image.
  
      convert rose: -color-matrix '6x3: -1  0  0 0 0 1
                                         0 -1  0 0 0 1
                                         0  0 -1 0 0 1'  matrix_negate.png

  
[![\[IM Output\]](matrix_negate.png)](matrix_negate.png)
Set all red channel values to maximum (using the 'constant')...
  
      convert rose: -color-matrix '6x1: 0,0,0,0,0,1'  matrix_red_max.png

  
[![\[IM Output\]](matrix_red_max.png)](matrix_red_max.png)
Because of the overlay on the identity matrix, none of the other channel values are effected, though they are still re-calculated internally.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.6.1-0, "`-color-matrix`" was named "`-recolor`.*
#### Color Matrix Examples

**Sepia Color**, or at least a linear form of that operation
  
      convert rose: -color-matrix ' 0.393 0.769 0.189
                                    0.349 0.686 0.168
                                    0.272 0.534 0.131  ' matrix_sepia.png

  
[![\[IM Output\]](matrix_sepia.png)](matrix_sepia.png)
**Vivid colors**, in a technique called [Digital Velvia](http://www.reflectiveimages.com/digitalvelvia.htm)...
  
      convert rose: -color-matrix '  1.2 -0.1 -0.1
                                    -0.1  1.2 -0.1
                                    -0.1 -0.1  1.2 ' matrix_vivid.png

  
[![\[IM Output\]](matrix_vivid.png)](matrix_vivid.png)
This matrix brighten that color channel while subtracting the colors from the other channels, making colors more vivid in the RGB image. This is not quite the same as using [Modulate](#modulate) to increase an images color saturation by 20%, but it is similar to it.
**Polaroid Color**...
  
      convert rose: -color-matrix \
                '6x3:  1.438 -0.122 -0.016  0 0 -0.03
                      -0.062  1.378 -0.016  0 0  0.05
                      -0.062 -0.122 1.483   0 0 -0.02 ' matrix_polaroid.png

  
[![\[IM Output\]](matrix_polaroid.png)](matrix_polaroid.png)
*Future: Hue rotations using a color matrix*
  
 For more information on using a color matrix see...
-   [Color Matrix Filter Adobe Flash Tutorial](http://www.webwasp.co.uk/tutorials/218/tutorial.php#luminaries)
-   [Color Transformations and the Color Matrix](http://www.c-sharpcorner.com/UploadFile/mahesh/Transformations0512192005050129AM/Transformations05.aspx)
-   [ColorMatrix Unleased](http://rainmeter.net/cms/Tips-ColorMatrixUnleased)
-   [Grafica Obscura - Matrix Operations for Image Processing](http://www.graficaobscura.com/matrix/index.html)
-   [SWF Color Matrix Filter](http://www.m2osw.com/swf_struct_any_filter#swf_filter_colormatrix) (for hue rotate with luminance preservation)

However be warned that most of these implementations use a [Diagonally Transposed](http://en.wikipedia.org/wiki/Transposed) form of the matrix, in which columns form the equation, instead of the rows. Or involve fewer channels (smaller number of rows/columns).
### Solarize Coloring

To "`-solarize`" an image is to basically 'burn' the brightest colors black. The brighter the color, the darker the solarized color is. This happens in photography when chemical film is over exposed.
  
      convert rose:   -solarize 90%     solarize.jpg

  
[![\[IM Output\]](solarize.jpg)](solarize.jpg)
Basically anything above the grayscale level given is negated. So if you give a argument of '`0%`' you basically have a poor man's [Negate Operator](#negate).
For example here is a faked "`-solarize`" using a "`-fx`" mathematical formula.
  
      convert rose:   -fx  '.9>u ? u : 1-u'     solarize_fx.jpg

  
[![\[IM Output\]](solarize_fx.jpg)](solarize_fx.jpg)
This operator is particularly well suited to extracting the midtone gray colors from images.
For example here I use very strong [Sigmoidal Contrast](#sigmoidal) operation to produce a sort of 'fuzzy' threshold at 70% gray. I then [Solarize](#solarize) the result to generate a fuzzy-spike rather than a fuzzy-threshold. A final level adjustment then brings the spike to maximum brightness to generate a 'filament' effect.
  
      convert -size 10x300 gradient: -rotate 90 \
                             -sigmoidal-contrast 50x70%   fuzzy_thres.png
      convert fuzzy_thres.png  -solarize 50%   fuzzy_spike.png
      convert fuzzy_spike.png  -level 0,50%    filament.png

[![\[IM Output\]](fuzzy_thres_pf.gif)](fuzzy_thres_pf.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](fuzzy_spike_pf.gif)](fuzzy_spike_pf.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](filament_pf.gif)](filament_pf.gif)

*ASIDE:* The above images showing 'profile' graphs of the gradient, was generated using the "`im_profile`" in the IM Examples, [Scripts](../scripts/) directory.
Note how anything that is white becomes black, while the mid-tone grays around the central spike are preserved. The fuzziness and placement of the spike is determined by the "`-sigmoidal-contrast`" operator.
I call it a 'filament' as typically the result looks remarkably like glowing electrical filaments, or lightning discharges. See [Random Flux](../canvas/#random_flux) for another example of this effect.
This extraction of mid-tone grays is also put to good use in techniques for generating [Edge Outlines from Bitmap Shapes](../transform/#edge_bitmap), and for the [multiplication of two biased gradients](../transform/#math_multiply).
Another novel use of this operation is in determining if an image is basically a pure black and white sketch or drawing (such as from a book), rather than a shaded gray-scale or color images, See [Determining if an image is: Pure Black and White, or Gray-scale](../compare/#type_bw)

------------------------------------------------------------------------

## Recoloring Images with Lookup Tables

While you can recolor images using the various histogram color adjustments as shown above, there is another technique for recoloring images, simply by 'looking up' the modified values from a pre-prepared color gradient, or "Color Look Up Tables" (Color LUT, or CLUT).
There are two types of Color LUT's: simple one dimensional or 'per-channel' LUT's and 3d color LUT's.
A channel LUT has three independent look-up tables: one each for the R G and B channels. Each entry in the channel LUT maps an input channel value to an output channel value. The red channel of the output image is only effected by the original red value of the input image.
A 3D color LUT however allow the whole color to be replaces as a function of the whole input color. That is the output value of the red channel can be dependent on any or all of the input red, green, and blue values. This is sometimes called channel cross-talk.
### Color (Channel) Lookup Tables

A common requirement of a image processing tool is the ability to replace the whole range of colors, from a pre-prepared table of colors. This allows you to convert images of one set of colors (generally gray-scale) into completely different set of colors, just by looking up its replacement color from a special image.
Of course you do need a 'Look Up Table' image from which to read the replacement colors. For these first few examples, I choose to use a vertical gradient of colors for the LUT so that the IM "`gradient:`" generator can be used to simplify the generation of the 'color lookup table'.
Well so much for the theory. Let try it out by recoloring a simple [gray-Scale Plasma](../canvas/#plasma_grayscale) image, replacing the grayscale with a dark-blue to off-white gradient of colors.
  
      convert -size 100x100 plasma:fractal -virtual-pixel edge -blur 0x5 \
              -shade 140x45  -normalize \
              -size 1x100 xc:black -size 9x100 gradient: \
              +append  gray_image.jpg
      convert -size 10x100  gradient:navy-snow       gradient_ice-sea.png
      convert gray_image.jpg  gradient_ice-sea.png -clut  gray_recolored.jpg

[![\[IM Output\]](gray_image.jpg)](gray_image.jpg) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](gradient_ice-sea.png)](gradient_ice-sea.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](gray_recolored.jpg)](gray_recolored.jpg)

The "`-clut`" operator takes two images. The first is the image to replace color values in, the second is a gradient image that is either a single row, or a single column.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*The "`-clut`" operator was added to IM v6.3.5-8.*
If your IM is too old to understand the "`-clut`" operator or you want to do something out of the ordinary, such as a 2 dimensional color lookup table, then you can roll your own using the [General DIY Operator, FX](../transform/#fx). For example here is a slow, but equivalent command to the above.
  
      convert gray_image.jpg  gradient_ice-sea.png \
              -fx 'v.p{0,u*v.h}'  gray_recolored_fx.jpg

  
[![\[IM Output\]](gray_recolored_fx.jpg)](gray_recolored_fx.jpg)
The problem is that even for a simple process such as the above the "`-fx`" operator is very slow, and has to be designed specifically for either a row or column LUT. But it does work.
The LUT does not have to be very large. For example here we use a very small LUT, with a very limited number of colors.
  
      convert -size 1x6 gradient:navy-snow  gradient_levels.png
      convert gray_image.jpg  gradient_levels.png  -clut  gray_levels.jpg

[![\[IM Output\]](gray_image.jpg)](gray_image.jpg) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](gradient_levels_mag.png)](gradient_levels.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](gray_levels.jpg)](gray_levels.jpg)

I enlarged the gradient image for the web page display above, otherwise it would be too small to see properly. The LUT is in actual fact only 6 pixels in size. However if you look at the result you will see that the Color Lookup Operator smooths out those 6 colors into a smooth gradient.
What is happening is that IM is doing an [Interpolated Lookup](../misc/#interpolate) of the LUT image. That is, instead of just picking the color found, it does a weighted average of all the nearby colors to better represent the LUT. In this particular case, it used the default '`Bilinear`' setting that just links each colored pixel together with linear line segments.
Different "`-interpolate`" settings generate different levels of smoothing of the colors when using a very small color LUT. Here for example I show a various type of interpolated smoothing of the LUT colors.
  
      convert gray_image.jpg  gradient_levels.png \
              -interpolate Integer         -clut  gray_levels_integer.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate NearestNeighbor -clut  gray_levels_nearest.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate Average         -clut  gray_levels_average.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate Blend           -clut  gray_levels_blend.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate BiLinear        -clut  gray_levels_bilinear.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate Catrom          -clut  gray_levels_catrom.jpg
      convert gray_image.jpg  gradient_levels.png \
              -interpolate Spline          -clut  gray_levels_spline.jpg

  
[![\[IM Output\]](gray_levels_integer.jpg)](gray_levels_integer.jpg)  
Integer
  
[![\[IM Output\]](gray_levels_nearest.jpg)](gray_levels_nearest.jpg)  
Nearest
  
[![\[IM Output\]](gray_levels_average.jpg)](gray_levels_average.jpg)  
Average
  
[![\[IM Output\]](gray_levels_blend.jpg)](gray_levels_blend.jpg)  
Blend
  
[![\[IM Output\]](gray_levels_bilinear.jpg)](gray_levels_bilinear.jpg)  
BiLinear
  
[![\[IM Output\]](gray_levels_catrom.jpg)](gray_levels_catrom.jpg)  
Catrom
  
[![\[IM Output\]](gray_levels_spline.jpg)](gray_levels_spline.jpg)  
Spline

The '`Integer`' and '`Nearest`' settings are special in that they do no smoothing colors at all. That is, no new 'mixed colors' will be added, *only* the exact color values present will be used used to color a grayscale image. However note how the lookup of the colors differ between the two. It is a subtle difference but can be very important.
The '`Average`' setting on the other hand also generated bands of color but only using a mix of the colors, resulting in one less color than the size of the color lookup table image. '`Blend`' however mixes '`Average`' and '`Nearest`' together, to add more pixels.
This type of color 'banding' (or [Blocking Artefacts](../filter/#blocking)) is actually rather common for geographic maps, and temperature graphs, as it gives a better representation of the exact shape of the map. The sharp boundary edges are known as iso-lines. Adding a slight one pixel [Blur](../blur/#blur) to the final image can improve the look of those edges, making it look a little smoother, without destroying the color banding.
The '`BiLinear`' setting will also generate banding but only in the form of sharp gradient changes, when the colors change sharply (not in this example). While '`Catrom`' will smooth out the color changes. Finally '`Spline`' will blur the colors, and may not generate any of the colors in the given CLUT.
To avoid interpolation problems, or better define the color gradients, the best idea is to use much longer LUT. Ideally this should cover the full range of possible intensity values. For ImageMagick Q16 (compiled with 16 bit quality) that requires a LUT to have a height of 65536 pixels. But [Pixel Interpolation](../misc/#interpolate) allows you to use a more reasonable LUT gradient image of 500 pixels suitable for most image re-coloring tasks.
Note that the vertical gradient LUT used in the above examples appears upside-down to our eyes, as the black or '`0`' index is at the top of the image. Normally we humans prefer to see gradients with the black level at the bottom (thanks to our evolutionary past).
If you rather save the gradient image the 'right way up' you can "`-flip`" the image as you reading it in. For example lets try a more complex LUT, flipping the vertical gradient before using it on the image.
  
      convert -size 1x33 gradient:wheat-brown gradient:Brown-LawnGreen \
              gradient:DodgerBlue-Navy   -append  gradient_planet.png
      convert gray_image.jpg \
              \( gradient_planet.png -flip \) -clut   gray_planet.jpg

[![\[IM Output\]](gray_image.jpg)](gray_image.jpg) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](gradient_planet.png)](gradient_planet.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](gray_planet.jpg)](gray_planet.jpg)

As you can see for a vertical gradient, flipping it before using makes a lot of sense.
For more examples of generating gradients see [Gradients of Color](../canvas/#gradient).
You may also be interested in a way of tiling greyscale images using a image for each grey level, which can produce even better 'map' like images. See [Dithering with Patterns](../quantize/#diy_symbols).
### Function to Color LUT Conversion

These pre-prepared "Lookup Table Images" (or LUTs) can also be used to greatly increase the speed of very complex and thus slow "`-fx`" operations, so instead of IM interpreting the functional string 3 or 4 times per pixel, it can do a much faster lookup of the replacement color.
The procedure for doing this is quite straight forward, either apply the function to a unmodified linear gradient, or replace the '`u`' in the function with the value '`(i/w)`' or '`(j/h)`' to calculate the replace value based on its position.
For example, in the advanced ['Aqua' Effects](../advanced/#aqua_effects) example, I used a complex "`-fx`" function to adjust the gray-scale output of the [Shade operator](../transform/#shade)". Also as this gray-scale adjustment is also overlaid onto a 'DodgerBlue' shape, there is no reason why the results of both of these operators could not be combined into a single gradient lookup table.
That is, we generate a LUT from the "`-fx`" formula and the color overlay. Also for these examples I decided to generate a single row of pixels rather than a column as I did previously.
  
      convert -size 1x512 gradient: -rotate 90 +matte \
              -fx '3.5u^3 - 5.05u^2 + 2.05u + 0.3' \
              -size 512x1 xc:DodgerBlue -compose Overlay -composite \
              aqua_gradient.png

[![\[IM Output\]](aqua_gradient.png)](aqua_gradient.png)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The polynomial "`-fx`" in the above can now be generated more directly and faster using a [Polynomial Function](../transform/#function_polynomial). For example*
  
    "-function Polynomial 3.5,-5.05,2.05,0.3"

This pre-generated LUT can now be applied to the shaded shape much more quickly at the minimal cost of storing a very small image.
  
      convert -font Candice -pointsize 72 -background None label:A \
              -trim +repage  aqua_mask.png
      convert aqua_mask.png -alpha Extract -blur 0x6 -shade 120x21 \
              -alpha On -normalize  aqua_shade.png
      convert aqua_shade.png  aqua_gradient.png -clut aqua_font.png

[![\[IM Output\]](aqua_mask.png)](aqua_mask.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](aqua_shade.png)](aqua_shade.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](aqua_font.png)](aqua_font.png)  
 WARNING: the above is incomplete (edges have not been darkened)

As you can see, the result is very effective, and once an appropriate LUT gradient has been generated, you can re-use the same gradient over and over, as many times as you want.
#### CLUT and Transparency Handling

The "`-clut`" operator is controlled by the "`-channel`" setting, but in reality, it only replaces the individual channel values within the image.
That means that normally each individual channel of the source image is used to 'lookup' the replacement value for just that channel from the color lookup table. That includes the alpha/matte channel which is usually very inconvenient, and difficult to apply.
Typically the "`-clut`" operator is used to either colorize a gray-scale source image, (see previous examples), OR it is used to do a histogram adjustment of a color image using a gray-scale CLUT (Color Lookup Table). In other words, usually one of the images will typically be gray-scale.
As of IM v6.4.9-8, if a "`-channel`" setting specifies that if you are wanting to replace/adjust the alpha channel of an image (an '`A`' is present), and either the 'source' image or 'CLUT' image has no alpha/matte channel defined, then IM will assume that that image is gray-scale, and will act accordingly.
For example, here I generate a simple blurred triangle, as a grey-scale image. I can then color using a Color Lookup Table that includes transparency. I did not flip the CLUT image this time, so the black replacement will be at the top and white replacement at the bottom.
  
      convert -size 100x100 xc:  -draw 'polygon 50,10 10,80 90,80' \
              -blur 0x10  blurred_shape.jpg
      convert -size 1x5 xc:none \
              -draw 'fill red    point 0,2' \
              -draw 'fill yellow rectangle 0,0 0,1'   gradient_border.png
      convert blurred_shape.jpg -alpha off    gradient_border.png \
              -channel RGBA  -interpolate integer -clut  clut_shape.png

[![\[IM Output\]](blurred_shape.jpg)](blurred_shape.jpg) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](gradient_border.png)](gradient_border.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](clut_shape.png)](clut_shape.png)

Remember the above will only work as expected if the gray-scale image has no alpha channel (turned off using either "`-alpha off`" or "`+matte`"), and you specify that you also want to lookup alpha channel values (using "`-channel RGBA`").
And here is the other special case where were have an image with transparency (and alpha channel) that needs to be adjusted using a gray-scale histogram adjustment gradient (with no alpha channel enabled).
  
      convert -size 100x100 xc:none -draw 'polygon 50,10 10,80 90,80' \
              tile_disks.jpg -compose In -composite shape_triangle.gif
      convert shape_triangle.gif -channel A -blur 0x10 +channel shape_blurred.png
      convert -size 1x50 gradient: xc:black -append -flip \
              -sigmoidal-contrast 6x0%  feather_histogram.jpg
      convert shape_blurred.png \( feather_histogram.jpg -alpha off \) \
              -channel A    -clut    shape_feathered.png

[![\[IM Output\]](shape_triangle.gif)](shape_triangle.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](shape_blurred.png)](shape_blurred.png) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](feather_histogram.jpg)](feather_histogram.jpg) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](shape_feathered.png)](shape_feathered.png)

The above is a typical [Image Feathering](../blur/#feathering) problem. The 'black' halo in the intermediate image is caused by the "`-blur`" operation making the fully-transparent areas surrounding the triangle visible. As fully-transparent has an undefined color, IM defaults to black. The CLUT image itself was designed to ensure that any pixel that was less than 50% transparent will be turned fully-transparent, effectively making the previously fully transparent parts of the image, transparent again.
For this example I over-do the initial 'blur', then over-correct the alpha channel adjustment. The result is a sever rounding of the points of the triangle. For normal image feathering would typically use much smaller values for both the "`-blur`" and the "`-sigmoidal-contrast`" alpha adjustment.
[Fred Weinhaus](http://www.fmwconcepts.com/imagemagick/), has implemented a blurred feathering technique in his "[feather](http://www.fmwconcepts.com/imagemagick/feather/)" script, to make it easier to use.
### Hald 3D Color Lookup Tables

As of IM v6.5.3-4 you can now also use a full 3D Color Lookup Table which can be used to directly replace all the colors of multiple images. That is, instead of just looking up the value of each each color channel as a separate entity (as in the [CLUT](#clut) above), the whole color is used to lookup the new color.
However a 3D color tables usually require special file formats to correct store the 3D array of color values. However by using a special arrangement of color values the 3D table can be stored into a 2D image known as a **Hald Color LUT**. This is just a normal image and as such ANY good image file format can be used to save a Hald 3D Color LUT.
For more details and examples of HALD Images, see the official website [Hald Images, Clut Technology](http://www.quelsolaar.com/technology/clut.html).
To generate a Hald 3D color table, use the '`HALD:{level}`' image generator. For example, here is a small one that I have enlarged so you can see the individual pixels...
  
      convert   hald:3    hald_3.png

[![\[IM Output\]](hald_3_lg.png)](hald_3_lg.png)

The table holds a color cube with a side of '`{level}2`' colors or 9 colors. The full color cube contains '`9 × 9 × 9`' colors, giving a total of 729 colors, which is stored in a image of that numbers square root, or 27x27 pixels.
The colors are stored so the first 9 colors (in the top-left corner) forms a gradient going from 'pure-black' to 'pure-red'. Every 9<sup>th</sup> color then forms a gradient in 'green', and every 81<sup>st</sup> color will form a gradient of 'blue'. The last color in the bottom-right corner is 'pure-white'. You can think of the image as an even simpler 1D array of pixels that are referenced as a 3D color cube, if it helps you to imagine it.
Now this is only a small HALD CLUT image. More typically you would use at least a level 8 Hald (*the default*), which will hold a color cube with 64 colors per side, or 64^3 = 262144 colors, and produce an image that is 512x512 pixels in size. and saves into into an approximate 10Kbyte PNG image. This is not all 8 bit colors but is quite good.
For a HALD image with every 8 bits color, you would need a level 16 version, producing a 4096x4096 image. Whcih just does to prove that even normal digital camera images generally can not hold every posible 8 bit color.
However a smaller Hald image can be used, as IM will interpolate the neighbouring 8 colors from the Hald to work out the final color for the lookup replacement. It will simply not be as good a representation as a larger version. Hald images larger than 8 are not recommended, and would require very large images, of at least 16 bits per value depth to hold it.
Now these generated hald images are the 'identity' or 'no-op' CLUT images. That is, they are the normal colors values forming the 3D color cube, and as such will produce no change the image. For example lets apply a 'no-op' Hald image, using the "`-hald-clut`" operator...
  
      convert rose:   hald_3.png -hald-clut   rose_hald_noop.png

[![\[IM Output\]](rose.png)](rose.png) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](hald_3.png)](hald_3.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_hald_noop.png)](rose_hald_noop.png)

This image is exactly the same as the original, and the Hald image contained no changes.
However by modifying the Hald image, either by hand, or using a color modification, then you can substitute the original colors for the modified colors. For example here I create a blended-sepia-tone color scheme...
  
      convert hald_3.png \( +clone -sepia-tone 60% \) -average hald_sepia.png
      convert rose.png   hald_sepia.png -hald-clut   rose_hald_sepia.png

[![\[IM Output\]](rose.png)](rose.png) ![==&gt;](../img_www/plus.gif) [![\[IM Output\]](hald_sepia.png)](hald_sepia.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](rose_hald_sepia.png)](rose_hald_sepia.png)

Of course if you can apply a specific color modification to a Hald image, you can also apply it to the actual image directly too. But you can now save your color modifications to reuse them, and can then be applied as many times as like. That means you can spend your effort on the halt, and save it for the future.
You can also send, or download Hald CLUT images for other people and even other applications. You could even directly edit the colors in a Hald, using a image editor like "`Gimp`" or "`Photoshop`", or if saved in a [Enumerated Pixel Text Image](../files/#txt) use a plain text editor! All this is especially the case for very complex color modifications
*Please mail me any Hald CLUT images you have found interesting or useful, and I will example them here. You will be credited, here as well!*
#### Hald CLUT Limitations

Unlike the simpler 1 Dimensional gradient lookup using the [CLUT Operator](#clut) you can use a Hald CLUT to rotate colors. For example swap red and blue colors. It is a much more versatile CLUT method. However it is not as good for doing simpler things like coloring a gray-scale image, or doing a histogram adjustment of color values.
It can also replace colors with transparent, or semi-transparent values, by saving such replacement colors in the Hald CLUT image. However this replacement lookup is by color only. You cannot use it to replace transparent colors in specific ways. It isn't after all a 4D color lookup hyper-cube!
#### Color Replacement using Hald CLUT

Now as the whole color value is used to lookup the color replacement, you could also use this as a method of directly replacing all the colors in an image with some other color.
However as IM currently does a linear interpolated lookup of the Hald, you will need to set the replacement color in all 8 neighbouring color cells of the 3D color cube.
**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

*This needs more work, and may need a 'nearest-neighbour' Hald Lookup setting (say using -interpolate), rather than a 3D linear interpolated lookup to work better for specific color replacement. Also some easy way of locating specific colors in a Hald (nearest-neighbour, or the 8 neighbours) would make this a lot easier.*
*If you have ideas, suggestions, or better still small examples, then please contribute by mailing them to me, or the IM Discussion Forums*
Another idea is that if you have two images, the original and the converted, then it should be possible to fill-in a Hald CLUT image from the comparison of the two images. When the immediate colors have been filled in the rest of the color cube should be able to be at least roughly derived by curve fitting the colors that are present. That is, create a 4-D color surface from the color changes discovered.
When complete than you can apply the Hald CLUT to any other image so as to either make the same color transformation (in either direction) to any other image.
### Full Color Map Replacement

FUTURE: Replace all the colors in one color map with colors in another color map. Suggestions as to how to best do this is welcome, or programmers to implement some image color map function. One method may be to use ideas presented in [Dithering with Symbols](../quantize/#diy_symbols).
The best known solution (but hardly ideal) is currently provided by Fred Weinhaus in is "`mapcolors`" script. This script essentially maps each color one at a time, masking the pixels involved from one image into a new initially blank image.
Another idea is to somehow map a 3 dimentional color replacement into a [HALD Color Table](#hald). This will not just map the specified colors, but also re-map the colors between the specified colors in a logical way. *HALD generator wanted.*

------------------------------------------------------------------------

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

    More color options yet to be looked at in detail...

      -contrast
      -brightness-contrast

    Color Cycling?
        -cycle     shift colormap (for animations of fractals???)

    Chromaticity Color Points???
       –white-point x,y
       –red-primary x,y
       –green-primary x,y
       –blue-primary x,y


    Thresholds  (after negation)
      Specifically  -white-threshold and -black-threshold

------------------------------------------------------------------------

Created: 19 December 2003  
 Updated: 6 October 2011  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/color_mods/`
