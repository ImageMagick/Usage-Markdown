# Composite Mask Bug - Fixed

**Index**
[![](../../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../../)
[![](../../img_www/granitesm_left.gif) Known and Fixed Bugs Index](../)
The following is a demonstration of a known bug, in the handling of composite mask for ALL alpha composition modes. Some versions of IM trialed a different way of fixing that worked for black an white shape mask, but not a greyscale blend of the results. This is an on going issue.
The following is a demonstration of a known fixed bug in the handling of composite mask for ALL alpha composition modes. Before it was fixed composition masking only worked correctly for the default 'Over' composition of images which did not have any existing alpha channel transparency.
This page is for reference for older IM users who may still have to deal with this bug. The examples on this page have not been re-created since the bug was fixed.

------------------------------------------------------------------------

The "`composite`" command and "`-composite`" operator will also take a third masking image which is suposed to limit the area effected by the "`-compose`" method.
For example given two images, and a *mask* image you can overlay part of the *source* image onto the *background* image, as defined by that mask. Please note however that the *background* image still defines the final size of resulting image.
  
        convert -size 70x70 xc:black \
                -fill white   -draw 'circle 35,35 35,5' \
                -fill black   -draw 'circle 28,30 35,5'   moon_mask.gif
        composite tile_water.jpg tile_aqua.jpg \
                  moon_mask.gif  +matte     mask_over.png
     

[![\[IM Output\]](tile_water.jpg)](tile_water.jpg) [![\[IM Output\]](tile_aqua.jpg)](tile_aqua.jpg) [![\[IM Output\]](moon_mask.gif)](moon_mask.gif) ![==&gt;](../../img_www/right.gif) [![\[IM Output\]](mask_over.png)](mask_over.png)

That is the normal working an use of a composite mask operation, and works very well. But it ONLY works when using a mask to select from two fully-opaque images!

------------------------------------------------------------------------

The problems arise when we want to use this mask with images that already have a alpha channel. That is we want to use the mask to limit the area in which the compose operation is applied (as defined by the SVG standard.)
Lets use some colored circles for the source, background, and masking images...
  
      convert -size 60x60 xc:none -fill red    -draw 'circle 30,21 30,3'  src.png
      convert -size 60x60 xc:none -fill '#0F0' -draw 'circle 21,39 24,57' bgnd.png
      convert -size 60x60 xc:black -fill white -draw 'circle 39,39 36,57' mask.png
     

[![\[IM Output\]](src.png)](src.png) [![\[IM Output\]](bgnd.png)](bgnd.png) [![\[IM Output\]](mask.png)](mask.png)

And apply them, again using an 'Over' compose method...
  
        composite src.png  bgnd.png   mask.png   mask_masked.png
     

  
[![\[IM Output\]](mask_masked.png)](mask_masked.png)
Notice how the red circle source image is overlaid as if its alpha channel was replaced by the alpha channel of the blue masking image. That the pixels which are supposed to be fully-transparent black have suddenly became visible!
What is happening is that at this time the above is equivalent to...
  
        composite mask.png  src.png +matte -compose CopyOpacity  miff:- |\
          composite  -  bgnd.png    mask_masked_equiv.png
     

  
[![\[IM Output\]](mask_masked_equiv.png)](mask_masked_equiv.png)
However what it should have generated was something like...
  
        composite mask.png  src.png  -compose DstIn  miff:- |\
          composite  -  bgnd.png    mask_masked_true.png
     

  
[![\[IM Output\]](mask_masked_true.png)](mask_masked_true.png)
WARNING: The above is NOT a generic solution, and while close to the correct result, is not actually a perfectly correct result.
Because currently a composite masked operation is not performing a proper area limited operation, it use is limited to only combining two matte images (generally textures) using a mask to select what image is visible.
Also using anything other than an '`Over`' compose method probably result in other unexpected results.

------------------------------------------------------------------------

### Correct Operation Masking

The correct fix for users with older versions of IM is NOT simple....
This is provided purely for reference, and as the bug was fixed in IM v6.3.5 and the addition of other image operation masking techniques such as "`-clip-mask`". It basically shows, the true complexity image mask overlaying.

------------------------------------------------------------------------

There are a number of methods can be used to generated a 'mask limited composite operation'. But the method which is most generic and should work with ALL alpha composition methods is...
> *To do the alpha composition (with whatever "`-compose`" method the user requested) as normal, but then then use the mask to 'blend' the original image with the result, to produce the masked limited result.*

This is what I would have expected a 'masked' solution to really be.
Currently however using a mask to blend two images together is a tricky matter, but is can be done as shown below.
  
        composite src.png bgnd.png                                 composed.png
        composite mask.png mask.png  +matte -compose CopyOpacity   alpha_mask.png

        composite alpha_mask.png bgnd.png      -compose DstOut  bgnd_masked.png
        composite alpha_mask.png composed.png  -compose DstIn   composed_masked.png

        composite bgnd_masked.png composed_masked.png -compose Plus  result.png
     

[![\[IM Output\]](src.png)](src.png)
![ +](../../img_www/plus.gif)
[![\[IM Output\]](bgnd.png)](bgnd.png)
![==&gt;](../../img_www/right.gif)
[![\[IM Output\]](composed.png)](composed.png)
  
Do the Normal Alpha Composition of the two images
[![\[IM Output\]](alpha_mask.png)](alpha_mask.png)
![ +](../../img_www/plus.gif)
[![\[IM Output\]](composed.png)](composed.png)
![==&gt;](../../img_www/right.gif)
[![\[IM Output\]](bgnd_masked.png)](bgnd_masked.png)
![ +](../../img_www/plus.gif)
[![\[IM Output\]](composed_masked.png)](composed_masked.png)
  
Use the mask to divide the results in unchanged and changed parts
[![\[IM Output\]](bgnd_masked.png)](bgnd_masked.png)
![ +](../../img_www/plus.gif)
[![\[IM Output\]](composed_masked.png)](composed_masked.png)
![==&gt;](../../img_www/right.gif)
[![\[IM Output\]](result.png)](result.png)
  
Add these parts together to blend the result (EG: masked blend of result)

ASIDE: The extra step using '`CopyOpacity`' is to convert any pure greyscale mask into a image with an alpha mask. While this is not needed for this example, it will allow you to use a greyscale mask with the alpha composition methods, '`DstIn`' and '`DstOut`', as well as '`Plus`' to blend the images together properly.
Note that the above 'blended' the images together. You can NOT just 'overlay' the masked result onto the final image, as that will produce incorrect results. Specifically it would result in the colors being overlaid multiple times, which for semi-transparent pixels will produce a more opaque result than is correct.
I recommend the creation of an internal 'Mask blend' type operation as a faster and simpler method of doing the whole thing. This would be the only 'three image' operation that should be needed for alpha composition, other that [2-Dimensional Displacement Mapping](../../compose/#displace_2d).

------------------------------------------------------------------------

Created: 26 September 2005  
 Updated: 18 June 2007  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/bugs/composite_mask/`
