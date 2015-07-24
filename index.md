# Examples of ImageMagick Usage  
(Version 6)

These Web pages presents a set of examples using [ImageMagick](http://imagemagick.org/) ("IM," for short) from the command line. However, they also illustrate what can be done using the ImageMagick Application Programming Interface (API). As such, these pages should be the first stop for IM users after reading the terse [Command Line (CLI) Option manuals](http://www.imagemagick.org/script/command-line-options.php).

Often, the same questions of "*How do I...*" gets asked, over and over again on the network. The examples in these web pages, I hope, will answer most of the common "how-to" questions that arise.

 

[![\[IM Logo\]](images/logo.gif)](http://www.imagemagick.org/Usage/)

[![\[IM Version\]](version.gif)](http://www.imagemagick.org/)

[Download Page](http://www.imagemagick.org/script/download.php),  [Fedora RPM](ftp://ftp.imagemagick.org/pub/ImageMagick/linux/fedora/i386/),  
 [Linux SRPM](ftp://ftp.imagemagick.org/pub/ImageMagick/linux/SRPMS/),  [Beta Release](ftp://ftp.imagemagick.org/pub/ImageMagick/beta/)  
 [Discourse Server](forum_link.cgi?f=1)

Mirrors of IM Examples...

 

  
[Germany - Marcus Knappe](http://hoernle1.de/m/imagick6/)
Other related sites...

 

  
[Fred's ImageMagick Scripts](http://www.fmwconcepts.com/imagemagick/)  
 [RubbleWebs, PHP using IM CLI](http://www.rubblewebs.co.uk/imagemagick/)  
 [MagickWand Examples in C](http://members.shaw.ca/el.supremo/MagickWand/)
 

[![](img_www/granitesm_up.gif) Main ImageMagick Web Site](http://www.imagemagick.org/)                   [![](img_www/granitesm_up.gif) Anthony's Graphics Lab](http://www.ict.griffith.edu.au/anthony/graphics/)

![ -----](img_www/speech_start.gif)   **Practical Examples**   ![ -----](img_www/speech_start.gif) ![](img_www/space.gif)

[![](img_www/granitesm_right.gif)](basics/)

 [Basic Usage](basics/)  
![](img_www/space.gif) Basic command and image handling

[![](img_www/granitesm_right.gif)](files/)

 [Image File Handling](files/)  
![](img_www/space.gif) Reading and writing images

[![](img_www/granitesm_right.gif)](formats/)

 [Common Image Formats](formats/)  
![](img_www/space.gif) Handling GIF, JPEG, and PNG images

[![](img_www/granitesm_right.gif)](text/)

 [Text to Image Handling](text/)  
![](img_www/space.gif) Converting text into images

[![](img_www/granitesm_right.gif)](fonts/)

 [Compound Font Effects](fonts/)  
![](img_www/space.gif) Font drawing styles and techniques

[![](img_www/granitesm_right.gif)](annotating/)

 [Annotating Images](annotating/)  
![](img_www/space.gif) Labeling and overlaying images

[![](img_www/granitesm_right.gif)](thumbnails/)

 [Thumbnails and Framing](thumbnails/)  
![](img_www/space.gif) Small reference images of large photos

[![](img_www/granitesm_right.gif)](photos/)

 [Photo Handling](photos/)  
![](img_www/space.gif) Modifying photographs

[![](img_www/granitesm_right.gif)](lens/)

 [Lens Correction](lens/)  
![](img_www/space.gif) Correcting photo distortions

[![](img_www/granitesm_right.gif)](montage/)

 [Montage, Arrays of Images](montage/)  
![](img_www/space.gif) Image indexes and arrays

[![](img_www/granitesm_right.gif)](layers/)

 [Layers of Multiple Images](layers/)  
![](img_www/space.gif) Combining multiple images together

[![](img_www/granitesm_right.gif)](anim_basics/)

 [Animation Basics](anim_basics/)  
![](img_www/space.gif) Creation and study of animations

[![](img_www/granitesm_right.gif)](anim_opt/)

 [Animation Optimization](anim_opt/)  
![](img_www/space.gif) Making GIF animations smaller

[![](img_www/granitesm_right.gif)](anim_mods/)

 [Animation Modifications](anim_mods/)  
![](img_www/space.gif) Changing and merging animations

[![](img_www/granitesm_right.gif)](video/)

 [Video Handling](video/)  
![](img_www/space.gif) Handling real life video images

[![](img_www/granitesm_right.gif)](compare/)

 [Image Comparing](compare/)  
![](img_www/space.gif) Comparing two or more images

[![](img_www/granitesm_right.gif)](advanced/)

 [Advanced Techniques](advanced/)  
![](img_www/space.gif) Complex manipulations of images

[![](img_www/granitesm_right.gif)](backgrounds/)

 [Background Examples](backgrounds/)  
![](img_www/space.gif) Examples of creating random backgrounds

 

[![](img_www/granitesm_right.gif)](repositories.html)

 [**Repositories Links**](repositories.html)  
![](img_www/space.gif) Links to other IM scripts and info

[![](img_www/granitesm_right.gif)](reference.html)

 [**Reference Index**](reference.html)  
![](img_www/space.gif) Quick index for specific options

[![](img_www/granitesm_right.gif)](scripts/)

 [**Support Scripts**](scripts/)  
![](img_www/space.gif) Shell scripts used by examples

  
![ -----](img_www/speech_start.gif)   **Basic Techniques**   ![ -----](img_www/speech_start.gif) ![](img_www/space.gif)
  
[![](img_www/granitesm_right.gif)](canvas/)
  
 [Canvas Creation](canvas/)  
![](img_www/space.gif) Creating canvas and background images
  
[![](img_www/granitesm_right.gif)](color_basics/)
  
 [Color Basics and Channels](color_basics/)  
![](img_www/space.gif) Low level color handling
  
[![](img_www/granitesm_right.gif)](color_mods/)
  
 [Color Modifications](color_mods/)  
![](img_www/space.gif) General color changes
  
[![](img_www/granitesm_right.gif)](masking/)
  
 [Masking and Background Removal](masking/)  
![](img_www/space.gif) Alpha channel, and transparency handling
  
[![](img_www/granitesm_right.gif)](quantize/)
  
 [Color Quantization and Dithering](quantize/)  
![](img_www/space.gif) Reducing the number of colors
  
[![](img_www/granitesm_right.gif)](crop/)
  
 [Cutting and Bordering](crop/)  
![](img_www/space.gif) Slicing, dicing, framing, trimming
  
[![](img_www/granitesm_right.gif)](resize/)
  
 [Resizing or Scaling](resize/)  
![](img_www/space.gif) Enlarging and shrinking images
  
[![](img_www/granitesm_right.gif)](filter/)
  
 [Resampling Filters](filter/)  
![](img_www/space.gif) Controlling image resizing
  
[![](img_www/granitesm_right.gif)](compose/)
  
 [Compositing Images](compose/)  
![](img_www/space.gif) Overlaying and merging two images
  
[![](img_www/granitesm_right.gif)](draw/)
  
 [Drawing on Images](draw/)  
![](img_www/space.gif) Vector graphics, MVG and SVG images
  
[![](img_www/granitesm_right.gif)](warping/)
  
 [Simple Image Warping](warping/)  
![](img_www/space.gif) Flipping, rotating, twisting
  
[![](img_www/granitesm_right.gif)](distorts/)
  
 [Distorting Images](distorts/)  
![](img_www/space.gif) Carnival house of mirrors
  
[![](img_www/granitesm_right.gif)](transform/)
  
 [Image Transformations](transform/)  
![](img_www/space.gif) Drastic changes to the look of an image
  
[![](img_www/granitesm_right.gif)](mapping/)
  
 [Image Mapping Effects](mapping/)  
![](img_www/space.gif) Lens, glass and ripple effects
  
[![](img_www/granitesm_right.gif)](blur/)
  
 [Blurring and Sharpening Images](blur/)  
![](img_www/space.gif) Blurring, sharpening and shadows
  
[![](img_www/granitesm_right.gif)](morphology/)
  
 [Morphology of Shapes](morphology/)  
![](img_www/space.gif) Using pixel neighbourhoods
  
[![](img_www/granitesm_right.gif)](convolve/)
  
 [Convolution of Images](convolve/)  
![](img_www/space.gif) Weighted averaged neighbourhoods
  
[![](img_www/granitesm_right.gif)](fourier/)
  
 [Fourier Transforms](fourier/)  
![](img_www/space.gif) Modifying images in the frequency domain
  
[![](img_www/granitesm_right.gif)](antialiasing/)
  
 [Anti-Aliasing](antialiasing/)  
![](img_www/space.gif) Anti-aliasing effects and problems
  
[![](img_www/granitesm_right.gif)](misc/)
  
 [Miscellaneous](misc/)  
![](img_www/space.gif) Bits and pieces
  
[![](img_www/granitesm_right.gif)](api/)
  
 [APIs, Scripting, Building](api/)  
![](img_www/space.gif) Usage in other environments
  
[![](img_www/granitesm_right.gif)](windows/)
  
 [Usage under Windows](windows/)  
![](img_www/space.gif) IM on Windows PC
  
[![](img_www/granitesm_right.gif)](bugs/)
  
 [Development and Bugs](bugs/)  
![](img_www/space.gif) Development proposals and bugs, new and old
**Legend for symbols used within example pages...**

  
![](img_www/reminder.gif)![](img_www/space.gif)
  
Hint, tips or extra info
  
![](img_www/expert.gif)![](img_www/space.gif)
  
For more advanced users
  
![](img_www/warning.gif)![](img_www/space.gif)
  
Older version warnings

**Test Image Storage Directories...**   [Small Images](images/) ([image display](images/INDEX.html)),     [Photographs](img_photos/) ([fancy index](img_photos/INDEX.html)).

------------------------------------------------------------------------

## ImageMagick Examples - Introductory Notes

### What is ImageMagick? A No-Holds-Barred Summary

[ImageMagick](http://www.imagemagick.org/script/index.php) is designed for batch processing of images. That is, it allow you to combine image processing operations in a script (shell, DOS, Perl, PHP, etc.) so the operations can be applied to many images, or as a sub-system of some other tool, such as a Web application, video processing tool, panorama generator, etc. *It is not a GUI image editor*.

ImageMagick is, first of all, an image-to-image converter. That is what it was originally designed to do. That is, it will convert an image in just about any image format (tell us if it can't) to any other image format.

But it is also a library of *image processing algorithms*. These can be access via the command line and shell/DOS scripts (which these example pages demonstrate), or via a large number of programming languages, such as C, C++, Perl, Ruby, PHP, etc. See: [ImageMagick APIs](http://www.imagemagick.org/script/api.php).

Speed was never a major feature of IM, which places more emphasis on the quality of the images it generates. That is not to say that it can't transform images in a reasonable amount of time. It's just not blindingly fast. Because of this, IM can be slow to perform certain processing operations, especially when attempting to compress images into image formats that have limited capabilities.

ImageMagick concerns itself mainly with images in the form of a *rectangular array of pixels*, commonly called a "raster." It will handle "vector" image formats like Postscript or PDF, but at the cost of converting those images into a raster when loading them, and generating a vector image wrapper around the raster when saving it. As a result, vector images are often processed badly when using the default settings. However, specific options can be used to improve this situation. See: [A word about vector image formats](formats/#vector).

### About These Examples of ImageMagick Usage

These pages were developed from, and are a continuation of, my [Collection of ImageMagick Hints and Tips](http://www.ict.griffith.edu.au/anthony/info/graphics/imagemagick.hints) page I first started in 1993, and placed on the new fangled world-wide-web making its appearance around the same time. Information on many aspects of IM, and notes not included in these pages, are still present in that document. However, while the present pages were designed for you to look at, the hints and tips document was only for my own edification. So, it may be vague or chaotic in places. You are welcome to look at it, learn, and make comments on it.

Other examples were grabbed or developed from answers to users' questions on he [IM Forums](http://www.imagemagick.org/Usage/forum_link.cgi?f=1), or contributed to me as solutions to various problems.

I look forward to suggestions and e-mail from other IM users. Such e-mail generally results in improvements and expansions to these example pages.

### Command Line Environments

All examples are written for use on UNIX, and specifically GNU/Linux systems, using BASH scripting. As a consequence, some examples use shell 'for-do' loops. Most examples use a backslash '`\`' at the end of a line to continue that command on the next line. The longer commands are broken into separate lines to try to further highlight the steps being applied.

However, you can still use these examples from **PC Windows batch scripts**, with some changes to the handling of certain characters. With some slight adaptation, the examples can also be run directly from '`system`' calls in **PHP scripts**.

See [Windows Usage](windows/) and [APIs and Scripting](api/index.html) for more information on using the ImageMagick commands in these alternative environments. Contributions and test examples are welcome.

### PerlMagick, and Other APIs

It should also be possible to adapt any of these examples to use the IM API from languages such as Perl, C, C++, Ruby, PHP, and so on. I recommend trying things out on the command line first, until you get them right, and then converting the operations to the specific API you are using.

Although the situation has improved enormously with IM version 6, the command line really only deals with a single image sequence at any one time. However, APIs do not have this limitation, and allow you to manipulate multiple image sequences, separately or together, to perform more complex operations. This ability makes it simpler to implement these examples using the IM API, and removes the need to save images as temporary files, as many of the command line examples require. When using an API, only permanent and semi-permanent images need be saved to disk.

Basically, let the example pages give you a start, to let you see what is possible with ImageMagick. Then, formulate what you want to do on the command line, before coding the operations in scripts and API code, where it is harder to make extensive changes.

I also recommend that you comment your API code, **heavily**, adding the command line equivalents to what you are trying to do, if possible. That way, you can check and compare the results against those using the command line. This lets you debug problems that you may come across later, especially as improvements are made to image processing in the Core ImageMagick Library.

### Downloading Input Images and Results

As much as possible, I try to use images built-into IM (such as "`logo:`" or "`rose:`") as input images for IM example commands, or to generate input images using IM commands. I also often re-use the output of previous commands in later examples. Because of this, you usually don't need to download any 'test' images in order to try out the examples yourself.

However, such generated or built-in images are not always convenient. So, when I do use an external image, I tend to re-use that input image, or the results of previous examples, for later examples in that section.

Sometimes the original source image will be displayed or for larger images a link to the source image is provided. More commonly only the final resulting image will be shown, as the input is well known or obvious.

Almost all the IM example commands shown are executed in the same web directory in which they appear. That is, the command you see is the command that was actually used to generate the image. Because of this you can modify the page's URL to download or view the input image(s) used by an example. Extra copies of the external source images have also been placed in the "[images](images/)" and "[img\_photos](img_photos/)" sub-directories. See also the example of a [Fancy Photo Index](img_photos/INDEX.html) of those images.

If text output or image information is produced by an example, it is saved to a text file, and an image of it is generated for display on the Web page. Selecting the text output image will link you to a copy of the actual text output by the command.

In all these examples, selecting the output image should let you download the image which was actually created by the example command. But be warned, not all browsers understand all image formats used.

### External Image Sources

By the way, most of the source images used in these examples come from [Anthony's Icon Library](http://www.ict.griffith.edu.au/anthony/icons/), particularly the [background tiles](http://www.ict.griffith.edu.au/anthony/icons/desc/cl-bgnd/Icons.html), [large clip-art](http://www.ict.griffith.edu.au/anthony/icons/large/Icons.html), and [dragons](http://www.ict.griffith.edu.au/anthony/icons/dragons/Icons.html) sections of the library. (I like dragons!)

This library actually predates the WWW. I created it in 1991, due to the lack of good, clean iconic images for use on the X Window System. The advent of the WWW has of course changed this, but my original library still exists and remains available as a source of images, even though it is not actively growing.

Some specific images, and larger images, are contributed by the authors of specific examples. The authors of such examples are listed in the contributed section, or at the bottom of the page.

If you are looking for a specific image, I recommend using [Google Image Search](http://images.google.com/imghp) (or similar) to find something appropriate. You can, of course, convert or resize such images using IM for your own purposes. However, you should be careful about copyright if you plan to use such images commercially.

### PNG Images on Web Pages

[![\[IM Output\]](images/test.png)](images/test.png)

In many examples, I use an image in PNG format, such as that shown to the right of this text. The PNG image format supports images with semi-transparent pixels, a feature few other image formats provide. It is also a very well-understood image format and, as such, is usable by most of today's image programs and Web browsers.

Some Web browsers, however, do NOT handle transparent PNG images correctly (most notably Microsoft Internet Explorer v6). Because of this, I generally use the JPEG and GIF formats for images on the Web, and only use the PNG format when generating images with semi-transparent pixels, or when exact colors are needed for later examples.

To allow IE v6 browsers to display PNG images, I use a special 'style sheet' using complex JavaScript. For information on this, see [PNG with transparency for IE](http://www.ict.griffith.edu.au/anthony/wwwlab/pngtest/). Technically, this is only problem with IE, not ImageMagick.
  
### Displaying Images on Your Screen

  
Display problems can also occur when displaying images on-screen. Because of this, I recommend using a command like the following to tile a '`checkerboard`' pattern underneath the image, to highlight any transparent or semi-transparent pixels in it.
  
        composite  -compose Dst_Over -tile pattern:checkerboard image.png x:

  
[![\[IM Output\]](test_undertile.jpg)](test_undertile.jpg)

The image displayed in the above example is a special PNG-format [test image](images/test.png), which was generated using the shell script "`generate_test`". Normally, the command would output the results to your display, not onto a Web page like this.

If you look carefully, you can see the checkerboard pattern though the semi-transparent colors. However, the image, as a whole, is fully opaque. So, this technique should work on all displays, Web browsers, and image viewers.

As of IM v6.0.2, the "`display`" program performs something like this automatically. However, it does not seem to handle images using color tables (i.e., GIF) in this way. Using the "`x:`" output image format (as above) causes an image to be displayed directly to the screen, without having to save it. See [Show Output Display](files/#show) for more information.

### Font Usage

The fonts I use in these examples are from a small collection of TrueType fonts I have found over the years, and saved for my own use. Some of these are under copyright, so I cannot publish them online.

You are, however, welcome to substitute other fonts that you have available. The examples should work (perhaps with some changes to image size) with any appropriate font you have available on your system. Microsoft "Arial" font, or even "Times-BoldItalic", should work on most systems.

To see what fonts are currently available to your version of IM, run the following command...
  
        convert -list type       # for IM older than v6.3.5-7
        convert -list font       # for newer versions

WARNING: If the font requested is not found, ImageMagick used to silently substitute a default font, typically Arial or Times. It still does this, but a warning is now given. So, test the font beforehand, to make sure that it is the one you want, and not the default font.

On my Linux system, I use a special Perl script, "`imagick_type_gen`", to generate a file, "`type.xml`", saved in the "`.magick`" sub-directory of my home directory. ImageMagick uses that file, which contains a font list in XML format, to find fonts. The script "`locate`"s (run "`updatedb`" first, if you have just added new fonts), and describes all the fonts available on my system. With this setup, I only need to specify the name of the font I want to use, and not the full path to a specific font file.

For example...
  
        # Instead of using the command...
        convert -font $HOME/lib/font/truetype/favorite/candice.ttf \
                -pointsize 72 label:Anthony  anthony.gif

        # I can use the simpler font label...
        convert -font Candice -pointsize 72 label:Anthony  anthony.gif

  
![](img_www/warning.gif)![](img_www/space.gif)
  
*Before IM v6.1.2-3, the "`type.xml`" file was named "`type.mgk`". If you are using an earlier version of IM.*

The fonts used in these IM examples are listed in a [Montage of Example Fonts Example](montage/#fonts). My personal favorite is Candice, so it gets used quite a bit.
  
![](img_www/reminder.gif)![](img_www/space.gif)
  
*If you also like the '`Candice`' font, or any of the other fonts I use, grab them from [Free Fonts](http://www.webpagepublicity.com/free-fonts.html) or [1001 Fonts .com](http://www.1001fonts.com/).*

### Example Page Updates

These example pages are in an on-going cycle of improvement. Generally, I find I stop adding to these pages for long periods of time, when my interests become focused on other things.

Often these examples are re-built using the latest beta release of IM, allowing me to see changes and bugs that may appear in each version of IM, before it is generally released. However, the example images shown are what the given IM command produces on **my** system. If you get something different, your IM is probably a much older version (with old bugs), or is not correctly installed.

Note that [e-mailing me](http://www.ict.griffith.edu.au/anthony/mail.shtml), or discussing some aspect of ImageMagick on the [IM Mailing List](http://www.imagemagick.org/script/mailing-list.php), or [IM Users Forum](forum_link.cgi?f=1) will generally result in new examples, or whole new sections, being added to these examples. The more discussion there is, the better the examples become.

If you are doing anything interesting with IM, please share, and allow me to provide examples of your technique to the rest of the IM community. Some of the biggest advances in IM usage have come from users just like you.

### Special Thanks

A special thank you goes to Cristy, who has tirelessly spent months, upgrading, bug-fixing, and putting up with my off-the-wall suggestions... especially with regards to my major suggestions for the command line processing, parenthesis, image sequence operators, and GIF animation processing.

He has done a marvelous job making Version 6 the best and most advanced command line image processing program available. While most users will not show appreciation for that, I certainly do appreciate the effort he has put into IM.

I also want to thank Gabe Schaffer, who has been most helpful in discussions involving the JPEG format and library, affine matrix operators, and [Magick Vector Graphics](http://www.imagemagick.org/script/magick-vector-graphics.php) in general.

And to Glenn Randers-Pehrson, who looks after the PNG coder module and has a interest in Color Quantization and Dithering. He was the first to add 'halftone' dithering to IM, which I later revised and extended further, to added new dithers to the ordered dither configuration file.

And finally, I want to thank the huge number of people with problems, suggestions, and solutions, who generally lurk on the [IM User Forum](forum_link.cgi?f=1). Many now have their names as contributors of ideas and suggestions throughout IM Examples.

I also want to thank the people who regularly answer questions on the forums, such as '[Bonzo](forum_link.cgi?u=6256)', and his web site [RubbleWebs](http://www.rubblewebs.co.uk/imagemagick/), detailing use of IM commands from PHP scripts. Also '[scri8e](forum_link.cgi?u=143)' and his Web site, [Moons Stars](http://www.scri8e.com/stars/), for glitter and star handling. Also a thank you goes to Pete '[el\_supremo](forum_link.cgi?u=3499)' (see his [MagickWand C-Programming](http://members.shaw.ca/el.supremo/MagickWand/)), and the many others who regularly answer other peoples' questions.

A special thanks goes to [Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html), a researcher from the early days of image processing, who was a major help in the initial implementation of the [General Image Distortion Operator](distorts/#distort). You can see Fred's ImageMagick scripts on [Fred's ImageMagick Site](http://www.fmwconcepts.com/imagemagick/), often as a proof of concept for future IM additions.

Also to Nicolas Robidoux, an expert in digital image processing, for reworking the [Elliptical Weighted Average Resampling](distorts/#area_resample), which vastly improves the output of [General Image Distortion](distorts/#distort).

And finally to the many users of ImageMagick who, had allowed others to see the IM commands they use as part of some project, either on the forums, or on the web. You are all to be commended on your willingness and openness to share your findings.

Well enough "Yadda, yadda, yadda."   Go look at some of the examples.

------------------------------------------------------------------------

Created: 7 November 2003  
 Updated: 30 November 2012  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen\_AT\_griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 Licence: IM Examples follows the same [Licence as ImageMagick](http://www.imagemagick.org/script/license.php) URL: `http://www.imagemagick.org/Usage/`
