# Fourier Transforms

[FFT Multiplication and Division](fft_math/) (low level examples - sub-page)

------------------------------------------------------------------------

## Introduction {#introduction}

One of the hardest concepts to comprehend in image processing is Fourier Transforms.
There are two reasons for this.
First, it is mathematically advanced and second, the resulting images, which do not resemble the original image, are hard to interpret.

Nevertheless, utilizing Fourier Transforms can provide new ways to do familiar processing such as enhancing brightness and contrast, blurring, sharpening and noise removal.
But it can also provide new capabilities that one cannot do in the normal image domain.
These include deconvolution (also known as deblurring) of typical camera distortions such as motion blur and lens defocus and image matching using normalized cross correlation.

It is the goal of this page to try to explain the background and simplified mathematics of the Fourier Transform and to give examples of the processing that one can do by using the Fourier Transform.

If you find this too much, you can skip it and simply focus on the properties and examples, starting with [FFT/IFT In ImageMagick](#im_fft)

For those interested, another nice simple discussion, including analogies to optics, can be found at [An Intuitive Explanation of Fourier Theory](http://cns-alumni.bu.edu/~slehar/fourier/fourier.html).

The lecture notes from Vanderbilt University School Of Engineering are also very informative for the more mathematically inclined: [1 & 2 Dimensional Fourier Transforms](http://ia350624.us.archive.org/2/items/Lectures_on_Image_Processing/EECE253_06_FourierTransform.pdf) and [Frequency Filtering](http://ia350625.us.archive.org/2/items/Lectures_on_Image_Processing/EECE253_08_FrequencyFiltering.pdf).

Other mathematical references include Wikipedia pages on [Fourier Transform](http://en.wikipedia.org/wiki/Fourier_transform), [Discrete Fourier Transform](http://en.wikipedia.org/wiki/Discrete_Fourier_transform) and [Fast Fourier Transform](http://en.wikipedia.org/wiki/Fast_Fourier_transform) as well as [Complex Numbers](http://en.wikipedia.org/wiki/Complex_numbers).

*My thanks to Sean Burke for his coding of the original demo and to ImageMagick's creator for integrating it into ImageMagick.
Both were heroic efforts.*

Many of the examples use a [HDRI Version of ImageMagick](../basics/#hdri) which is needed to preserve accuracy of the transformed images.
It is recommended that you compile a personal HDRI version if you want to make the most of these techniques.

------------------------------------------------------------------------

## The Fourier Transform {#fourier_transform}

An image normally consists of an array of 'pixels' each of which is defined by a set of values: red, green, blue and sometimes transparency as well.
But for our purposes here we will ignore transparency.
Thus, each of the red, green and blue 'channels' contains a set of 'intensity' or 'grayscale' values.

This is known as a raster image '*in the spatial domain*'.
This is just a fancy way of saying, the image is defined by the 'intensity values' it has at each 'location' or 'position in space'.

But an image can also be represented in another way, known as the image's '*frequency domain*'.
In this domain, each image channel is represented in terms of sinusoidal waves.

In such a '*frequency domain*', each channel has 'amplitude' values that are stored in locations based not on X,Y 'spatial' coordinates, but on X,Y 'frequencies'.
Since this is a digital representation, the frequencies are multiples of a 'smallest' or unit frequency and the pixel coordinates represent the indices or integer multiples of this unit frequency.

This follows from the principle that "any well-behaved function can be represented by a superposition (combination or sum) of sinusoidal waves".
In other words, the 'frequency domain' representation is just another way to store and reproduce the 'spatial domain' image.

But how can an image be represented as a 'wave'?

### Images are Waves {#waves}

Well if we take a single row or column of pixel from *any* image, and graph it (generated using "gnuplot" using the script "`im_profile`"), you will find that it looks rather like a wave.

~~~
convert holocaust_tn.gif -colorspace gray miff:- |\
  im_profile -s - image_profile.gif
~~~

[![\[IM Output\]](holocaust_tn.gif)](holocaust_tn.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](image_profile.gif)](image_profile.gif)

If the fluctuations were more regular in spacing and amplitude, you would get something more like a wave pattern, such as...

~~~
convert -size 20x150 gradient: -rotate 90 \
        -function sinusoid 3.5,0,.4   wave.gif
im_profile -s wave.gif wave_profile.gif
~~~

[![\[IM Output\]](wave.gif)](wave.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](wave_profile.gif)](wave_profile.gif)

However, while this regular wave pattern is vaguely similar to the image profile shown above, it is too regular.

If you were to add more waves together though, you could make a pattern that is even closer to the one from the image.

~~~
convert -size 1x150 gradient: -rotate 90 \
        -function sinusoid 3.5,0,.25,.25     wave_1.png
convert -size 1x150 gradient: -rotate 90 \
        -function sinusoid 1.5,-90,.13,.15   wave_2.png
convert -size 1x150 gradient: -rotate 90 \
        -function sinusoid 0.6,-90,.07,.1    wave_3.png

convert wave_1.png wave_2.png wave_3.png \
        -evaluate-sequence add added_waves.png
~~~

[![\[IM Output\]](wave_1_pf.gif)](wave_1_pf.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](wave_2_pf.gif)](wave_2_pf.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](wave_3_pf.gif)](wave_3_pf.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](added_waves_pf.gif)](added_waves_pf.gif)

See also [Adding Biased Gradients](../transform/#math_addition) for a alternative example to the above.

This '*wave superposition*' (addition of waves) is much closer, but still does not exactly match the image pattern.
However, you can continue in this manner, adding more waves and adjusting them, so the resulting composite wave gets closer and closer to the actual profile of the original image.
Eventually by adding enough waves you can exactly reproduce the original profile of the image.

This was the discovery made by the mathematician [Joseph Fourier](http://en.wikipedia.org/wiki/Joseph_Fourier).
A modern interpretation of which states that "any well-behaved function can be represented by a superposition of sinusoidal waves".

In other words, by adding together a sufficient number of sine waves of just the right frequency and amplitude, you can reproduce any fluctuating pattern.
Therefore, the 'frequency domain' representation is just another way to store and reproduce the 'spatial domain' image.

The '*Fourier Transform*' is then the process of working out what 'waves' comprise an image, just as was done in the above example.

### 2 Dimensional Waves in Images {#waves_2d}

The above shows one example of how you can approximate the profile of a single row of an image with multiple sine waves.
However, images are 2 dimensional, and as such the waves used to represent an image in the 'frequency domain' also need to be two dimensional.

Here is an example of one such 2 dimensional wave.

The wave has a number of components to it.

*Image example*
  

------------------------------------------------------------------------

## Using FFT/IFT In ImageMagick {#im_fft}

### Implementation Notes {#fft_implementation}

ImageMagick makes use of the [FFTW, Discrete Fourier Transform Library](http://www.fftw.org/) which requires images to be converted to and from floating point values (complex numbers), and was first implemented in IM version 6.5.4-3.

To make it work as people generally expect for images, any non-square image or one with an odd dimension will be padded (using [Virtual Pixels](../misc/#vitural) to be square of the maximum width or height of the image.
To allow for proper centering of the 'FFT origin' in the center of the image, it is also forced to have even (multiple of 2) dimensions.
The consequence of this is that after applying the Inverse Fourier Transform, the image will need to be cropped back to its original dimensions to remove the padding.

As the Fourier Transform is composed of "[Complex Numbers](http://en.wikipedia.org/wiki/Complex_number)", the result of the transform cannot be visualized directly.
Therefore, the complex transform is separated into two component images in one of two forms.
  
![\[Diagram\]](../img_diagrams/complex_number.jpg)  

**Complex Number Real/Imaginary**

#### Real and Imaginary {#complex_numbers}

The normal mathematical and numerical representation of the "[Complex Numbers](http://en.wikipedia.org/wiki/Complex_number)", is a pair of floating point values consisting of 'Real' (a) and 'Imaginary' (b) components.
Unfortunately, these two numbers may contain negative values and thus do not form viewable images.

As such this representation can not be used in a normal version of ImageMagick, which would clip such images (see example below of the resulting effects.

However, when using a [HDRI version of ImageMagick](../basics/#hdri) you can still generate, use, and even save this representation of a Fourier Transformed image.
They may not be useful or even viewable as images in their own right, but you can still apply many mathematical operations to them.

To generate this representation we use the 'plus' form of the operators, "`+fft`" and "`+ift`", and will be looked at in detail below in [FFT as Real-Imaginary Components](#fft_ri).
  
![\[Diagram\]](../img_diagrams/polar_number.jpg)  

**Complex Polar Magnitude/Phase**

#### Magnitude and Phase {#complex_polar}

Direct numerical representation of the "[Complex Numbers](http://en.wikipedia.org/wiki/Complex_number)" is not very useful for image work.
But by plotting the values onto a 2-dimensional plane, you can then convert the value into a [Polar Representation](http://en.wikipedia.org/wiki/Complex_number#Polar_form) consisting of 'Magnitude' (r) and 'Phase' (θ) components.

This form is very useful in image processing, especially the magnitude component, which essentially specifies all the frequencies that go to make up the image.

The 'Magnitude' component only contains positive values, and is just directly mapped into image values.
It has no fixed range of values, though except for the DC or zero frequency color, the values will generally be quite small.
As a consequence of this the magnitude image generally will appear to be very dark (practically black).

Scaling the magnitude and applying a log transform of its intensity values will usually be needed to bring out any visual detail.
The resulting 'log-transformed' magnitude image is known as the image's 'spectrum'.
However, remember that it is the 'magnitude' image, and not the 'spectrum' image, that should be used for the inverse transform.

The DC (Short for "Direct Current") or "Zero Frequency", color that appears at the central 'origin' of the image, will be the average color value for the whole image.
Also, as input images not contain 'imaginary' components, the DC phase value will also always have zero phase, producing a pure-gray color.

The 'Phase' component however ranges from -π to +π.
This is first biased into a 0 to 2π range, then scaled into actual image values ranging from 0 to *QuantumRange* (as determined by the [Compile Time Memory Quality](../basics/#quality)).
As a consequence of this, a zero phase will have a pure-gray value (as appropriate for each channel), while a negated phase will be a pure-black ('`0`') value.
Note that a pure-white ('`QuantumRange`') is almost but not quite the same thing.

A Magnitude and Phase FFT representation of an image is generated using the normal FFT operators, "`+fft`" and "`+ift`".
This will be looked at first in [Generating FFT Images and its Inverse](#fft).

### Generating FFT Images and its Inverse {#fft}

(Magnitude and Phase)

Now, let's simply try a Fourier Transform round trip on the Lena image.
That is, we simply do the forward transform and immediately apply the inverse transform to get back the original image.
Then we will compare the results to see the level of quality produced.

~~~
time convert lena.png -fft -ift lena_roundtrip.png

echo -n "RMSE = "
compare -metric RMSE lena.png lena_roundtrip.png null:
echo -n "PAE = "
compare -metric PAE  lena.png lena_roundtrip.png null:
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_roundtrip.png)](lena_roundtrip.png)
  
[![\[IM Text\]](lena_roundtrip_cmp.txt.gif)](lena_roundtrip_cmp.txt)

The "`compare`" program above returns a measure of how different the two images are.
In this case you can see that the general difference is very small, of about `0.22%`.
With a peak value difference in at least one pixel of about ("`PAE`", Peak Absolute Error) of just about `1%`.

You can improve this by using a [HDRI](../basics/#hdri) version of ImageMagick.
(See [FFT with HDRI](#fft_hdri) below).

Let's take a closer look at the FFT images that were generated in the above round trip.

~~~
convert lena.png -fft    +depth +adjoin lena_fft_%d.png
~~~

[![\[IM Output\]](lena.png)](lena.png)  
Original
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](lena_fft_0.png)](lena_fft_0.png)  
Magnitude
  
[![\[IM Output\]](lena_fft_1.png)](lena_fft_1.png)  
Phase

As [John M. Brayer](http://www.cs.unm.edu/~brayer/vision/fourier.html) said about Fourier Transforms...
> *We generally do not display PHASE images because most people who see them shortly thereafter succumb to hallucinogenics or end up in a Tibetan monastery.*

Note that the "`-fft`" operator generated two images, the first image is the 'magnitude' component (yes it is mostly black with a single colored dot in the middle), while the second, almost random looking image, contains the 'phase' component.

PNG images can only store one image per file as such neither the "`+adjoin`" or the '`%d`' in the output filename was actually needed, as IM would handle this.
However, I include the options in the above for completeness, so as to make it clear I am generating two separate image files, not one.
See [Writing a Multi-Image Sequence](../files/#adjoin) for more details.

As two images are generated the magnitude image (first, or zeroth image) is saved into "`lena_fft_0.png`" and phase image (second image) into "`lena_fft_1.png`".

> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> To prevent any chance of distortions resulting from saving FFT images, it is best not to save them to disk at all, but hold them in memory while you process the image.
>
> If you must save, then it is best to use the Magick File Format "`MIFF`" so as to preserve the image at its highest quality (bit depth).
> This format can also save multiple images in the one file.
> For script work you can also use the verbose "`TXT`" Enumerated Pixel Format.
>
> **DO NOT** save them using "`JPEG`", "`GIF`" image formats.
>
> If you must save these images into files for actual viewing, such as for a web browser, use the image format "`PNG`" with a "`+depth`" reset to the internal default, (as we do in these examples).
> However it can only store one image per file.
>
> The "`TIFF`" file format can also be used though is not as acceptable for web browsers, though it does allow multiple images per file.

The best way of saving intermediate images into a single file is to use the "`MIFF`", file format...

~~~
convert lena.png -fft  +depth lena_fft.miff
~~~

Or you can save them into complete, separate filenames using "`-write`" (See [Writing Images](../files/#write))...

~~~
convert lena.png -fft  +depth \
        \( -clone 0 -write lena_magnitude.png +delete \) \
        \( -clone 1 -write lena_phase.png +delete \) \
        null:
~~~

Note that in the above I used the special "`NULL:`" image format to junk the two images which are still preserved in memory for further processing.

And finally, we read in the two images again, so as to convert back into a normal 'spatial' image...

~~~
convert lena_magnitude.png lena_phase.png -ift lena_restored.png
~~~

[![\[IM Output\]](lena_magnitude.png)](lena_magnitude.png)
[![\[IM Output\]](lena_phase.png)](lena_phase.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_restored.png)](lena_restored.png)

Both images generated by the FFT process are very sensitive to modification, where even small changes can produce greatly distorted results.
As such, it is important to never save them in any image format that could distort those values.

It important to remember that both images are needed when recovering the image from the frequency domain.
So it is no good saving one image, and junking the other, if you plan on using them for image reconstruction.
  
### Magnitude or Phase Only Images {#fft_partial}

Finally, let's try reconstructing an image from just its magnitude component or just its phase component.

~~~
convert lena_fft_0.png  -size 128x128 xc:'gray(50%)' \
                                                -ift lena_magitude_only.png

convert -size 128x128 xc:gray1  lena_fft_1.png  -ift lena_phase_only.png
~~~

[![\[IM Output\]](lena_magitude_only.png)](lena_magitude_only.png)  
Magnitude Only
  
[![\[IM Output\]](lena_phase_only.png)](lena_phase_only.png)  
Phase Only

You will note from this that it is the phase image that actually contains most of the position information of the image, while the magnitude actually holds much of the color information.
This is not exact, as there is some overlap in the information, but that is generally the case.

The 'Magnitude Only' image will always have white corners, as a constant 50% phase image was used.
You can remove those white patches by using a randomized phase image.
However, make sure the phase of the center pixel is a perfect 50% gray, or the whole image will be dimmed.

The 'Phase Only' image used a constant 1% gray (almost pure black) magnitude image for the conversion.
Even with this constant magnitude it still produces patches of very intense pixels, especially along edges.

You just need to remember that both images are needed to reconstruct the original image.

### Frequency Spectrum Image {#fft_spectrum}

You will have noted that the magnitude image (the first or zeroth image), appears almost totally black.
It isn't really, but to our eyes all the values are very, very small.
Such an image isn't really very interesting to look at to study, so let's enhance the result with a log transform to produce the a '*frequency spectrum*' image.

This is done by applying a strong [Evaluate Log Transform](../transform/#evaluate_log) to a [Normalized](../color_mods/#normalize) 'magnitude' image.

~~~
convert lena_fft_0.png -auto-level -evaluate log 10000 \
        lena_spectrum.png
~~~

[![\[IM Output\]](lena_fft_0.png)](lena_fft_0.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_spectrum.png)](lena_spectrum.png)

Now we can see the detail in the spectrum version of the magnitude image.

You may even see some specific colors in the spectrum image, but generally such colors are unimportant in a spectrum image.
It is the overall intensity of each frequency, and the patterns they produce that is far more important.
As such you may also like to gray-scale the spectrum image after enhancement.

How much of a log enhancement you need to use depends on the image, so you should adjust it until you get the amount of detail you need to clearly see the pattern of the image's frequency spectrum.
  
Alternatively, you can use the following small shell script, to calculate a *log scaling factor* to use for the specific magnitude image.

~~~
scale=`convert lena_fft_0.png -auto-level \
        -format "%[fx:exp(log(mean)/log(0.5))]" info:`
convert lena_fft_0.png -auto-level \
        -evaluate log $scale    lena_spectrum_auto.png
~~~

[![\[IM Output\]](lena_spectrum_auto.png)](lena_spectrum_auto.png)
  
However, remember that you can not use a spectrum image, for the inverse "`-ift`" transform as it will produce an overly bright image.

~~~
convert lena_spectrum.png lena_fft_1.png -ift lena_roundtrip_fail.png
~~~

Basically, as you have enhanced the 'magnitude' image, you have also enhanced the resulting image in the same way, producing the badly 'clipped' result shown.
  
[![\[IM Output\]](lena_roundtrip_fail.png)](lena_roundtrip_fail.png)

### HDRI FFT Images {#fft_hdri}

When we mapped the results of the Fourier Transform into a image representation we scaled and converted the values from floating point "[Complex Numbers](http://en.wikipedia.org/wiki/Complex_number)", into integer image values.
This naturally produced [Rounding Errors, and other "Quantum" Effects](../basics/#quantum_effects), especially in the smaller, lower frequency magnitudes.

If accuracy is important in your image processing, then you will either need to use a [Bit Quality](../basics/#quality) (such as Q32 or Q64 bit versions of ImageMagick), or better still use a [HDRI version ImageMagick](../basics/#hdri) so that the values are stored as floating point numbers.

When using a HDRI version of IM with a [Magnitude and Phase](#complex_polar) representation of the Fourier transform, the magnitude component will still all be positive values, and as such can still be used as shown above, just much more exactly.
The phase component will however still be biased and scaled, as previously shown.

In other words, the magnitude and phase representation in HDRI is exactly the same, just much more accurate.

For example here I use a [HDRI version ImageMagick](../basics/#hdri) to generate another 'round trip' conversion of an image.

~~~
# HDRI version of IM used
time convert lena.png -fft -ift lena_roundtrip_hdri.png

echo -n "RMSE = "
compare -metric RMSE lena.png lena_roundtrip_hdri.png null:
echo -n "PAE = "
compare -metric PAE  lena.png lena_roundtrip_hdri.png null:
~~~

[![\[IM Output\]](lena_roundtrip_hdri.png)](lena_roundtrip_hdri.png)
  
[![\[IM Text\]](lena_roundtrip_hdri_cmp.txt.gif)](lena_roundtrip_hdri_cmp.txt)

If you compare the results above with the previous non-HDRI comparison...
  
[![\[IM Text\]](lena_roundtrip_cmp.txt.gif)](lena_roundtrip_cmp.txt)

You will see that the HDRI version of IM produced a much more accurate result, at roughly the same speed as before - speed may vary depending on your computer - though it will have required much more memory than a normal Q16 IM (See [Compile-Time Quality](../basics/#quality)).

However, such images, while more exactly representing the frequency components of the FFT of the image, can contain negative and fractional values can only be saved using special [HDRI capable File Formats](../basics/#hdri_formats) that can handle floating-point values.

> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Floating point compatible file formats include "`MIFF`", "`TIFF`", "`PFM`" and the HDRI specific "`EXR`" file format.
> However you may need to set "`-define quantum:format=floating-point`" for it to work.

In later examples processing an FFT of an image, will need such accuracy to produce good results.
As such, as we proceed with using Fast Fourier Transforms, a [HDRI version ImageMagick](../basics/#hdri) will become a requirement.

### FFT as Real-Imaginary Components {#fft_ri}

So far we have only looked at the 'Magnitude' and a 'Phase' representation of Fourier Transformed images.
But if you have compiled a [HDRI version of IM](../basics/#hdri), you can also process images using floating point 'Real' and 'Imaginary', components.

For example here I used a [HDRI version of IM](../basics/#hdri) to also perform a 'round trip' FFT of an image, but this time generating Real/Imaginary images.

~~~
# HDRI version of IM used
time convert lena.png   +fft +ift   lena_roundtrip_ri.png

echo -n "RMSE = "
compare -metric RMSE lena.png lena_roundtrip_ri.png null:
echo -n "PAE = "
compare -metric PAE  lena.png lena_roundtrip_ri.png null:
~~~

[![\[IM Output\]](lena_roundtrip_ri.png)](lena_roundtrip_ri.png)
  
[![\[IM Text\]](lena_roundtrip_ri_cmp.txt.gif)](lena_roundtrip_ri_cmp.txt)

  
You must use a HDRI version when you use the plus forms to generate Real/Imaginary FFT images.
If you don't, the resulting images will have a 'dirty' look about them due to the 'clipping' of negative values.
For example...

~~~
# non-HDRI Q16 version of IM used  -- THIS IS BAD
convert lena.png   +fft +ift   lena_roundtrip_ri_bad.png
~~~

[![\[IM Output\]](lena_roundtrip_ri_bad.png)](lena_roundtrip_ri_bad.png)

The other thing to remember is that whichever form of FFT images you generate will also affect ALL image processing operations you want to apply to the FFT images.
They are very different images, and as such, they must be processed in very different ways, with different mathematical operations.

Also, as before, you must have both Real and Imaginary component images to restore the final image.
For example, here is what happens if we substitute a 'black' image for one of the components.

~~~
# HDRI version of IM used
convert lena.png +fft -delete 1 \
        -size 128x128 xc:black +ift lena_real_only.png
convert lena.png +fft -delete 0 \
        -size 128x128 xc:black +ift lena_imaginary_only.png
~~~

[![\[IM Output\]](lena_real_only.png)](lena_real_only.png)  
Real Only
  
[![\[IM Output\]](lena_imaginary_only.png)](lena_imaginary_only.png)  
Imaginary Only

You can see from this that both Real/Imaginary FFT images contain vital information about the original image fairly equally.
The biggest difference between the two is that the special DC or 'average color' has no imaginary component and, as such, is only present in the magnitude image.

The diagonal mirror effect you see in both images is caused by the loss of the 'sign' information contained in the other component.
Without the other component, the wave could be thought to be 180 degrees out of phase, causing that mirror look.
This information loss is equal between the two types of image.

------------------------------------------------------------------------

## Properties Of The Fourier Transform {#ft_properties}

### FFT of a Constant Image {#fft_constant}

Let's demonstrate some of these properties.

First, let's simply take a constant color image and get its magnitude.

~~~
convert -size 128x128 xc:gold constant.png
convert constant.png -fft +delete constant_magnitude.png
~~~

[![\[IM Output\]](constant.png)](constant.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](constant_magnitude.png)](constant_magnitude.png)

Note that the magnitude image in this case really is pure-black, except for a single colored pixel in the very center of the image, at the pixel location width/2, height/2.
This pixel is the zero frequency or DC ('*Direct Current*') value of the image, and is the one pixel that does not represent a sine wave.
In other words this value is just the FFT constant component!
  
To see this single pixel more clearly lets also magnify that area of the image...

~~~
convert constant_magnitude.png -gravity center -extent 5x5 \
         -scale 2000% constant_dc_zoom.gif
~~~

[![\[IM Output\]](constant_dc_zoom.gif)](constant_dc_zoom.gif)

Note that the color of the DC point is the same as the original image.

Actually it is a good idea to remember that what you are seeing is three values.
That is the image generated is actually three separate Fast Fourier transforms.
A FFT for each of the three red, green and blue image channels.
The FFT itself has no real knowledge about colors, only the color values or '*gray-levels*'.

In fact a FFT transform could be applied to just about any colorspace, as really...
it does not care!
To a Fourier transform an image is just an array of values, and that is all.

> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> While the 'phase' of the DC value is not important, it should always be a 'zero' angle (a colour value of 50% gray).
> If it is not set to 50% gray, the DC value will have an 'unreal' component, and its value modulated by the angle given.

### Effects of the DC Color {#fft_dc_color}

In a more typical non-constant image, the DC value is the average color of the image.
The color you should generally get if you had completely blurred, averaged, or resized the image down to a single pixel or color.

For example, let's extract the DC pixel from the FFT of the "Lena" image.

~~~
convert lena.png -fft +delete lena_magnitude.png
convert lena_magnitude.png -gravity center -extent 1x1 \
        -scale 60x60   lena_dc_zoom.gif
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_magnitude.png)](lena_magnitude.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_dc_zoom.gif)](lena_dc_zoom.gif)

As you can see, the average color for the image is a sort of 'dark pink' color.

Another way of thinking about this special pixel is that it represents the center 'bias' level, around which all the other sine waves modify the image colors.
  
For example, let's replace that 'dark pink' DC pixel with some other color such as the more orange color 'tomato'...

~~~
convert lena.png -fft \
        \( -clone 0  -draw "fill tomato  color 64,64 point" \) \
        -swap 0 +delete -ift lena_dc_replace.png
~~~

[![\[IM Output\]](lena_dc_replace.png)](lena_dc_replace.png)

What is really happening is that by changing the DC value in the FFT images you are changing the whole image in that same way.
Actually, any change in the DC value (the difference) will be added (or subtracted) from each and every pixel in the resulting image.

This is just as if we were really adding some constant to each pixel in the original image.
As such, the final pixel colors in the reconstructed image could also be clipped by the maximum (white) or minimum (black) limits.
As such, this is not a recommended method of color tinting an image.
This is simpler to apply than modifying every pixel in the whole image, though the FFT round trip will make it overall a much slower color tinting technique.

### Spectrum Of A Sine Wave Image {#sine_spectrum}

Next, let's take a look at the spectrum from a single sine (or cosine) wave image with 4 cycles across the image

~~~
convert -size 128x129 gradient: -chop 0x1 -rotate 90 -evaluate sine 4 \
        sine4.png
convert sine4.png -fft +delete \
        -auto-level -evaluate log 100  sine4_spectrum.png
~~~

[![\[IM Output\]](sine4.png)](sine4.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](sine4_spectrum.png)](sine4_spectrum.png)

> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> The unusual creation of the gradient image in the above is necessary to ensure that the resulting sine wave image tiles perfectly across the image.
>
> A normal "`gradient:`" image does not perfectly tile, so neither does a sine wave generated from it.
> A FFT transform of such an imperfect tile, will result in an array of undesired harmonics, rather than single 'dots' in the Fourier Transform Spectrum.
>
> See [Generating the Perfect Gradient](../canvas/#perfect_gradients) for more details about this problem.

In the spectrum image (enhanced magnitude image) above, we can see that it has 3 dots.
The center dot is, as before, the average DC value.
The other two dots represent the perfect sine wave that the Fourier Operator found in the image.
As the frequency across the width of the image is exactly 4 cycles, and as a result two frequency pixels are exactly 4 pixels away from the center DC value.

But why two pixels?

Well that is because a sine single wave can be described in two completely different ways, (one with a negative direction and phase).
Both descriptions are mathematically correct, and a fourier transform does not distinguish between them.

If we repeat this with a sine wave with 16 cycles, then again we see that it has 3 dots, but the dots are further apart.
In this case the side dots are spaced 16 pixels to the left and right sides of the center dot.

~~~
convert -size 128x129 gradient: -chop 0x1 -rotate 90 -evaluate sine 16 \
        -write sine16.png -fft -delete 1 \
        -auto-level -evaluate log 100 sine16_spectrum.png
~~~

[![\[IM Output\]](sine16.png)](sine16.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](sine16_spectrum.png)](sine16_spectrum.png)

From this you can see that perfect sine waves will be represented simply by two dots in the appropriate position.
The distance this position is from the center DC value determine the frequency of the sine wave.
The smaller the wavelength the higher the frequency, so the further the dots will be from the DC value.

In fact, dividing the size of the image by the frequency (distance of the dots from the center), will give you the wavelength (distance between peaks) of the wave.
In the above case: 128 pixels divided by 16 cycles, gives you a wavelength of 8 pixels between each 'band'.

This is one of the most important distinguishing features of the FFT transformation.
A pattern of small features on the original image requires small wavelengths, and thus large frequencies.
That results in large scale effects in the frequency domain.
Similarly large features, use smaller frequencies, so generate small scale patterns, especially close in to toward the center.

In a Fourier transform...

**Small becomes large and large becomes small.**

This is one of the most vital aspects to remember when dealing with Fourier Transforms, as it is the key to removing noise (small features) from an image, while preserving the overall larger aspects of the image.

Let's take a closer look at these three 'frequencies' by plotting their original magnitudes (not the logarithmic spectrum).

~~~
convert sine16.png -fft -delete 1  miff:- |\
   im_profile - sine16_magnitude_pf.png
~~~

[![\[IM Output\]](sine16_magnitude_pf.png)](sine16_magnitude_pf.png)

Notice that the DC value (average or bias of image) has a value of 1/2 which is to be expected (the average value of the image is a perfect 50% gray), but that the actual magnitude of the two 16 cycle sine-waves the fourier transform found is only 1/4 of the maximum value.

The magnitude of the original sine-save is really 1/2 but the fourier transform divided that magnitude into two, sharing the results across both plotted frequency waves, so each of the two components only has a magnitude of 1/4.
That is a normal part of fourier trasforms.

[![\[IM Output\]](lena_spectrum.png)](lena_spectrum.png)

This duality of positive and negative frequencies in FFT images explains why all FFT image spectrums (such as the Lena spectrum repeated left) are always symmetrical about the center.
For every dot on one side of the image, you will always get a similar 'dot' mirrored across the center of the image.

The same thing happens with the 'phase' component of FFT image pair, but with a 180 degree shift (a negative phase) in value as well.

That means half each image is really a duplicate of the other half, but you need BOTH images to recreate the original image.
In other words the two images still contain exactly the same amount of information, half in one image, and half in the other.
Together they produce a whole.

> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> During generation, the FFT algorithm only calculates the left half the images.
> The other half is generated by rotations and duplication of the calculated data.
>
> When converting Frequency Domain images back to a Spatial Domain Image, the algorithm again only looks at the left half of the image.
> The right half is completely ignored, as it is only a duplicate.
>
> As such when (in later examples) you 'notch filter' a FFT magnitude image, you only really need to filter the left hand side of the magnitude image.
> You can save yourself some work by also ignoring the right half.
> However for clarity I will 'notch' both halves.

### Generating FFT Images Directly {#generation}

Now we can use the above information to actually generate an image of a sine wave.
All you need to do is create a black and 50% gray image pair, and add 'dots' with the appropriate magnitude, and phase.

For example...

~~~
convert -size 128x128  xc:black \
        -draw 'fill gray(50%)  color 64,64 point' \
        -draw 'fill gray(50%)  color 50,68 point' \
        -draw 'fill gray(25%)  color 78,60 point' \
        generated_magnitude.png
convert generated_magnitude.png \
        -auto-level -evaluate log 3  generated_spectrum.png
convert -size 128x128  xc:gray50  generated_phase.png
convert generated_magnitude.png generated_phase.png \
        -ift  generated_wave.png
~~~

[![\[IM Output\]](generated_spectrum.png)](generated_spectrum.png)
[![\[IM Output\]](generated_phase.png)](generated_phase.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](generated_wave.png)](generated_wave.png)

And presto a perfect angled (and tilable) sine wave.

Of course, you can only generate perfect sine waves at particular frequencies, and are only tilable in square images (unless resized later).

Unfortunately, all the frequencies will also be a power of two in any horizontal or vertical direction, and that is the main limitation of this technique.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> Actually, only the first (left-most) 'gray25' dot was needed to generate the sine wave as the IFT transform completely ignores the right half of the image as this should simply be a mirror of the left half.
>
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> The phase of the DC value must have a 'zero angle' (50% gray color).
> If you don't ensure that is the case, the DC color value will be modulated by its non-zero phase, producing a darker, possibly 'clipped' image.
>
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> The other pixels in the phase can be any grey level you like, and will effectively 'roll' the sine wave across the image.
> Again, only the phase of the left-most dot actually matters.
> The right hand side is completely ignored.
> Just ensure the center DC phase pixel remains 50% grey.

    FUTURE: Perlin Noise Generator using FFT 

### Spectrum of a Vertical Line {#line_spectrum}

*Show the FFT spectrum of a thin and thick line*

*Demonstrate how small features become 'big' and big features become 'small' in the FFT of the image.
Link that back to the sine wave which could be regarded as a 'line' with a single harmonic.* *Rotate the line*

### Spectrum of a Rectangle Pattern Image {#rectangle_spectrum}

Next, let's look at the spectrum of a white rectangle of width 8 and height 16 inside a black background.

~~~
convert -size 8x16 xc:white -gravity center \
        -gravity center -background black -extent 128x128 rectangle.png
convert rectangle.png -fft +delete \
        -auto-level -evaluate log 100 rect_spectrum.png
~~~

[![\[IM Output\]](rectangle.png)](rectangle.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](rect_spectrum.png)](rect_spectrum.png)

As you can see, the resulting image has a very particular pattern, with a lot of harmonic frequencies.

You can also see that the rectangle appears to be rotated 90 degrees.
That is incorrect, what you are seeing is that same rule we mentioned before... big features become small and small features become big.
As such, the smaller dimension of the rectangle became larger and the larger dimension became smaller.

Now, let's rotate the rectangle by 45 degrees.
We find that the spectrum is also rotated in the same direction by 45 degrees.

~~~
convert rectangle.png -rotate 45 -gravity center -extent 128x128 \
        -write rect_rot45.png -fft -delete 1 \
        -auto-level -evaluate log 100 rect_rot45_spectrum.png
~~~

[![\[IM Output\]](rect_rot45.png)](rect_rot45.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](rect_rot45_spectrum.png)](rect_rot45_spectrum.png)

As you can see, the same rotation in the frequency domain.
That is, rotating an object will also cause it to be rotated in its Fourier Transform.

However, if we now move the rectangle...

~~~
convert rectangle.png -rotate 45  -geometry +30+20 -extent 128x128 \
        -write rect_rot45off.png -fft -delete 1 \
        -auto-level -evaluate log 100 rect_rot45off_spectrum.png
~~~

[![\[IM Output\]](rect_rot45off.png)](rect_rot45off.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](rect_rot45off_spectrum.png)](rect_rot45off_spectrum.png)

The frequency pattern did not move.
That is because all the positioning information is contained in the phase image.
The frequency pattern (magnitude or its spectrum does not change because it moved).

This position separation, is one of the key features of the Fourier Transform that makes it so very important.
It will allow you to search for specific image pattern within a larger image, regardless of the location of the object that produced that fourier spectrum pattern.

### Spectrum Of A Flat Circular Pattern Image {#circle_spectrum}

Next, let's look at the spectrum of an image with a white, flat circular pattern, in one case with a diameter of 12 (radius 6) and, in another case, with a diameter of 24 (radius 12).

~~~
convert -size 128x128 xc:black -fill white  \
        -draw "circle 64,64 64,70" -write circle6.png -fft -delete 1 \
        -auto-level -evaluate log 100 circle6_spectrum.png

convert -size 128x128 xc:black -fill white  \
        -draw "circle 64,64 64,76" -write circle12.png -fft -delete 1 \
        -auto-level -evaluate log 100 circle12_spectrum.png
~~~

[![\[IM Output\]](circle6.png)](circle6.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](circle6_spectrum.png)](circle6_spectrum.png)  
[![\[IM Output\]](circle12.png)](circle12.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](circle12_spectrum.png)](circle12_spectrum.png)

Note that the first image is very close to what we generated for the jinc example further above.
It is however a little broken up.
These artifacts occur due to the small size of the circle.
Since it is represented digitally, its perimeter is not perfectly circular.
Again we see that the small details become large in the transformed frequency space.

The transform of the larger circle is better as its perimeter is a closer approximation of a true circle.
We therefore conclude that indeed the transform of the flat circular shape is a jinc function and that the image containing the smaller diameter circle produces transform features that are more spread out and wider.

According to the mathematical properties of a Fourier Transform, the distance from the center to the middle of the first dark ring in the spectrum will be 1.22\*N/d.
When the diameter of the circle is d=12, we get a distance of 1.22\*128/12=13.
Likewise when the diameter of the circle is d=24, we get a distance of 1.22\*128/24=6.5.

### Spectrum Of A Gaussian Pattern Image {#gaussian_spectrum}

Next, let's look at the spectrum from two images, each with a white Gaussian circular pattern having sigmas of 8 and 16, respectively:

~~~
convert -size 128x128 xc:black -fill white \
        -draw "point 64,64" -gaussian-blur 0x8 -auto-level \
        -write gaus8.png -fft -delete 1 \
        -auto-level -evaluate log 1000 gaus8_spectrum.png

im_profile -s gaus8.png gaus8_pf.gif
im_profile -s gaus8_spectrum.png gaus8_spectrum_pf.gif
~~~

[![\[IM Output\]](gaus8.png)](gaus8.png)
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](gaus8_spectrum.png)](gaus8_spectrum.png)
  
[![\[IM Output\]](gaus8_pf.gif)](gaus8_pf.gif)
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](gaus8_spectrum_pf.gif)](gaus8_spectrum_pf.gif)


~~~
convert -size 128x128 xc:black -fill white \
        -draw "point 64,64" -gaussian-blur 0x16 -auto-level \
        -write gaus16.png -fft -delete 1 \
        -auto-level -evaluate log 1000 gaus16_spectrum.png

im_profile -s gaus16.png gaus16_pf.gif
im_profile -s gaus16_spectrum.png gaus16_spectrum_pf.gif
~~~

[![\[IM Output\]](gaus16.png)](gaus16.png)
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](gaus16_spectrum.png)](gaus16_spectrum.png)
  
[![\[IM Output\]](gaus16_pf.gif)](gaus16_pf.gif)
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](gaus16_spectrum_pf.gif)](gaus16_spectrum_pf.gif)

Other than the noise produced by the rectangular array of the pattern, the result was that a Gaussian pattern produced an almost identical Gaussian frequency pattern.
More importantly that pattern was quite clean in appearance.

Of course, there is a size difference, again following that same rule, big becomes small and small become big.

From the mathematical properties, the sigma in the spectrum will be just N/(2\*sigma), where sigma is from the original image.
So for an image of size N=128 and sigma=8, the sigma in the spectrum will be 128/16=8.
Similarly if the image's sigma is 16, then the sigma in the spectrum will be 128/32=4.

This is the mathematical relationship of the "big becomes small and visa-versa" rule, and it can be useful to know.

### Spectrum Of A Grid Pattern Image {#grid_spectrum}

Next, let's transform an image containing just a set of grid lines spaced 16x8 pixels apart.

~~~
convert -size 16x8 xc:white -fill black \
        -draw "line 0,0 15,0" -draw "line 0,0 0,7" \
        -write mpr:tile +delete \
        -size 128x128 tile:mpr:tile \
        -write grid16x8.png -fft -delete 1 \
        -auto-level -evaluate log 100000 grid16x8_spectrum.png
~~~

[![\[IM Output\]](grid16x8.png)](grid16x8.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](grid16x8_spectrum.png)](grid16x8_spectrum.png)

The resulting spectrum is just an array of dots where the grid lines that are more closely spaced produce dots further apart and vice versa.
According to the properties above, since the grid lines are spaced 16x8 pixels apart, then the dots should be spaced N/a=128/16=8 and M/b=128/8=16, which is just what is measured in this image.

This pattern is of particular importance as it will let you know the relationship for the Fourier Transform to a regular tiling pattern in an image.
Such a tiling patterns produces very strong non-central grid patterns in its Fourier Transform.

The key point here is that the shape information is in the center, but tiling information is in a grid-like array away from the center of its fourier transform.

### More Spectrum Information {#more_spectrum}

Here are some links if you'd like to know more about spectrum images and their properties.

-   [Wikipedia: Fourier Transform](http://en.wikipedia.org/wiki/Fourier_transform)
-   [Fred Weinhaus, Properties of a Fourier Transform](http://www.fmwconcepts.com/imagemagick/fourier_transforms/fourier.html#ft_properties)
-   [Wolfram MathWorld: Fourier Transform](http://mathworld.wolfram.com/FourierTransform.html)

------------------------------------------------------------------------

## Practical Applications {#ft_applications}

OK, now that we have covered the basics, what are the practical applications of Fourier Transform?

Some of the things that can be done include: 1) increasing or decreasing the contrast of an image, 2) blurring, 3) sharpening, 4) edge detection and 5) noise removal.

### Changing The Contrast Of An Image - Coefficient Rooting {#contrast}

One can adjust the contrast in an image by performing the forward Fourier transform, raising the magnitude image to a power and then using that with the phase in the inverse Fourier transform.
To increase, the contrast, one uses an exponent slightly less than one, and to decrease the contrast, one uses an exponent slightly greater than one.
So, let's first increase the contrast on the Lena image using an exponent of 0.9 and then decrease the contrast using an exponent of 1.1.

~~~
convert lena.png -fft \
        \( -clone 0 -evaluate pow 0.9 \) -delete 0 \
        +swap -ift lena_plus_contrast.png

convert lena.png -fft \
        \( -clone 0 -evaluate pow 1.1 \) -delete 0 \
        +swap -ift lena_minus_contrast.png
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_plus_contrast.png)](lena_plus_contrast.png)  
[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_minus_contrast.png)](lena_minus_contrast.png)

However, doing this to the original image would also have the same effect as doing this to the magnitude image.
That is, a global modification of the magnitudes has the same effect as if you did a global modification of the original image.

### Blurring An Image - Low Pass Filtering {#blurring}

One of the most important properties of Fourier Transforms is that convolution in the spatial domain is equivalent to simple multiplication in the frequency domain.
In the spatial domain, one uses small, square-sized, simple convolution filters (kernels) to blur an image with the [-convole](../option_link.cgi?convole) option.
This is called a low pass filter.
The simplest filter is just an equally-weighted, square array.
That is, all the values are ones, which are normalized by dividing by their sum before applying the convolution.
This is equivalent to a local or neighborhood average.
Another low pass filter is the Gaussian-weighted, circularly-shaped filter provided by either [-gaussian-blur](../option_link.cgi?gaussian-blur) or [-blur](../option_link.cgi?blur).

In the frequency domain, one type of low pass blurring filter is just a constant intensity white circle surrounded by black.
This would be similar to a circularly-shaped averaging convolution filter in the spatial domain.
However, since convolution in the spatial domain is equivalent to multiplication in the frequency domain, all we need do is perform a forward Fourier transform, then multiply the filter with the magnitude image and finally perform the inverse Fourier transform.
We note that a small sized convolution filter will correspond to a large circle in the frequency domain.
Multiplication is carried out via [-composite](../option_link.cgi?composite) with a [-compose](../option_link.cgi?compose) multiply setting.

So, let's try doing this with two sizes of circular filters, one of diameter 40 (radius 20) and the other of diameter 28 (radius 14).

~~~
convert -size 128x128 xc:black -fill white \
        -draw "circle 64,64 44,64" circle_r20.png
convert lena.png -fft \
     \( -clone 0 circle_r20.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_blur_r20_spec.png +delete \) \
     -swap 0 +delete -ift lena_blur_r20.png

convert -size 128x128 xc:black -fill white \
        -draw "circle 64,64 50,64" circle_r14.png
convert lena.png -fft \
     \( -clone 0 circle_r14.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_blur_r14_spec.png +delete \) \
     -swap 0 +delete -ift lena_blur_r14.png
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_spectrum.png)](lena_spectrum.png)
![x](../img_www/multiply.gif)
[![\[IM Output\]](circle_r20.png)](circle_r20.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_blur_r20_spec.png)](lena_blur_r20_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_blur_r20.png)](lena_blur_r20.png)
[![\[IM Output\]](circle_r14.png)](circle_r14.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_blur_r14_spec.png)](lena_blur_r14_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_blur_r14.png)](lena_blur_r14.png)

So we see that the image that used the smaller diameter filter produced more blurring.
We also note the 'ringing' or 'ripple' effect near edges in the resulting images.
This occurs because the Fourier Transform of a circle, as we saw earlier, is a jinc function, which has decreasing oscillations as it progresses outward from the center.
Here however, the jinc function and the oscillations are in the spatial domain rather than in the frequency domain, as we had demonstrated earlier above.

So what can we do about this?
The simplest thing is to taper the edges of the circles using various [Windowing Functions](http://en.wikipedia.org/wiki/Window_function).
Alternatively, one can use a filter such as a Gaussian shape that is already, by definition, tapered.

So, let's do the latter and use two Gaussian blurred circles to remove most of the severe 'ringing' effects.

~~~
convert circle_r20.png -blur 0x4 -auto-level gaussian_r20.png
convert lena.png -fft \
     \( -clone 0 gaussian_r20.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_gblur_r20_spec.png +delete \) \
     -swap 0 +delete -ift lena_gblur_r20.png

convert circle_r14.png -blur 0x4 -auto-level gaussian_r14.png
convert lena.png -fft \
     \( -clone 0 gaussian_r14.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_gblur_r14_spec.png +delete \) \
     -swap 0 +delete -ift lena_gblur_r14.png
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_spectrum.png)](lena_spectrum.png)
![x](../img_www/multiply.gif)
[![\[IM Output\]](gaussian_r20.png)](gaussian_r20.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_gblur_r20_spec.png)](lena_gblur_r20_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_gblur_r20.png)](lena_gblur_r20.png)
[![\[IM Output\]](gaussian_r14.png)](gaussian_r14.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_gblur_r14_spec.png)](lena_gblur_r14_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_gblur_r14.png)](lena_gblur_r14.png)

This, of course, is much better.

The ideal low-pass filter is not to blur circles at all, but actually use a proper gaussian curve of *sigma* rather than a *radius*.

Of course in this example we ended up doing a blur, to do a blur!
However, the blur pattern that is multiplied against the FFT magnitude image used is fixed, and could in fact be retrieved from a pre-generated cache.
Also the multiplying image does not need to be the full size of the original image, you can use a smaller image.
As such, the above can be a lot faster for large images, and in the case of handling lots of images.

The more important point is for large strong blurs, the frequency domain image is small, and only does a single multiply, rather then having to average lots of pixels, for each and every pixel in the original image.

For small sized blurs you may be better with the more direct convolution blur.

### Detecting Edges In An Image - High Pass Filtering {#edge_detection}

In the spatial domain, high pass filters that extract edges from an image are often implemented as convolutions with positive and negative weights such that they sum to zero.

Things are much simpler in the frequency domain.
Here a high pass filter is just the negated version of the low pass filter.
That is where the low pass filter is bright, the high pass filter is dark and vice versa.
So, in ImageMagick, all we need do is to [-negate](../option_link.cgi?negate) the low pass filter image.

So, let's apply high pass filters to the Lena image using a circle image.
And then again using a purely gaussian curve.

~~~
convert circle_r14.png -negate circle_r14i.png
convert lena.png -fft \
     \( -clone 0 circle_r14i.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_edge_r14_spec.png +delete \) \
     -delete 0 +swap -ift -normalize lena_edge_r14.png

convert -size 128x128 xc: -draw "point 64,64" -blur 0x14 \
        -auto-level   gaussian_s14i.png
convert lena.png -fft \
     \( -clone 0 gaussian_s14i.png -compose multiply -composite \) \
     \( +clone -evaluate log 10000 -write lena_edge_s14_spec.png +delete \) \
     -delete 0 +swap -ift -normalize lena_edge_s14.png
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_spectrum.png)](lena_spectrum.png)
![x](../img_www/multiply.gif)
[![\[IM Output\]](circle_r14i.png)](circle_r14i.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_edge_r14_spec.png)](lena_edge_r14_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_edge_r14.png)](lena_edge_r14.png)
[![\[IM Output\]](gaussian_s14i.png)](gaussian_s14i.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_edge_s14_spec.png)](lena_edge_s14_spec.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_edge_s14.png)](lena_edge_s14.png)

Carefully examining these two results, we see that the simple circle is not quite as good as the gaussian, as it has 'ringing' artifacts and is not quite as sharp.

### Sharpening An Image - High Boost Filtering {#sharpening}

The simplest way to sharpen an image is to high pass filter it (without the normalization stretch) and then blend it with the original image.

~~~
convert lena.png -fft \
     \( -size 128x128 xc: -draw "point 64,64" -blur 0x14 -auto-level \
        -clone 0 -compose multiply -composite \) \
     -delete 0 +swap -ift \
     lena.png -compose blend -set option:compose:args 100x100 -composite \
     lena_sharp14.png
~~~

[![\[IM Output\]](lena.png)](lena.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](lena_sharp14.png)](lena_sharp14.png)

Here a high pass filter, is done in the frequency domain and the result transformed back to the spatial domain where it is blended with the original image, to enhance the edges of the image.

### Noise Removal - Notch Filtering {#noise_removal}

Many noisy images contain some kind of patterned noise.
This kind of noise is easy to remove in the frequency domain as the patterns show up as either a pattern of a few dots or lines.
Recall a simple sine wave is a repeated pattern and shows up as only 3 dots in the spectrum.

In order to remove this noise, one simply, but unfortunately, has to manually mask (or notch) out the dots or lines in the magnitude image.
We do this by transforming to the frequency domain, create a grayscale version of the spectrum, mask the dots or lines, threshold it, multiply the binary mask image with the magnitude image and then transform back to the spatial domain.

Let's try this on the [clown image](http://www.mediacy.com/index.aspx?page=AH_FFTExample), which contains a diagonally striped dither-like pattern.
First we transform the clown image to create its magnitude and phase images.

~~~
convert clown.jpg -fft \
        \( +clone  -write clown_phase.png +delete \) +delete \
        -write clown_magnitude.png  -colorspace gray \
        -auto-level -evaluate log 100000  clown_spectrum.png
~~~

[![\[IM Output\]](clown.jpg)](clown.jpg)  
Original
  
![==&gt;](../img_www/right.gif)
  
[![\[IM Output\]](clown_spectrum.png)](clown_spectrum.png)  
Spectrum
  
[![\[IM Output\]](clown_phase.png)](clown_phase.png)  
Phase

We see that the spectrum contains four bright star-like dots, one in each quadrant.
These unusual points represent the pattern in the image we want to get rid of.

The bright dot and lines in the middle of the image are of no concern as they represent the DC (average image color), and effects of the edges from the image, and should not be modified.

Note that when generating the spectrum image I forced the resulting image to be a pure gray-scale image.
This is so I can now loaded the image into an editor, and using any non-gray color (such as red), I masked out the area of those 4 star like patterns.

When finished editing I can extract the areas I colored, by extracting a difference image against the unedited version.
Like this...

~~~
convert clown_spectrum_edited.png clown_spectrum.png \
        -compose difference -composite \
        -threshold 0 -negate clown_spectrum_mask.png
~~~

[![\[IM Output\]](clown_spectrum_edited.png)](clown_spectrum_edited.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](clown_spectrum_mask.png)](clown_spectrum_mask.png)

Now we simply multiply the mask with the magnitude and use the result with the original phase image to transform back to the spatial domain.
We display the original image next to it for comparison:

~~~
convert clown_magnitude.png clown_spectrum_mask.png \
        -compose multiply -composite \
        clown_phase.png -ift clown_filtered.png
~~~

[![\[IM Output\]](clown.jpg)](clown.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](clown_filtered.png)](clown_filtered.png)

  
A very good result.
But we can do even better.
  
As you saw in the previous examples, simple 'circles' are not particularly friendly to a FFT image, so let's blur the mask slightly...

~~~
convert clown_spectrum_mask.png \
        -blur 0x5 -level 50x100%  clown_mask_blurred.png
~~~

[![\[IM Output\]](clown_mask_blurred.png)](clown_mask_blurred.png)
  
And filter the clown, this time re-generating the FFT images in memory.

~~~
convert clown.jpg -fft \
        \( -clone 0 clown_mask_blurred.png -compose multiply -composite \) \
        -swap 0 +delete -ift clown_filtered_2.png
~~~

[![\[IM Output\]](clown_filtered_2.png)](clown_filtered_2.png)

A simply amazing result!
And one that could possibly be improved further by adjusting that mask to fit the 'star' shapes better.
  
We can even take the difference between the original and the result to create an image of the areas where noise was removed.

~~~
convert clown.jpg clown_filtered_2.png -compose difference \
        -composite -normalize clown_noise.png
~~~

[![\[IM Output\]](clown_noise.png)](clown_noise.png)

Let's try this on an another example.
This time on a "Twigs" image found on the [RoboRealm](http://www.roborealm.com/help/FFT.php) website, which contains an irregular pattern of horizontal and vertical stripes.

Again we extract a grey-scale spectrum image, just as we did before.

~~~
convert twigs.jpg -fft +delete -colorspace gray \
        -auto-level -evaluate log 100000 twigs_spectrum.png
~~~

[![\[IM Output\]](twigs.jpg)](twigs.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](twigs_spectrum.png)](twigs_spectrum.png)

In this case, as the noise in the image is horizontally and vertically oriented, this shows up as thick horizontal and vertical bands along the center lines but not in the actual center of the image.

Again we mask out the parts using an image editor, this time using a 'blue' color (it really doesn't matter which color is used)...

~~~
convert twigs_spectrum_edited.png twigs_spectrum.png \
        -compose difference -composite \
        -threshold 0 -negate twigs_spectrum_mask.png
~~~

[![\[IM Output\]](twigs_spectrum_edited.png)](twigs_spectrum_edited.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](twigs_spectrum_mask.png)](twigs_spectrum_mask.png)

Now we again multiply the mask with the FFT magnitude image, and reconstruct the image.

~~~
convert twigs.jpg -fft \
        \( -clone 0 twigs_spectrum_mask.png -compose multiply -composite \) \
        -swap 0 +delete  -ift twigs_filtered.png
~~~

[![\[IM Output\]](twigs.jpg)](twigs.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](twigs_filtered.png)](twigs_filtered.png)

And we can take the difference between the original and the result to create an image of the areas where noise was removed.

~~~
convert twigs.jpg twigs_filtered.png -compose difference -composite \
        -normalize twigs_noise.png
~~~

[![\[IM Output\]](twigs_noise.png)](twigs_noise.png)

Adding a little blur to the mask, could again improve the results even more.

As an exercise, try removing the string from the image.
As a hint, remember how the effect of a line in a real image is rotated 90 degrees in the FFT.
If you get this wrong, you'll probably remove the twig instead.

## Advanced Applications {#advanced}

Some of the other more advanced applications of using the Fourier Transform include: 1) deconvolution (deblurring) of motion blurred and defocused images and 2) normalized cross correlation to find where a small image best matches within a larger image.

Examples of FFT Multiplication and Division (deconvolution) moved to a [sub-directory](fft_math/) as it is waiting for more formally defined image processing operators.

---
created: 22 July 2000  
updated: 27 October 2011  
author:
- "[Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html), &lt;fmw at alink dot net&gt;"
- "with editing and formating by [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.2-3
url: http://www.imagemagick.org/Usage/fourier/
---
