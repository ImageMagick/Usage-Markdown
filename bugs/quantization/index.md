# Quantization and Transparent Colors

Exploration of the distance algorithm used by [-colors](../option_link.cgi?colors) quantization (color reduction) with regards to transparent colors.

------------------------------------------------------------------------

## Quantization vs Dithering -- Where is the bug?

The problem with debugging the color quantization process is separating color selection (quantization) from the actual replacement of colors (dither).

At this time there is no perfect method of extracting the exact color table that quantization selected.
Viewing those colors to see how they are arranged in 3D Color Space is another problem.

Even if dithering is turned off you still need to replace colors, which requires a fast way of determining exactly what color should be used, and currently in Imagemagick this is NOT a straightforward.

------------------------------------------------------------------------

## Quantization and Color Spacing

Quantization of a gradient should space colors along the gradient equally:

~~~
convert -size 20x640  gradient: -rotate 90    gradient_gray.png
convert gradient_gray.png  +dither  -colors 3   gray_3.png
convert gradient_gray.png  +dither  -colors 4   gray_4.png
convert gradient_gray.png  +dither  -colors 5   gray_5.png
convert gradient_gray.png  +dither  -colors 6   gray_6.png
convert gradient_gray.png  +dither  -colors 7   gray_7.png
convert gradient_gray.png  +dither  -colors 8   gray_8.png
convert gradient_gray.png  +dither  -colors 9   gray_9.png
~~~

> -: 3: 4: 5: 6: 7: 8: 9:   As you can see it is working, though some of the color ranges are not very equal.
> Not only that but '9' colors did not generate 9 colors!
> This seems to get worse for a linear but non-standard color gradient...

~~~
convert -size 20x640  gradient:wheat-tomato -rotate 90  gradient_color.png
convert gradient_color.png  +dither  -colors 3   color_3.png
convert gradient_color.png  +dither  -colors 4   color_4.png
convert gradient_color.png  +dither  -colors 5   color_5.png
convert gradient_color.png  +dither  -colors 6   color_6.png
convert gradient_color.png  +dither  -colors 7   color_7.png
convert gradient_color.png  +dither  -colors 8   color_8.png
convert gradient_color.png  +dither  -colors 9   color_9.png
~~~

> -: 3: 4: 5: 6: 7: 8: 9:   The above clearly shows that the current (IM 6.6.9) is not acceptable for low numbers of colors, which is typically the case when quantization is being specifically used.
> Of course IM does do a great job for the most common quantization case, that of 256 color quantization for GIF images.
> It only breaks down badly for low quantization as above.
> A option here is the addition of new methods of quantization for low color cases.

------------------------------------------------------------------------

## Quantization and Transparent Colors

This is a continuation of the previous bug report on [Fuzz Color Distance Bug](../fuzz_distance/) now (IM 6.6.8) fixed, but this time looking at quantization issues with transparency.

In summary all fully-transparent colors should be classed as being equal, but also equi-distant from all fully-opaque colors.

As a result color quantizatation should concern itself more with opaque colors it should still generate equal amounts of semi-transparent colors accross a range.

In this example a linear greyscale and transparency gradient is generated, and then replaces 'similar colors' to full-transparency.

~~~
convert -size 100x100 gradient: \( +clone -rotate 90 \) +swap \
        -compose CopyOpacity -composite  gradient_trans.png
convert gradient_trans.png +dither -colors 4  trans_4.png
convert gradient_trans.png +dither -colors 8  trans_8.png
convert gradient_trans.png +dither -colors 16 trans_16.png
~~~

[![\[IM Output\]](gradient_trans.png)](gradient_trans.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](trans_4.png)](trans_4.png)
[![\[IM Output\]](trans_8.png)](trans_8.png)
[![\[IM Output\]](trans_16.png)](trans_16.png)


Note the "`-quantize transparent`" setting forces quantization to ignore transparency channel.

~~~
convert gradient_trans.png -quantize transparent \
        +dither -colors 16 trans_16_trans.png
~~~

[![\[IM Output\]](trans_16_trans.png)](trans_16_trans.png)

The major problem with dithering involving semi-transparency is that color selection needs to actually prefer fully-opaque, and at least one fully-transparent color.
Normal quantization however has a tendancy to generate almost-fully-transparent, and near-opaque colors, which is generally not acceptable in this type of image work.

---
title: Quantization and Transparent Colors
created: 3 May 2011  
updated: 3 May 2011  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.9
url: http://www.imagemagick.org/Usage/bugs/quantization/
---
