# Displacement Bugs -- Partially Fixed

**Index**
[![](../../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../../)
[![](../../img_www/granitesm_left.gif) Known and Fixed Bugs Index](../)

This is a demonstration of numerous bugs that I found in the "`composite`" commands "`-displace`" method, in IM versions 6.2.8 and before.

Strictly speaking this method is not a composition method, but a multi-image transformation mapped, image warping operation.
It could easily be simulated using the new DIY "`-fx`" operator.

This page is for reference for older IM users who may still have to deal with this bug.
The examples on this page have not been re-created when/if the bug was fixed.

------------------------------------------------------------------------

# Displacement Map Bugs

Before looking at these bugs you should look at the full description of the "`-displace`" composition method, in [Displacement Maps](../../displace/#displacement_maps).

This is important to the understanding of the problems, as the method is actually more of "a mapped offset color lookup", than a "mapped image displacement".

## Composite 'Masking' Interference -- Broken

Have a look at this displacement result.

~~~
convert -size 100x100 xc:grey50 -draw 'circle 50,50 25,50' dismap.png

composite dismap.png dismap.png dismap.png  -displace 20x20 displaced.jpg
~~~

[![\[IM Output\]](dismap.png)](dismap.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](displaced.jpg)](displaced.jpg)

This is really caused by the way the "`composite`" command actually handles mask images.
This is detailed on the page for [Composite Mask Bug](../composite_mask/).
What is going on is that internally the Y displacement map (mask image) is merged with the X displacement map (overlay image) to replace that images matte (or alpha) channel.

However in the above the Y displacement map has a fully-opaque, transparency channel already, as such the color components of the image was ignored and the images existing matte channel was used instead.
The result is thus equivalent to...

~~~
composite dismap.png dismap.png xc:white'[100x100]' \
           -displace 20x20   displace_masked.jpg
~~~


[![\[IM Output\]](displace_masked.jpg)](displace_masked.jpg)

In other words, the *Y displacement* color was completely ignored and treated as if it was just a purely white mask.
IE displace everything downward by the Y amplitude, then only the parts of the original image within the circle to the left as well.

Not good.

To fix this, make sure neither of the single displacement map images contain a matte or alpha channel.
The background, or input image on the other hand can contain transparency information without problems.

~~~
composite dismap.png  dismap.png  dismap.png \
                           +matte  -displace 20x20 displaced_matte.jpg
~~~

[![\[IM Output\]](dismap.png)](dismap.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](displaced_matte.jpg)](displaced_matte.jpg)

As you can see this time the image was displaced correctly.
The extra cresent of pixels in the above is caused by the anti-aliased edge of the drawn circle, and is correct.

Another side effect of this internal handling is that if a single source image is used, which has a transparency channel in it, and no mask image is provided, then the X offset will come from the color intensity, while the Y offset will be provided by the images transparency channel!

To fix this 'masking' bugs properly, "`-displace`" should be separated from alpha composition, as it really is a image transformation, rather that alpha composition.

## Inconsistent Displacement Direction -- Fixed 6.2.8-1

Also if you look at the above, you will see that while black X displacement displaces color to the right (positive displacement, or negative offset), while Y displacement for black is upward (negative displacement, or positive offset).

One of these directions is obviously wrong, and according to the manual it is the X displacement that is incorrect, as black is suposed to be a negative displacement.

The bug was fixed in IM v6.2.8-1 by inverting the Y displacement direction (making black a negative offset to the color lookup, rather than a negative displacement).
This was done as it would have the more minimal impact on previous usage of this command.

## Single Displacement Map Arguments -- Fixed 6.2.8-1

When only one map is give, it is used for BOTH X and Y placements, regardless of the amplitude arguments given!

This appears to be a bug, and for for now should be avoided.
As such none of the examples above use a single map style.

Results seen for -displacement arguments with one displacement map.
(EG: no 'mask' image provided)

~~~
composite dismap.png +matte dismap.png -displace 15    displaced_1.jpg
composite dismap.png +matte dismap.png -displace 15x0  displaced_x.jpg
composite dismap.png +matte dismap.png -displace 0x30  displaced_y.jpg
composite dismap.png +matte dismap.png -displace 15x30 displaced_xy.jpg
~~~

[![\[IM Output\]](dismap.png)](dismap.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](displaced_1.jpg)](displaced_1.jpg)
[![\[IM Output\]](displaced_x.jpg)](displaced_x.jpg)
[![\[IM Output\]](displaced_y.jpg)](displaced_y.jpg)
[![\[IM Output\]](displaced_xy.jpg)](displaced_xy.jpg)

From the above you can see that a single value argument to "`-displace`" will displace the image within the black region in both the X and Y directions.

However the last three images show that only the first *X amplitude* value is used for both X and Y displacement amplitudes, regardless of if two values are provided or what those values are.

In other words only the first image in generating in the above is correct, as documented by the IM manual.
And other three images are wrong!.

------------------------------------------------------------------------

Created: 9 June 2006  
 Updated: 10 June 2006  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/bugs/displace/`
