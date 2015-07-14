# Resampling by Nicolas Robidoux

**Index**  
  
[![](../../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../../)
  
[![](../../img_www/granitesm_left.gif) Resampling Filters](../)
  
[![](../../img_www/granitesm_right.gif) Methods Recommended by Nicolas Robidoux](#short)
  
-   [**Short Answer**](#short)
-   [Quality Control](#quality)
-   [Detailed Answer](#detailed)
-   [Recommended Upsampling Methods (Enlarging)](#upsampling)
-   [Upsampling Examples](#upsampling_examples)
-   [Recommended Methods for Downsampling (Shrinking)](#downsample)
-   [Downsampling Examples](#downsampling_examples)
-   [Borderline Cases](#borderline)
-   [Feedback](#feedback)
-   [Thanks](#thanks)

The following has been provided by [Nicolas Robidoux](http://ca.linkedin.com/pub/nicolas-robidoux/40/3ab/b73), now a Senior Research Scientist at [Phase One A/S](http://www.phaseone.com). He has been of great help in improving image processing in ImageMagick, especially the development of [Cylindrical Filters](../#cylindrical) as used by the EWA resampling of the [General Distortion Operator](../../distorts/#distort).
The following are his views on image filters and the best techniques to either shrink (down sample) or enlarge (up sample) different types of images for different requirements. Note that Nicolas is a very active researcher, and as such the following views do change over time.
WARNING: Some of the techniques may only work with recent versions of ImageMagick, and many of the filters do not (and may never) have 'named' filters within ImageMagick "`-filter`" setting, so require the use of [Expert Filter Controls](../#options).

------------------------------------------------------------------------

### Short Answer

When resizing, I (Nicolas Robidoux) generally stick to either a tensor (orthogonal, or 2-pass) [Resize (`-resize`) Operator](../../resize/#resize) filter, or an EWA (Elliptical Weighted Averaging) [Distort Resize (`-distort Resize`) operator](../../resize/#distort_resize). Although the filter kernels used with tensor and EWA operations are built using the same families of mathematical functions, they give very different results when used with `-resize` and when used with `-distort Resize`.
  
 If you want to use one single filter for everything and would rather avoid complications like color space manipulations and fancy parameters, use the [LanczosSharp EWA (Elliptical Weighted Averaging) Filter](../#lanczos_sharp). It produces images that are slightly blurry, with no jaggies to speak of and reasonably mild halos.
  
      convert {input} -filter LanczosSharp -distort Resize 200% {output}

The above command resizes by 200 percent, that is, it doubles the width and height of the original image. Change "`200%`" to the desired [size specification](../../resize/#resize). In addition, "`{input}`" and "`{output}`" should be replaced by the full names of the original and resized images.
  
 For much sharper results, use the [tensor (orthogonal or 2-pass resize) Lanczos Filter](../#lanczos).
  
      convert {input} -filter Lanczos -resize 200% {output}

For certain types of images and operations, tensor Lanczos is the [default](../#default_filter) `-resize` filter and you can omit "`-filter Lanczos`".
I do not recommend tensor (`-resize`) Lanczos filtering unless you use an [HDRI Version of ImageMagick](../../basics/#hdri). This has nothing to do with any flaw of the tensor Lanczos filter. It has to do with the ImageMagick implementation of tensor filters, which saves memory by clamping intermediate results as a side effect of storing them into 8 or 16-bit unsigned integers (HDRI saved them as doubles, so are unaffected). In other words, the generally mild artefacts that arise when using tensor Lanczos without HDRI result from an "engineering decision" that allows `-resize` filters to run significantly faster than EWA ones. The present recommendations focus on quality, not speed.
(To find out whether you are running a Q8, Q16 or HDRI version of the convert command, run `convert -version`. If "HDRI" appears somewhere in the output text message, it's HDRI. If "Q8" appears, it's Q8. Otherwise, it's Q16, the most commonly installed version. If you don't know what version you have installed, chances are it's Q16.)
If you want something about as sharp as tensor Lanczos with a Q8 (8-bit) or Q16 (16-bit) ImageMagick, use [EWA Lanczos Radius 3](../#lanczos_radius).
  
      convert {input} -filter LanczosRadius -distort Resize 200% {output}

EWA Lanczos Radius 3 (`-filter LanczosRadius`) is a recent addition to ImageMagick (version 6.8.0-2). See the [Recommended Upsampling Methods (Enlarging)](#upsampling) section below for code (with one "fancy parameter") that reproduces this filter with older ImageMagick releases.
  
 [EWA LanczosSharp](../#lanczos_sharp), [tensor Lanczos](../#lanczos), and [EWA Lanczos Radius 3](../#lanczos_radius) add two [halo rings](../#ringing) to sharp interfaces and lines.
To make the second halo unnoticeable, use EWA Quadratic-windowed Jinc 3-lobe, nicknamed "QuadraticJinc". (One "fancy parameter" is needed to generate this filter.)
  
      convert {input} -define filter:window=Quadratic -distort Resize 200% {output}

  
 To eliminate the second halo completely, use the [EWA Robidoux Filter](../#robidoux).
  
      convert {input} -distort Resize 200% {output}

Robidoux is the [default](../#default_filter) "`-distort Resize`" filter. This is why the above command does not contain "`-filter Robidoux`".
With HDRI ImageMagick, I recommend tensor [Mitchell](../#mitchell) (the Mitchell-Netravali filter) over EWA Robidoux. Tensor Mitchell and EWA Robidoux are very similar. Although both have no second halo, EWA Robidoux has less of it, and its halo is "smoother". However, tensor Mitchell manages to be slightly sharper without usually being more jaggy.
  
      convert {input} -filter Mitchell -resize 200% {output}

Mitchell is the [default](../#default_filter) `-resize` filter for some types of images and operations. For this reason, "`-filter Mitchell`" can often be omitted.
  
 If you do not want to introduce any halo, use the EWA [Quadratic B-spline Filter](../#gaussian_other).
  
      convert {input} -filter Quadratic -distort Resize 200% {output}

The quadratic B-spline filter is quite blurry, although less so than the better known, and even smoother, [tensor cubic B-spline smoothing filter](../#gaussian_other).
  
 Here is a list of the above filters in decreasing order of sharpness (more is good) and halo (more is bad): tensor Lanczos (sharpest, with the most halo), EWA LanczosRadius, EWA LanczosSharp, EWA QuadraticJinc, tensor Mitchell, EWA Robidoux, and finally EWA Quadratic (very blurry, with no halo). Of course, halo and blur are not the whole story: Most importantly, there are also moiré, tonal drift and "jaggies" to worry about.
If you are willing to add just one bell and whistle to your toolchain, it should be to downsample (shrink, or reduce) images through linear light. When downsampling (for example, making a thumbnail), you really should filter through the linear RGB or XYZ color spaces, as discussed in [Colorspace Correction](../../resize/#resize_colorspace). Although this is less of an issue with blurry images and images without dense color patterns, not downsampling through linear light can cause great damage, as documented in [Eric Brasseur's Gamma Error in Picture Scaling](http://www.4p8.com/eric.brasseur/gamma.html) (which unfortunately presents outdated ImageMagick commands).
On the other hand, I do not recommend upsampling (enlarging) through linear light. That is: You generally should *not* use standard linear light [Colorspace Correction](../../resize/#resize_colorspace) when enlarging images, at least when using filters with significant negative lobes (any filter that introduces haloing, which means most of them). Compare the RGB and XYZ (linear light) enlargements to the sRGB (not color corrected) and sigmoidized (custom color corrected) enlargements shown in the [Enlarge with sRGB, RGB, LAB, LUV, XYZ, sigmoidal...? ImageMagick Forum thread](../../forum_link.cgi?f=22&t=21804). The linear light enlargements (RGB and XYZ) are almost always significantly worse. The [sigmoidized](../../resize/#resize_sigmoidal) elargements generally look best, although [enlargements through Lab](../../resize/#resize_lab) are sometimes even better. Enlargements through linear light often look so bad that you are better off ignoring color space issues and filtering sRGB pixel values directly (using commands like the above).
### Quality Control

Use the [Expert Filter Option](../#options) "`-define filter:verbose=1`" to make ImageMagick give detailed information on the selected filter for a resize or distort operation.
Do not use an IM Q8 (8-bit) version of ImageMagick with [Colorspace Correction](../../resize/#resize_colorspace) (`-colorspace`), or [Sigmoidal Colorspace](../../resize#resize_sigmoidal) (`-sigmoidal-contrast`) resize techniques.
Do use a [HDRI Version of IM](../../basics/#hdri) when using a tensor (2-pass) [Resize Operator](../../resize/#resize) (`-resize`) with a filter with one or more negative lobes. HDRI prevents internal clipping of "between resize passes" intermediate values. This clipping leaves small artefacts, especially when enlarging. HDRI is not necessary with the [Triangle](../#triangle), [Quadratic](../#quadratic) and [Spline](../#spline) filters, because they don't have negative lobes. HDRI is also unnecessary with `-distort Resize`.
Almost always downsample (shrink) through linear light (provided you do not use a Q8 (8-bit) version of ImageMagick), and almost never upsample (enlarge) through linear light. Working with the wrong colorspace can have as much impact as a bad filter choice. (The real solution may be to choose filters that work well with linear light even when enlarging, but it is more expedient to change color space.)
The chosen conversions into and out of linear RGB assume sRGB input and output images. Other color spaces may require different conversions (into and out of the XYZ color space, for example).
You may want to navigate color spaces using color profiles instead of the built-in conversion utility (`-colorspace`).
These recommendations have not been carefully checked with an active transparency channel.
### Detailed Answer

Downsampling (reducing the image's pixel count, for example, producing thumbnails) and upsampling (enlarging or, more generally, resampling without downsampling much) produce different artefact mixes. For this reason, different techniques are recommended for each type of geometrical operation.
### Recommended Upsampling Methods (Enlarging)

Results of resizing using the [LanczosSharp EWA Filter](../#lanczos_sharp) through a [Sigmoidized Colorspace](../../resize/#resize_sigmoidal) are fairly artefact free, if a bit blurry. The built-in LanczosSharp, discussed in the [Short Answer](#short), works well, but I prefer a version with slightly less de-blur, obtained with the "`-filter Lanczos -define filter:blur=.9891028367558475`".
  
      convert {input} -colorspace RGB +sigmoidal-contrast 7.5 \
              -filter Lanczos -define filter:blur=.9891028367558475 \
              -distort Resize 500% \
              -sigmoidal-contrast 7.5 -colorspace sRGB {output}

You would get nearly identical results with the built-in LanczosSharp filter, which is obtained by replacing "`-filter Lanczos -define filter:blur=.9891028367558475`" by "`-filter LanczosSharp`".
"Sigmoidization" has to do with the pair of [Sigmoidal Contrast](../../color_mods/#sigmoidal) operators. Basically, the "`+sigmoidal-contrast`" operator (with a "`+`") converts the linear RGB version of the image created by `-colorspace RGB` to a custom RGB color space that has a S-shaped "intensity curve" instead of a linear one. This "intensity curve" is a bit like piecing together two sRGB gamma curves (one using negated images) to make a symmetrical S curve. The "`-sigmoidal-contrast`" operator (with a "`-`") converts the result of filtering back to a normal linear RGB result, which is converted back to the sRGB colorspace for the final save.
You may decrease halos and increase perceptual sharpness by increasing the sigmoidal contrast (up to 11.5, say). Higher contrasts are especially recommended with greyscale images (even "false RGB greyscale" that have three proportional color channels). The downside of sigmoidization is that it sometimes produces "color bleed" artefacts that look a bit like cheap flexographic ("gummidruck") printing or chromatic aberration. In addition, sigmoidization's "fattening" of extreme light and dark values may not work for your image content. If such artefacts are obvious, push the contrast value down from 7.5 (to 5, for example, or even lower). Setting the contrast to 0 is equivalent to enlarging through linear RGB.
WARNING: The two sigmoidal contrast values must match. That is: If you change the first "7.5" to "5", you must do the same with the second "7.5" as well. Likewise, if you remove one of the `-colorspace` commands, also remove the other one unless, of course, you actually intend to convert to another color space. The commands shown in these recommendations assume that the input and output color spaces are both sRGB.
You may skip sigmoidization altogether, by omitting the two "`+/-sigmoidal-contrast`" commands, in which case I recommend converting into and out of the Lab color space instead of linear RGB.
  
      convert {input} -colorspace Lab \
              -filter Lanczos -define filter:blur=.9891028367558475 \
              -distort Resize 500% -colorspace sRGB {output}

As discussed at the end of the [Short Answer](#short), enlargements of sRGB images through linear RGB generally look worse than enlargements that are performed by filtering sRGB pixel values directly. In any case, you should omit the two `-colorspace` commands is you use a Q8 version of ImageMagick.
  
      convert {input} -filter Lanczos -define filter:blur=.9891028367558475 \
              -distort Resize 500% {output}

The last three commands show how to use one single filter (my favorite EWA LanczosSharp variant, specified by "`-filter Lanczos -define filter:blur=.9891028367558475 -distort Resize`") three different ways, defined by the color space in which the "mixing of pixel values" is done: sigmoidal, Lab, and sRGB. Every filter can be used with every one of the recommended color spaces. In the remainder of this section, I only show the sigmoidized version.
  
 If you want sharper results, use sigmoidized EWA with another modified "Cylindrical Lanczos 3" filter, namely [EWA Lanczos Radius 3](../#lanczos_radius).
  
      convert {input} -colorspace RGB +sigmoidal-contrast 7.5 \
              -filter LanczosRadius -distort Resize 500% \
              -sigmoidal-contrast 7.5 -colorspace sRGB {output}

The above command does not work with ImageMagick older than version 6.8.0-2. You can reproduce this EWA Lanczos Radius 3 by manually setting the `blur` variable.
  
      convert {input} -colorspace RGB +sigmoidal-contrast 7.5 \
              -filter Lanczos -define filter:blur=.9264075766146068 \
              -distort Resize 500% \
              -sigmoidal-contrast 7.5 -colorspace sRGB {output}

The [Blur Expert Control](../#blur) can be used to adjust the sharpness of the scheme. Decreasing `blur` increases sharpness, mostly at the expense of increasing jaggies (when downsampling, increasing moiré). Setting "`blur=.9264075766146068`" scales the EWA disc so it has a radius equal to exactly 3, hence the name "EWA Lanczos Radius 3". (Setting "`blur=.9812505644269356`" reproduces the built-in EWA LanczosSharp filter.)
  
 If you want something even sharper, use a sigmoidized tensor (orthogonal or 2-pass resize) "Ginseng 3-lobe" filter.
  
      convert {input} -colorspace RGB +sigmoidal-contrast 7.5 \
              -define filter:window=Jinc -define filter:lobes=3 \
              -resize 500% -sigmoidal-contrast 7.5 -colorspace sRGB {output}

"Ginseng" refers to "Jinc-windowed Sinc" filter: it is a pun based on the similarity of the pronunciations of "Jinc-Sinc" and "Ginseng". Unlike almost all EWA filters, as well as the commonly used tensor [Mitchell-Netravali (`Mitchell`) filter](../#mitchell)), the Ginseng tensor filter, like the tensor [Lanczos Filter](../#lanczos), is interpolatory, usually a good thing as far as sharpness is concerned. With HDRI turned on, tensor Ginseng is actually recommended over EWA Lanczos Radius 3.
  
 If the second halo of the above filters bothers you, try sigmoidized EWA Jinc 3-lobe windowed with quadratic B-spline ("QuadraticJinc").
  
      convert {input} -colorspace RGB +sigmoidal-contrast 7.5 \
              -define filter:window=Quadratic -distort Resize 500% \
              -sigmoidal-contrast 7.5 -colorspace sRGB {output}

  
 You can eliminate the second halo completely using sigmoidized `-distort Resize` and `-resize` with [Keys cubics](../#cubics). These filters are discussed further in the downsampling section below. I recommend them more for downsampling than upsampling. Nonetheless, they are easy to adjust to taste, and give pretty good results. Start with tensor Mitchell (`-filter Mitchell -resize`) and EWA Robidoux (`-distort Resize`), and give a try to EWA RobidouxSharp (`-filter RobidouxSharp -distort Resize`) and tensor Catmull-Rom (`-filter CatRom -resize`) if you want something sharper. (Only use `-resize` with HDRI.)
  
 If you do not want to add any haloing whatsoever, use sigmoidized EWA quadratic B-spline smoothing. It is blurry, but it strikes a pretty good balance between sharpness and jaggedness for a monotone filter. Because it is smoothing, higher values of the contrast are recommended.
  
      convert {input} -colorspace RGB +sigmoidal-contrast 9.5 \
              -filter Quadratic -distort Resize 500% \
              -sigmoidal-contrast 9.5 -colorspace sRGB {output}

If your image contains lines that are perfectly vertical or horizontal, or contains synthetic linear color gradients, you may want to use sigmoidized [tensor quadratic B-spline smoothing filter](../#gaussian_other) instead of the EWA version. The tensor version is obtained by replacing "`-distort Resize`" by "`-resize`". It is blurrier, by a minuscule amount, than the EWA one. Because it has no negative lobe, tensor Quadratic works fine without HDRI.
  
 If you want neither halos nor jaggies and are willing to live with a lot of blur, use sigmoidized EWA cubic B-spline smoothing.
  
      convert {input} -colorspace RGB +sigmoidal-contrast 10.75 \
              -filter Spline -distort Resize 500% \
              -sigmoidal-contrast 10.75 -colorspace sRGB {output}

Again, you may want to try the [tensor (`-resize`) version](../#gaussian_other); it preserves horizontal and vertical features well, and is very slightly more blurry. It works fine without HDRI.
### Upsampling Examples

In this section, I show the results of enlarging a minuscule image produced by the following code, 10 times (from 10x6 to 100x60).
  
      convert -size 10x6 xc:grey20 +antialias \
              -draw 'fill white line 4,0 5,5' line.png

The same test image and enlargement ratio was used in the enlargement section of the [Filter Comparison.](../#compare)
First, enlargements performed with sigmoidization.
[![\[IM Output\]](enlarged_sigmoidize.png)](enlarged_sigmoidize.png)

The `Point` enlargement, which uses nearest neighbor pixel replication, is there to show the tiny 10x6 image, unprocessed. The other filters are ordered based on the amount of halo and blur they introduce.
Besides nearest neighbour (Point), the comparison includes four interpolatory filters: tensor Cosine-windowed Sinc 3-lobe a.k.a. Cosine (`-filter Cosine -resize`), tensor Sinc-windowed Sinc 3-lobe a.k.a. Lanczos (`-filter Lanczos -resize`), tensor Jinc-windowed Sinc 3-lobe a.k.a. Ginseng (`-define filter:window=Jinc -define filter:lobes=3 -resize`), and tensor filtering with the Catmull-Rom Keys bicubic a.k.a. Catrom (`-filter CatRom -resize`). The interpolatory filters are among the sharpest and most jaggy, with deep halos. Indeed, sharpness is approximately proportional to the amount of haloing and jaggedness when using a high quality filter.
Here are the results of enlarging through the Lab color space (without sigmoidization).
[![\[IM Output\]](enlarged_lab.png)](enlarged_lab.png)

Here are the results of enlarging without the `colorspace` and `sigmoidal-contrast` commands, that is, filtering sRGB pixel values directly. They are quite similar to the results of enlarging through the Lab color space.
[![\[IM Output\]](enlarged_srgb.png)](enlarged_srgb.png)

Finally, here are the results of enlarging through linear RGB (without sigmoidization). Such results are the basis for the "don't enlarge through linear light" recommendation.
[![\[IM Output\]](enlarged_linear.png)](enlarged_linear.png)

### Recommended Methods for Downsampling (Shrinking)

Basically, the filters recommended for upsampling are also recommended for downsampling. Downsampling, however, should almost always be done using a linear light [Colorspace Correction](../../resize/#resize_colorspace) technique.
ImageMagick has two linear light [color spaces](../../color_basics/#other) built in: RGB and XYZ. With sRGB images, the RGB color space, which stands for linear RGB with sRGB primary colors in ImageMagick, is the obvious choice. In some situations (jarringly obvious dark halos, sharp images without dense pixel patterns), it may be preferable to use mild (contrast&lt;4) sigmoidization. In general, however, you should stick to linear light downsampling. This is what is done in the remainder of this section. (Of course, downsample without color space conversions when using Q8 ImageMagick.)
First, try downsizing through linear RGB with the [LanczosSharp EWA Filter](../#lanczos_sharp) variant discussed in the upsampling section.
  
      convert {input} -colorspace RGB \
              -filter Lanczos -define filter:blur=.9891028367558475 \
              -distort Resize 20%    -colorspace sRGB {output}

For sharper results, use linear light [EWA Lanczos Radius 3](../#lanczos_radius).
  
      convert {input} -colorspace RGB -filter LanczosRadius \
              -distort Resize 20% -colorspace sRGB {output}

You can increase sharpness by decreasing the `blur` value. For example, "`blur=0.88549061701764`" generates a decent strongly sharpening filter called "EWA Lanczos3Sharpest" in the ImageMagick Forums and in Adam Turcotte's forthcoming Masters thesis.
Very sharp results are obtained with [tensor Cosine-windowed Sinc 3-lobe](../#cosine), a.k.a. `Cosine`.
  
      convert {input} -colorspace RGB -filter Cosine \
              -resize 20% -colorspace sRGB {output}

[Tensor Lanczos](../#lanczos) is sharper than tensor Ginseng but softer than tensor Cosine. They give similar results. I actually prefer the Ginseng results, but many people want very sharp results when downsampling. Recommending tensor Cosine is consistent with this common preference. (Remember to use HDRI with such `-resize` filters.)
You can decrease moiré by increasing the blur value, by increasing the number of lobes, and/or by changing window function. Increasing the blur value is safe, although it also decreases sharpness. I generally do not recommend using more than three lobes, because I do not like seeing more than two halos, and I find the benefits of using more than four lobes to be small. This being said, if your original image is blurry, the additional halos may be invisible, and increasing the number of lobes may be worth a try.
I do not recommend changing window functions if you don't really know what you are doing. (This being said, the Hann window function is a solid general purpose window, and Parzen works well with four lobes.)
  
 Another annoying artefact is [haloing (ringing)](../#ringing). The above filters all have noticeable second halos. The following filter, EWA quadratic B-spline-windowed Jinc 3-lobe ("QuadraticJinc"), has a very mild second halo and yet manages fairly strong moiré suppression without being too blurry.
  
      convert {input} -colorspace RGB -define filter:window=Quadratic \
              -distort Resize 20% -colorspace sRGB {output}

  
 To eliminate the second halo completely, use linear light [Robidoux EWA Filtering](../#robidoux).
  
      convert {input} -colorspace RGB \
              -distort Resize 20% -colorspace sRGB {output}

The [Robidoux Filter](../#robidoux) is a member of the [Keys family of BC-splines](../#cubics). You can dial the sharpness and haloing of the result by adjusting the B parameter. "`B=1.0`" reproduces EWA cubic B-spline filtering, a halo-free but very blurry filter; "`B=0.0`" reproduces EWA Catmull-Rom filtering, a very strongly sharpening filter; and linear light EWA Robidoux can be reproduced with the following command.
  
      convert {input} -colorspace RGB \
              -filter Cubic -define filter:B=.37821575509399867 \
              -distort Resize 20% -colorspace sRGB {output}

From blurry (less halo) to sharp (more halo), the named Keys cubics are Spline, Robidoux, Mitchell, RobidouxSharp, and CatRom. See [Cubic B,C Expert Controls](../#cubic_bc) for a table of the B values of these filters. Without setting the B value, the named Keys cubics can be obtained using "`-filter {filtername}`" instead of "`-filter Cubic -define filter:B={value}`".
Although, with Keys cubics, I prefer linear light EWA filtering when downsampling, linear light tensor filtering with Keys cubics is also recommended (provided you use HDRI). This is obtained by replacing "`-distort Resize`" by "`-resize`". Tensor filtering with the Mitchell cubic (`-filter Mitchell -resize`) is particularly good.
  
 If you do not want any haloing, use linear light EWA or tensor Quadratic or Spline filtering (see the upsampling section). You may also get good results with linear light EWA Triangle filtering.
  
      convert {input} -colorspace RGB -filter Triangle \
              -distort Resize 20% -colorspace sRGB {output}

Linear light tensor Triangle (a.k.a. bilinear) is obtained by replacing "`-distort -resize`" by "`-resize`". Tensor Triangle is slightly blurrier and shows less moiré than its EWA version, and it preserves perfectly horizontal and vertical features better as well. It works fine without HDRI. Both EWA and tensor Triangle filtering are interpolatory.
  
 With the exception of EWA Triangle, tensor Triangle and EWA Lanczos3Sharpest, the above filters also work well when enlarging. (Tensor Triangle is actually recommended if you are enlarging just a little bit.)
Adjusting the `blur` (between 0.7 and 1.0) or `B` parameters (between 0.0 and 1.0) should obviate the need for [USM (Unsharp) Sharpening](../../resize/#resize_unsharp), a common final step when downsampling, or allow you to use less of it. Note however that low values of the `blur` and `B` parameters generally lead to considerable artefacts; high values, to blur.
### Downsampling Examples

These examples use the [Smaller Rings Image](rings_sm_orig.gif) image also used in the [Aliasing and Moiré Effects](../#aliasing) section. Instead of resizing this 200x200 image down to 100x100, using sRGB values directly, we downsize to 101x101 through linear RGB.
[![\[IM Output\]](reduced_linear.png)](reduced_linear.png)

Ideally, many concentric rings should be preserved, without the appearance of features which are not in the original. There is no such thing as a free lunch: The filters that lose the fewest rings have the most obvious artefacts. Nonetheless, some of the filters manage a pretty good balance between sharpness and aliasing, namely EWA QuadraticJinc, tensor Mitchell, and tensor Triangle. EWA LanczosSharp, EWA Quadratic, EWA Lanczos Radius 3 and EWA Robidoux also do well in this test. Generally, EWA methods have good moiré suppression.
### Borderline Cases

If you are changing the aspect ratio to the extent that you upsample (enlarge) in one direction and downsample (reduce) in the other, use a technique that works well in both situations, like linear light EWA LanczosSharp, tensor Ginseng, EWA Lanczos Radius 3, or EWA quadratic B-spline-windowed Jinc 3-lobe ("QuadraticJinc").
If you are both downsampling and upsampling, downsampling considerations should dominate your choice. For example, resize through linear light, as if you are downsampling in both directions.
The same prescription basically holds if the resizing ratio is close to 1 in both directions, for example if you are resizing a 100x100 image to 102x102, 95x95 or 102x95 (or rotating the image). First, try interpolatory filters like tensor Ginseng or tensor Triangle. The usual EWA Lanczos Radius 3, EWA LanczosSharp and EWA QuadraticJinc work well too. Sigmoidization should be used sparingly (constrast&lt;5.5), if at all. In other words, you probably should stick to linear light when barely resizing, although the "should" is weaker than if you are shrinking a lot in one or both directions.
### Feedback

I read positive and negative comments with interest. These recommendations are a work in progress, and consequently examples in which they fall short of expectations are particularly valuable.
Sigmoidization and resizing through the Lab color space, in particular, are recent additions to my tool kit and their strengths and limitations have not been carefully established. Consequently, I am particularly interested in hearing about good and bad experiences with these techniques. For example, it appears that sigmoidization is not so good with "defective" images which already contain significant ringing and haloing, or have been heavily manipulated somehow (that are far from "natural"), although it seems to do fine at enlarging CG art, line drawings and text-like images.
Sending NicolasRobidoux a message through the [ImageMagick Forums System](../../forum_link.cgi?u=17521) is a good way to point me to a relevant post. Otherwise, try &lt;nicolas.robidoux@gmail.com&gt;.
### Thanks

I (Nicolas Robidoux) thank John Cupitt, Henry HO, Bryant Moore, Mathias Rauen, Adam Turcotte, Dane Vandeputte, Luiz E. Vasconcellos and [Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html) for useful comments, with special thanks to [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html) on whose shoulders I stood when developing EWA methods. Anthony and Cristy built quite a nice platform for image processing reseach.

------------------------------------------------------------------------

Created: 10 October 2012  
 Updated: 21 October 2012  
 Author: [Nicolas Robidoux](http://ca.linkedin.com/pub/nicolas-robidoux/40/3ab/b73), &lt;nicolas.robidoux@gmail.com&gt;  
 Formating: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/filter/nicolas/`
