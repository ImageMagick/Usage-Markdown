# API & Scripting

The Command Line Interface (CLI) of ImageMgaick which this examples deals with is only one method by which you can use, modify and control images with the core library of ImageMagick functions (MagickCore).
It is basically the 'shell' API interface.
There are lots of other Application Programming Interfaces (API's) which you can use more directly from many programming languages, see [ImageMagick APIs](http://www.imagemagick.org/script/api.php).

Here I look at ways of improving your IM scripting and programming, differences between Windows and Unix scripting, and look at basics of using IM from other API's and programming languages.

------------------------------------------------------------------------

## APIs and other IM usage methods {#api-convert}

API's (Application Programming Interface) for actual image processing are in fact no faster than using the CLI commands (such as "`convert`" (which is itself represents a type of shell-API).
The same 'core' library is used for all image processing in IM.
So if you are doing a complex task such as image distortion, using a API over a the shell "`convert`" makes very little difference in terms of overall 'speed' of processing.

*So why use an API over Command line?*

A shell constantally 'forks' off many different commands (not just IM "`convert`" commands, though shells have some 'built-ins'), each of which has to be loaded, and initialised every time it is run.

Every IM command also has to re-initialise its configuration files, parse the command line arguments, re-read whatever images you are working with, and often save results back to disk.
All of which takes time causing them to be slower.

That is all that extra steps take time and processing power, so if you do it a lot, and API can start to make sense.

API can also allow you to do other things a command line can't.

-   If the API is already running, you have little to no setup time.
-   Store in memory a array of many image lists that can be processed in any order you like.
    For example I have a program that reads in hundreds of images, thumbnailing them as 32x32 pixel images as it reads them, them compares them all in pairs one pair at a time (9,900 compares for 100 images).
    Another would be to say sort images by general color in memory!
-   You can be doing many difference threads of image processing, in any order.
    You do not have to 'finish' one sequence of processing before working on the next image or step.
    For example imagine a program that solves a jigsaw puzzle!
-   You can retrieve information from images, and use that information in complex ways to modify image processing without having to re-initialise the image processing (re-reading configs and images) over and over.
    For example get the image size beform working out the framing requirements for the image.
-   Looping though images, doing something very different with each and every image!
    For example generating an animation sequence, with each frame distorted in a slightly different way.
-   Direct and completely random access to the image data.
    For example looking for a 'face' in an image.

But for most things not involving large numbers of images, or general procesing of images in well defined ways, the command line is pretty well just as fast.
You can however save lot ot time and re-processing by...

-   Make use of [MPC Image Saving](../files/#mpc) (for faster re-reads) of intermediate images.
    See my script [divide\_vert](../scripts/divide_vert)
-   Paralleled processing using pipe-lining (even using different machines for different steps!), to make better processor use and avoid saving intermedite images to disk.
    See [enlarge\_image](../scripts/enlarge_image) for a pipelined script example with one step piping the image(s) into the next (sometimes optional) step in the sequence.
-   Use a loop to process each image individually, before piping a stream of image results into a final 'merge them all' step.
    I have many scripts like this...
    See [Programmed Prossition of Layered Images](../layers/#layer_prog) for one such script.

Of course in an API you also have different and faster techniques could also have been used for a special processing task that would make access to the image.
And as we find and get time we often program such techniques into the core library.
Image distortions and various FX expressions is one example of this.

### Windows, and DOS {#windows}

The examples on using Windows and DOS scripting using the CLI API, has been moved to [Usage under Windows](../windows/).

### PHP {#php}

PHP users have three ways of using ImageMagick,

-   The "`imagick` PECL interface
-   The "`MagicWand`" interface
-   Using "system()" and "exec()" functions to run the CLI "`convert`" command.

Because of the existence of [IM Examples](../) this later method (and the first we will look at next) has in recent years become the most common method of using IM from PHP.

Of course for some things it may not be the best method (see above), in which case the API interfaces is available, though may require a system administrator to make them available to your PHP environment.

#### PHP using Shell Commands {#php_shell}

The best source of specific information on using this technique is the IM forum user *[Bonzo](../forum_link.cgi?u=6256)* and his web site [RubbleWebs](http://www.rubblewebs.co.uk/imagemagick/).

Please note, PHP runs "`convert`" using a different environment, and probably even as a different user, to what you would get from the command line.
As such what works on the command line, may take a little tweaking to get it to work from a PHP web driven script.

The following is the recommend procedure for initial tests of an ISP's command line IM interface, assuming you do not have direct command line 'shell' access on the remote system.
That is you can only upload web files for execution.

So the first thing we need to do is try and find the "`convert`" command on the system, what version is installed, and the environment the PHP is running.

On a Linux Web Service, upload and access this PHP script from the ISP's web server...
  
    <?php
      header('Content-Type: text/plain');
      system("exec 2>&1; pwd");
      system("exec 2>&1; type convert");
      system("exec 2>&1; locate */convert");
      system("exec 2>&1; convert -version");
      system("exec 2>&1; convert -list type"); <!-- before IM v6.3.5-7 -->
      system("exec 2>&1; convert -list font");
      print("------ENVIRONMENT VARIABLES-------\n");
      system("exec 2>&1; env");
    ?>

This will run quite a number of commands to see what your environment is like.

The first "`pwd`" tells you the current directory in which the PHP script was run.
This may or may not be the directory where the PHP script is located, and you may not be able to write in that directory form the PHP script.

The next two commands tells you if "`convert`" is available on the default provided command PATH using "`type`", and if so where is it.
The "`locate`" command should find all "`convert`" commands that exists on the server (assuming it is a linux server), but may find other non-ImageMagick "`convert`" commands, files and directories.
You will need to interpret the results.

The next three commands, assume "`convert`" is on the command PATH, and asks it to report its version number, and what fonts IM think it has access to.
Which command reports what fonts depends on how old the installed IM version is.

If you only see errors, then the "`convert`" is not on the command line path, and your ISP provider did NOT initialise the web server "`PATH`" and "`LD_LIBRARY_PATH`" properly to include it.
See output from the "`env`" command for what they did define.

If this is the case you will need to find out exactly where it is located and use something like the following PHP script.
This will make your script less portable, as it is hard coded for that specific ISP.

For example suppose the "`convert`" command is in "`/opt/php5extras/ImageMagick/bin`", then you can set a variable to specify its location.
This is often done as part of application configuration and installation process, for PHP scripts being used on different ISP hosts),
  
    <?php
      $im_path="/opt/php5extras/ImageMagick/bin"
      header('Content-Type: text/plain');
      system("exec 2>&1; $im_path/convert -version");
      system("exec 2>&1; $im_path/convert -list type");
      system("exec 2>&1; $im_path/convert -list font");
    ?>

If you get "`ldd`" library errors, the "`LD_LIBRARY_PATH`" is wrong, and the ISP has definitely fallen down on the job during its installation, and you need to report the error, and have them fix the web servers "`LD_LIBRARY_PATH`" environment variable setting, or re-install ImageMagick.

Rather than set the location of the convert command, you can also adjust the PATH environment variable with a line such as this at the top.
However this method is often 'denied' by default by typical PHP system configuration...
  
      putenv("PATH=" . $_ENV["PATH"] . ":/opt/php5extras/ImageMagick/bin");
      putenv("LD_LIBRARY_PATH=" . $_ENV["LD_LIBRARY_PATH"] .
                                       ":/opt/php5extras/ImageMagick/lib");

After that try some of the simpler examples from IM Examples and try to get them working.
For example output the IM 'rose' image as a JPEG image file back to the web user...
  
    <?php
      header( 'Content-Type: image/jpeg' );
      passthru("convert rose:  jpg:-");
    ?>

If you need to set the convert command location you can use...
  
    <?php
      header( 'Content-Type: image/jpeg' );
      $convert="/opt/php5extras/ImageMagick/bin/convert"
      passthru("$convert rose:  jpg:-");
    ?>

or if the you have library problems you can try something like...
  
    <?php
      header( 'Content-Type: image/jpeg' );
      $convert="/opt/php5extras/ImageMagick/bin/convert";
      $libs="LD_LIBRARY_PATH=\'" .  $_ENV["LD_LIBRARY_PATH"] .
                   ":/opt/php5extras/ImageMagick/bin/convert\'";
      system("$libs $convert rose:  jpg:-");
    ?>

If you still don't see anything look at my raw [PHP Hints and Tips](http://www.ict.griffith.edu.au/anthony/info/www/php.hints) file for information on techniques of redirection error messages.
  
 When you have that basic script working you can try one of the fonts listed from your PHP test scripts (modify the following to suit your PHP server).

For example on a Solaris Server I had available at this time, I noticed that the '`Utopia`' font set was available so I was able to try to create a label with that font...
  
    <?php
      header('Content-Type: image/gif');
      passthru("convert -pointsize 72 -font Utopia-Italic label:'Font Test' gif:-");
    ?>

#### Example Shell to PHP conversion {#php_example}

Here we have a fairly typical ImageMagick command...
  
      convert -background none -fill red -gravity center \
              -font Candice -size 140x92 caption:"A Rose by any Name" \
              \( rose: -negate -resize 200% \) +swap -composite    output.gif

When converting to PHP it will become something like...
  
    <?php
      header('Content-Type: image/gif');

      $color="red";
      $image="rose:";
      $scale="200%";
      $size="140x96";
      $string="A Rose by any Name";

      passthru( "convert -background none -fill '$color' -gravity center" .
                " -font Candice -size '$size' caption:'$string'" .
                " \\( '$image' -negate -resize '$scale' \\) +swap -composite" .
                " gif:-" );
    ?>

Note how I still split up the long command line of the "`convert`" command to make the image processing sequence easier to follow, and to edit later.
This was done using PHP appended strings rather than the shell line continuation used in shell scripts.

Also note the extra space at the start of later lines.
And doubling up the other backslashes that was present in the original command.
Alternatively you can protect those options by using single quotes instead of backslashes.

I also used some PHP variables to allow easier adjusted of the PHP script image generated, to provide better control the results.
However when I insert those options in the "`convert`" I used single quotes to protect them from further modification by the shell.
But watch out for single quotes within those inserted strings!

You could make those options PHP input arguments, so you can generate an image for any input text passed to it from a web request.

You can also perform multiple shell commands from within the same system call string.
In fact a single system call can contain a complete shell script if you want!
So you can do shell loops and multiple commands (with cleanups) all in the one system call.
Something not may people realise is possible.

Basically if you are careful, you can make good use of the mathematics provided by PHP, and the scripting abilities of the shell.
All at the same time.
Just watch the quotes.

For various examples of calling ImageMagick commands from PHP see [Rubble Web, Writing IM code in PHP](http://www.rubblewebs.co.uk/imagemagick/basics/explain.php) which describes about four different techniques.

#### Watch the extra quotes {#php_quotes}

Note that typically the IM commands in PHP are wrapped by an extra set of quotes (usually double quotes), as such care must be taken to allow for the use of these extra level of quoting.
Remember when PHP executes a string....

**PHP** does its quotes, backslash and variable substitutions

**Shell** then splits up arguments and does its own variable and quote substitutions.
It will also do any "2&gt;&1" type file descriptor redirections if present.

**ImageMagick** gets a argument array, but will also do its own filename meta-character handling specifically for DOS (the dos environment doesn't handle meta-chars) and for arguments such as coder:\*.gif\[50x50\] which the shell fails to expand due to coder: prefix or the \[...\] read modifier.

That is a LOT of argument parsing!
Which can mean a lot of quoting and backslashing handling.
*Caution and fore-thought is required*.

I recommend you at least read the PHP manuals on [Program Execution Functions](http://php.net/manual/en/ref.exec.php), which includes: [PHP exec()](http://php.net/function.system), [system()](http://php.net/function.exec), and [passthru()](http://php.net/function.passthru).
also look at the [Backtick Operator](http://au2.php.net/manual/en/language.operators.execution.php).
Of particular importance, understand what exactly is returned (generally the last line only) and passed on to the calling client (everything else).

#### PHP Security {#php_quotes}

Remember...

       On the net, the only users you can trust not to be potentially hostile
       are those who are  *activally*  hostile.
                                         -- Programming Perl - Camel Book, r3

You must throughly check all input arguments being passed from user to an IM command troughly.
Make sure the argument is exactly what you expect.
It is far better to be over restrictive that under restrictive when dealing with the World Wide Web.

Some common things to watch out for include

-   Binary characters in argument - a common cracker technqiue
-   Unexpected spaces, tabs, newlines and returns in arguments.
-   Backslashes (directory seperators), and '`..`' paths, Also under windows '`\`' and '`;`' in filenames.
-   File Expansion Meta-characters including "`~*?[]{}<>`" plus the special "`@`" meta-character specific to ImageMagick.
-   Other shell meta-characters including "`$#;`" and the three quote character '`'`', '`"`', '`` ` ``'
-   Argument does not match what ImageMagick expects.
    Use "`-list`" to read what types of argument IM does understand for specific options.
    For example a user input "`-gravity`" option, only has 10 different settings.
-   And so on...

For any sort of web programming work, a understanding of security and how hackers can use specially crafted arguemnts to subvert called commands, is vital.
Not just for PHP, but for Shell, and ImageMagick.

IM requires particular care as it can for example read and convert a password file into an image to be returned.
Again...
It is far better to be overly restrictive, than open a unforseen security hole, when the web is involved.

#### Writing to the Filesystem

As mentioned above, and if you followed the above initial proceedure, you will know for certain, PHP generally runs as a different.
more resctritive user on the server.

Because of this it will typicall NOT be able to write to the directory containing the script (or where ever it is actually running.
For security reasons you generally **do not want to write to that directory**!

If you really want PHP to write files, have it save the image (or data) to a unique filename in "`/tmp`", and above all **clean up afterward**, on both normal exit, or on ANY error.
It is amazing how quickly you can fill a disk with left over temporary files from a application that does not cleanup properly.

If the saved files (images) must be visible by the web server, make a special 'write by program' sub-directory, for those files.

**How it should be done.**

Most PHP applications actually avoid writing anything to the file system by using a database backend.
That is cookies, tokens, user data, images, and so on are all written into a database, such as (in order of complexity and scale) SQLite, PostgresSQL, MySQL, and Oracle.
It saves nothing in the filesystem at all.
System Programmers will typically configure the PHP application with that information when the application is installed.

Images is typically reproduced by either the same, or separate PHP script that looks up the image 'blob' and outputs it to the client.
Images may be sent as 'inline' images with the HTML itself (see, the "`inline:`" format, which has a demonstration of HTML inline images), or as a single 'all in one' multiple image, so the client HTML/JAVA only has one image reqest rather than 20 separate requests.

One final point.
Some method of cleaning up old data should always be present.
A user that has not logged in for 2 year, probably should have his data deleted.

#### Getting Error output

Try one of these methods...

~~~
<?php
exec("/usr/local/bin/convert -version",$out,$returnval);
print_r($out[0]);
?>
~~~

or

~~~
<?php
exec("/usr/local/bin/convert -list",$out,$returnval);
print_r($out);
?>
~~~

or use shell\_exec as follows

~~~
<?php
$IM_version=shell_exec("/usr/local/bin/convert -version");
echo $IM_version
?>
~~~

To include STDERR output...

~~~
<?php
$array=array();
echo "<pre>";
exec("convert read_test.png write_test.png 2>&1", $array);
echo "<br>".print_r($array)."<br>";
echo "</pre>";
?>
~~~

The above comes from the IM Users forum discussion...
[How to show IM error info in php?](../forum_link.cgi?t=18077&p=68796).
See my own [PHP Debugging Error Log](http://www.ict.griffith.edu.au/anthony/info/www/php.hints) notes.
Which points to the PHP Manual on error Logging [PHP Error Handling and Logging](http://php.net/manual/en/book.errorfunc.php), especially look at the examples section.

#### More Secure ImageMagick Commands...

Idealy for security reasons, you would want to avoid using the shell to parse a single long string into separate command and arguments.
It is better to do it yourself!
This mean you provide the arguments to the command as an array of separate strings, instead of as a one single shell-parsed string.

By doing this you prevent the posibility of shell syntax errors, the extra quoting burden needed by the shell, and prevent the posiblity of some hacker breaking the shell command and runing there own command (very bad).

On the other hand you loose shell scripting, piping, and file re-direction, but that is typlically not a great loss when you are already using PHP or some other wrapping language.

In PHP the only function I could find that will let me call command directly without a shell is the [pcntl\_exec()](http://php.net/function.pcntl-exec) function.
This basically avoids shell, and calls the command directly.

However it is a true 'execl()' system call, which replaces the current process with the command given.
That is it does not do the 'fork()' and file descriptor linkages, needed to run it as a sub-process.
As such [pcntl\_exec()](http://php.net/function.pcntl-exec) is really after too low level for generate use, and implementing a 'no-shell' command can get get fairly complex.

I am very surprised a simpler, more secure 'avoid the shell' command call has not already been provided by the PHP interface.

But then I am not a PHP programmer.
Perl on the other hand provides a number of method of securly calling sub-commands and processes, which often makes it more preferable as a web interface than PHP.

*Anyone with PHP security knowledge care to enlighten or provide pointers to more information?*

### PHP 'IMagick' API {#php_imagick}

To test if the [**PHP PECL Imagick**](http://pecl.php.net/package/imagick) module is actually working upload a simple test "`image.jpg`" image and this PHP script to the same web assessable directory.

~~~
<?php
  $handle = imagick_readimage( getcwd() . "image.jpg" );
  if ( imagick_iserror( $handle ) ) {
    $reason      = imagick_failedreason( $handle ) ;
    $description = imagick_faileddescription( $handle ) ;

    print "Handle Read failed!<BR>\n";
    print "Reason: $reason<BR>\n";
    print "Description: $description<BR>\n";
    exit ;
  }
  header( "Content-type: " . imagick_getmimetype( $handle ) );
  print imagick_image2blob( $handle );
?>
~~~

A [PHP IMagick Book](http://us3.php.net/manual/en/book.imagick.php) is available online, and more examples of using IMagick can be found in [Mikko's Blog](http://valokuva.org/?cat=1).

The only problem with IMagick is that is has not been maintained and upgraded, so there may be a number of functions that does not work or are missing.
Be sure you are using v3.x of IMagick and a current version of IM.

It does work and for most things it works well, but if you need to do the other things, then other PHP methods may be a better option.

### PHP 'MagickWand' {#php_magickwand}

You can check if the [**PHP MagickWand**](http://www.magickwand.org/) module is part of the PHP installation using...

~~~
<?php
  if (extension_loaded('magickwand')) {
    echo "PHP MagickWand is available!\n";
  } else {
    echo "PHP MagickWand is NOT available!\n";
  }
?>
~~~

But to check that it is actually working properly, upload some test "`image.png`" and this script...

~~~
<?php
  $image = NewMagickWand();
  if( MagickReadImage( $image, 'image.png' ) ) {
    header( 'Content-Type: image/jpeg' );
    MagickSetImageFormat( $image, 'JPEG' );
    MagickEchoImageBlob( $image );
  } else {
    echo "Error in MagickReadImage()";
    echo MagickGetExceptionString($image);
  }
?>
~~~

No guarantees with the above, though more feedback welcome.
I do not generally program in PHP, but used the above for testing a SunONE-PHP5 test installation (with all three methods: command-line, magick, MagickWand).

### Complex PHP scripts... {#php_complex}

If you need to generate and output both HTML and IMAGES, consider designing your PHP script so that separate HTML requests or input options, generate the various parts you need on your web document, from either the same, or different PHP scripts.

That is a top level PHP script can output HTML with appropriate &lt;IMG&gt; tags, that call itself (or another PHP script) with appropriate options, to create or modify the images displayed on the first top level PHP script.
This is in what a lot of photo album, and graphing PHP scripts do.
All controlled by the GET, and PATH\_INFO extensions to the URL calls.
Note that you can not use POST within an IMG tag.

By doing things in this way you should be able to completely avoid the need to both generate, save, and clean-up, temporary images for PHP generated web pages.
A solution that is full of problems, such as resource limitations and garbage collection, making it a very bad programming technique.

This technique looked at in both the [ImageMagick Books](http://www.imagemagick.org/script/index.php#books), though the ImageMagick it actually uses is becomming a little dated.

------------------------------------------------------------------------

### Perl Magick Scripts {#perlmagick}

The [PerlMagick](http://www.imagemagick.org/script/perl-magick.php) API is a good way of conveting "`convert`" commands into a script that can also handle databases, large numbers of images, or more complex image processing, that is otherwise posible.

The best help is to look at the PerlMagick 'demo' scripts, which is both in the source, and usually installed in the documentation area of PerlMagick.
On my system that was in "`/usr/share/doc/ImageMagick-perl-*/demo/`".
In this directly are a growing number of simple examples of reading, writing and processing various images.
Also present is the script "demo.pl" that lists just about all common Image Processing options, and how you can use them.

When converting a command line "`convert`" command to perl there are a few things you need to remember.

-   First thing to remember is that PerlMagick does not automatically delete images new images that were processed.
    Many operators create a new modified image from the old image, while others directly modify an existing image.
-   Also many operators will not apply a specific operation to a whole list of images, but only the first image in the list you give it.
    This mean you will need to loop though the image sequence (perl array) itself.
-   You can have many image sequences.
    In fact you typically read every image into its own separate image sequence, rather than having to make do with a single image sequence, as is the case on the command line.
-   Also once you have the image in memory you can easilly extract the size of the existing image.
    That means you can just create new canvases without needing to clone and clear an existing image as you do on the command line.
    However cloning an image also copies an images meta-data, so you may like to keep track of that meta-data for images such as digital photos.
-   Check for image errors (as shown on the [PerlMagick](http://www.imagemagick.org/script/perl-magick.php) page) after every major process, especially when reading images.

To convert a command line into perl, you would basically do the exact same operations, in the exact same sequence.
However as images are generally not deleted, and multiple image sequences are common, the use of parenthesis, and extra cloning operations in "`convert`" commands are usally not a issue.

The hardest part in converting scripts is usually mapping a command line option to a PerlMagick function call.
The fastest way I found is to get the source code of IM and look at the file "`wand/mogrify.c`" and search for the specific command line option you are having trouble with.

For example for say the `-threshold` option search for `"threshold"` including the quotes.
Their will be two matches, one for a quick syntax parse to make sure all the options are found, and the second with the actual internal calls for that option.
Here you will find the name of the library function used, and that will usally directly map to the Perl function.
In this case...
`BilevelImageChannel()`

------------------------------------------------------------------------

## Security Warnings {#security}

When writing a script for public use, especially a web-based PHP script where ANYONE in the world could be running it, it is vitally important to check everything that could posibly have come from a unknown (or even a known) user.
And I mean **EVERYTHING**, from arguments, filenames, URLs, and images too.

Until you verify some input argument, that argument it could contains letters, numbers, spaces, punctuation, or even 'null' and control characters.
Until you have throughly checked it, it should be treated as suspect and should not be used.

It does not matter that you are using some web controlled input form.
A slightly knowledgeable person can easily call your PHP with his own arguments without using that input form at all.
An don't believe they won't do it, robots are out there, reading input forms and creating there own 'hacked' arguments to try an break into random scripts.

### Meta-characters in file names {#globbing}

As a security issue, you should especially watch out for, are filenames that contain spaces, quotes, punctuation, control-characters, or other meta-characters as both IM and Shells may try to expand them.

The problem is that a file called '`*?@${&) .jpg`' is actually a perfectly legal filename under UNIX, but a LOT of programs will have trouble handling it if that program (like both shell and IM) also do filename expansion.

Remember even if you prevent the shell from going 'glob' meta-characters expandsion, IM itself also does this expansion (for DOS usage).
As such preventing all such characters (and producing an error), is probably a wise thing to do.

As a security measure it is often a good idea to error and abort if a filename has ANY unknown or unusual characters in it, anything that is say not letters, numbers, or in the expected suffix.
Before passing such a filename to a shell command, or IM.

It is better to be a LOT more restrictive and prevent things, than be permissive and allowing something bad through.

------------------------------------------------------------------------

## Hints for Better ImageMagick Shell/PHP Scripts {#scripts}

These were some basic script programming points I made about a contributed shell script that was sent to the IM mail list for others to use.
I originally sent these to the author privately (and who will remain anonymous), for which he was grateful.
They are not all IM specific, but should be applied anyway, as standard programming practice.
Especially if you plan to have someone else, use, look at, and/or bug fix your program or script.
It will in turn make your script more useful.

-   Place the 'help' or 'doc' at the top of scripts and programs.

    This makes it lot easier for other people to figure out what a particular program does without needing to install or run the script.
    I myself will often junk a program that has no such clear comment on what it is for rather than try to compile or run such an unknown script.

    In fact I have seen huge projects where the first README file does not even say what the huge and complex project does!
    The programmer just assumes that if you downloaded it you must know what it does!

    Also make sure that a 'bad option' such as '-?' will print a synopsis of not just the options, but also a quick summery of what the program does, or where to find such help.
    Do not just point to a remote web site, that may disappear 10 years down the track!

    For an example of a script that prints its own 'opening comments' see the "[jigsaw](../scripts/jigsaw)" script in the IM [scripts](../scripts/) area.

    Perl can use POD for self documentation (See the perl "`Pod::Usage`" module).
    For example see the contributed [dpx\_timecode.pl](../scripts/dpx_timecode.pl) script.

    Having the help as a 'here file' in the first sub-routine is also acceptable, and works for most languages.
    But have that subroutine AT THE TOP, not at the bottom or middle of the script or program.

-   Make sure you clean up your code, remove old obsolete code and comments, making things as neat an tidy as you can.
    Be concise, with simply commented stages (if possible).
    Again see the "[jigsaw](../scripts/jigsaw)" script.
-   Make sure temporary files are cleaned up at the end.

    Use a "trap" shell command to remove them on file exit or interrupt.
    You can of course re-use a single temporary files multiple times, so you don't need very many, especially with IM v6 convert commands.

    Again see the "[jigsaw](../scripts/jigsaw)" script, and search for "trap".

-   Also not everyone uses system X, though it may seem like that to you.
    Don't refer to specific system requirements, or methods on rectifying the problem.
    What works for you may be completely in-appropriate for their system and setup.
    They may not even have Internet access!

    Just say that the "`convert`" command from ImageMagick, was not found.
    If you want add installation requirements, or suggestions, add it as part of separate more extensive documentation.

-   Do check that the IM being used is a high enough version, or add backward compatible changes.
    I purposefully give 'version warning' notes throughout IM examples as to when various special features were added for this purpose.
    It makes it easier when creating scripts with a single minimal version check.

    Here is one simple way you can get a single version number for testing purposes in a shell script.
    It extracts the 4 version numbers, and inserts the right number of zeros to make each number 2 digits, producing a simple 8 digit number.
    
    ~~~
    IM_VERSION=`convert -list configure | \
         sed '/^LIB_VERSION_NUMBER /!d;
              s//,/;  s/,/,0/g;
              s/,0*\([0-9][0-9]\)/\1/g'`
    ~~~

    For example IM v6.3.5-10 will generate "`06030510`" while the very next release IM v6.3.6.0 produces "`06030600`".

    A PHP version of the above is available from [RubbleWeb, Font List](http://www.rubblewebs.co.uk/imagemagick/server/fonts.php) examples page.

    The resulting string can be tested, using either a simple numeric or string test, to discover if the available ImageMagick version is modern enough for what your script is trying to do.
    For example...
    
    ~~~
    if [ "$IM_VERSION" -lt '06030600' ]; then
      echo >&2 "The perspective distortion operator is not available."
      echo >&2 "Sorry your installed ImageMagick is too old -- ABORTING"
      exit 10
    fi
    ~~~

    Also note how I output the exact reason for the abort to the user, and specifically the special feature(s) the version check was for.
    Otherwise you may later forget why that specific version (or higher) was needed.

    You can also modify the behaviour of IM for specific versions.

    For example say I want to get a list of available fonts.
    Before IM version v6.3.5-7 the "`-list`" setting "`type`" returned the 'known font' list.
    With later versions, you need to use "`font`" setting instead.
    So here I can do a version check to use the right setting to get the information needed.
    
    ~~~
    if [ "$IM_VERSION" -lt '06030507' ];
    then font_list="type";
    else font_list="font";
    fi
    avail_fonts=`convert -list $font_list | cut -d\  -f1 |\
                    egrep -v '^($|----|Path:|Name$)'`
    ~~~

    WARNING: a string starting with '0' in PERL could be interpreted as being an octal number!!!
    However comparing two octal numbers will still come out correct, as long as the first digit remains '0'.
    Caution, and checking of the version test is advised.

    Another alternative for testing the version is to use "`expr`" instead of the "`[`' test...
    
    ~~~
    if  expr + "$im_version" \>= "06030507" >/dev/null; then
       ...
    ~~~

    WARNING: The extra '`+`' in the above is normally not needed, at least for this test, but is needed if the variable could contain the special keyword '`match`" which would give "`expr`" problems, especially if it is being used for string or sub-string work.

-   You can also make use of the "`-list`" information output to check if some special feature has been added to the currently installed ImageMagick.
    
    ~~~
    convert -list distort | grep 'Arc' >/dev/null 2>&1
    if [ "$?" -ne 0 ];  then
      echo >&2 "Arc distortion method not available."
      echo >&2 "Sorry your installed ImageMagick is too old -- ABORTING"
      exit 10
    fi
    ~~~

    However be warned that often a new method, like "`-distort Arc`" could appear during IM development before it is properly ready for general use.
    As such a version check may still be the better idea.

    This is why in IM Examples I try to note (look for ![](../img_www/warning.gif) symbols) the IM version when a new feature have become stable enough for general use.

-   Don't use very very long single lines.
    Especially for complex 'convert' commands.
    Split them up using line-continuation methods (shown above), such as '`\`' in UNIX, '`^`' in DOS, and '`.`' string concatenation in PHP.

    However I do not mean placing each and EVERY setting and operation on a separate line.
    Do one major operation or stage per line, create new image, modify image, merge with other images, etc.
    Place all operational settings needed for a specific operator just before that operator.
    Think of each line as single processing step.

    This lets you separate the lines so as to allow for the easier reading, and understanding of individual processing steps.
    The clearer the separation of operators, the easier a complex image process is to follow.

    Using extra [parenthesis](../basics/#parenthesis), indenting the lines over various stages, or even add empty lines between large processing blocks, can make it even easier to see the major stages of large and long operation.

    I use these techniques all over IM examples, so as to make the examples easier to follow and understand, so just look around!

    Finally extra comments about what a specific command is doing can make a big difference in someone else (or even yourself 2 months later) reading and understanding your script.

    Shame you can not currently insert comments in a long command line!

-   Try not to rely on too many external programs, or only use them only if they are available (with possible alternatives).
    Other people probably will not have that program, or prefer to use something else.
    If a program use can be optional, make it optional, either under user control, or automatic use if found.
    Try not make it a forced requirement, if at all possible.

    For example you could make use of "`pngcrush`", "`optipng`", "`pngnq`" to compress PNG better than IM would normally provide (IM is designed to be general not specific).
    Also "`gifsicle`", "`intergif`", or other for LZW compression optimizers for GIF animations, have good and bad points.
    Just don't make it a definite requirement for a script to work.

    As a practical example, an older version of the "[gif2anim](../scripts/gif2anim)" did not use the ImageMagick "`identify`" to look up GIF specific meta-data, but relied on a patched version of "`giftrans`".
    This requirement was later not needed due to improvements in the ImageMagick "`identify`", so I removed that requirement to make the script more widely usable.

    ImageMagick itself has a LOT of optional requirements, such as "`ghostscript`" for postscript and PDF document reading, or the "`librsvg`" for correct handling of SVG vector images.
    IM will work quite happily when available.
    IM treats these libraries as optional, only needed them if you want to process images of those formats.

    Here is a code snippet you can use to check for script dependencies (especially usful in a very minimal cygwin environment)...
    
    ~~~
    # Check Dependencies to scripts correct working
    DEPENDENCIES="sed awk grep tr bc convert identify"  # adjust to suit

    for i in $DEPENDENCIES; do
      type $i >/dev/null 2>&1 ||
        Usage "Required program dependency \"$i\" missing"
    done
    ~~~

-   Taking the last point further.
    If you need floating point math in a shell script that is using IM, you can use IM itself to do that math, rather than relying on some other program such as '`awk`' or '`bc`', that may not be available (especially under cygwin on windows).

    For example here we get calculate the sin() of a specific angle given in degrees using '`convert`' to do the work...
    
    ~~~
    angle=-20
    sine=`convert xc: -format "%[fx:sin( $angle *pi/180)]" info:`
    echo $sine
    ~~~

    The above would output the value '`-0.34202`'.
    You can adjust the number of decimal places using the [Precision Operational Control](../basics/#precision).
    By default it is set to 6 digits.

-   Let the user decide on the input/output image formats to use.
    ImageMagick is primarily a image converter and able to use lots of different formats.
    It can output to the screen, postscript, printers, or pipe the image into another command for further processing.
    Don't limit the user to a specific format.
    For example the "[jigsaw](../scripts/jigsaw)" and "[gif\_anim\_montage](../scripts/gif_anim_montage)" scripts allow the user to specify any input or output image.
    That way users can pipeline images into, or out of, that script, so as to allow further processing using other programs and scripts.
    For example, I often use a command like...
    
    ~~~
    gif_anim_montage animation.miff show:
    ~~~

    to display the result of the script on my display screen, rather than save it to a file.
    In fact in many of my scripts if the output is missing it defaults to use "show:".

    I did not limit it to input ONLY from a GIF animation file, or limit output to just GIF, PNG, or JPEG image formats, but allowed the script to read and process any format ImageMagick can handle.

    In fact IM can read from files, pipelines, the current display, or even from the World Wide Web using a "`URL:`" or "`HTTP:`" input format.
    Don't limit these posibilities, unless it becomes a security concern (such as for web use).

-   Read input images, and output multiple-images, only ONCE!

    If the user provides a pipeline file name or a URL, you do should not try to read those images more than once, or things can go bad.
    Use a temporary file, cloned images, or "`MPC:`" save a copy of the input image, when you need to refer to that image multiple times.
    If you can handle a multiple images from the pipeline, even better.

    Again see the "[jigsaw](../scripts/jigsaw)" script, for an example of saving input images into a temporary file, when you are forced to process the input image multiple times, or in a different order than what the program arguments imply.

These things basically gives the user using your program more freedom to do what THEY want rather than what YOU think they want.
Don't limit them or yourself by making assumptions on what the script will be used for.

PS: My primary expertise is in UNIX script writing, over lots of different architectures and 'flavors' of UNIX, LINUX, and other UNIX-like systems, with more than 25 years experience behind me.
I should know what I am talking about with regard to the above.

------------------------------------------------------------------------

## Why do you use multiple "convert" commands {#multi-convert}

**Willem** on Wed, 25 Oct 2006 wrote...

> *I was wondering; sometimes I see in your examples you're invoking Convert more then once to obtain the desired result.
In general, I would expect that invoking convert more then once isn't needed; it should all be possible in 1 invocation (but the command would be more complex then).
Do you agree with this statement?*

I agree totally.

Though before IM version 6 that was actually impossible, as IM at that time was not designed to do more than one or maybe two operations per command.
However IMv6 should allow you to do all your processing in one single command.
But sadly even that is not always possible.

I use multiple commands for a number possible reasons.
Typically in the example pages, I do it so I can display the intermediate image result, so as to better demonstrate the intermediate processing stages that are involved.
Later in the same example area I may repeat the process but using a single command, with perhaps a little more complexity.

As such in principle, yes a single command can do all image processing.
You are most welcome to combine the image processing techniques all into a single command.
I do this all the time myself.

The exception to this is in cases where I need to extract information and later insert that info into the next command.
An example of this is the [Fuzzy Trim](../crop/#trim_blur) technique which requires you to extract the results of a trim on a blurred copy of the image.
This result is then used to crop the original image.
I also did this in the update to [Thumbnail Rounded Corners](../thumbnails/#rounded) example, where I used IM itself to generate a draw command using an images size for the next command.

However there are [proposals](../bugs/future/#settings) that will allow options to be generated directly from image that have been previously read into memory.

In scripts, such as the '[jigsaw](../scripts/jigsaw)' script (see Advanced Techniques, [Jigsaw Pieces](../advanced/#jigsaw)) I commonly end up using multiple commands for a different reason -- optional processing.
This allows various input options provided by the user to select additional steps in the image processing sequence.
So for optional processing I also use typically use separate commands for each stage of processing.

In such a case a temporary file is basically unavoidable.
However I typically only need at most one or two temporary images, and each step processes the image back into the same or previous temporary filename, for the next optional processing step to continue with.

For example process image replacing the source image.

~~~
convert  /tmp/image1.png ..operations..  /tmp/image1.png 
~~~

In this case a [MPC](../files/#mpc) file can speed up the reading of intermediate files to a near instant in the next processing step, as the image is simply dumped from memory onto disk, and then 'paged' back in by the next command.
This avoids the need for IM to format and parse a image file format, though it does make the temporary file larger as it is simply uncompressed memory.

Another alternative I use to avoid temporary files is to pipeline the working image(s) from one shell command (if-then-else-fi or while loop) to another.
This is known as Image Pipelines and is demonstrated in a number of examples.
And example of this is given in [MIFF Image Streaming](../files/#miff_stream), where multiple images are generated one after another into the same output pipeline, to be picked up by the next command to merge them all into the final image.

And finally you may need to change your processing style based on the results of previous processing steps.
For example in image comparisons, I often need to discover some information for use in later processing steps, or to change how the image should be processed in later stages.
Comparing a diagram or cartoon can require vary different comparision technique to real-life photo image.

If the use of multiple commands is becoming a problem, perhaps it is time to go to an API interface such as **PerlMagick**, where multiple image sequences can all be held in memory so as to avoid unnecessary disk IO.

------------------------------------------------------------------------

## Making IM Faster (in general) {#speed}

There are many ways of making IM work faster.
Here are the most important aspects to keep in mind.
As you go down the list the speed up becomes smaller, or requires more complex changes to the IM installation.

-   IM Q8 (or 8 bits per color value, 3 to 4 bytes per pixel) is a lot faster (3 to 4 times faster) than the IM Q16 default, with its higher color resolution.
    If you don't need a Q16 for your images, perhaps you should replace your IM with a Q8 version.

    Be warned however that only using 8 bit internal quality can effect the overall image processing as intermediate images loose information.
    See [HDRI](../basics/#hdri) for the opposite of this.

-   Use a single "`convert`" command if possible, so all the processing required for a single image.
    This saves on initialization, having to create temporary files, or pipelines between commands, and even the encode/decode to image file formats for those pipelines and disk I/O.

    Of course sometimes you still need to use multiple commands, to allow for optional image processing steps, such a calculations involving image size, colors or even optional processing steps.
    IMv7 scripting will help in this regard.

-   Shell scripts are inherently slow.
    It is interpreted, require multiple steps and extra file handling to disk.
    This is of course better thanks to the new IM v6 option handling, allowing you to do a large number of image processing operations in a single command.
    Even so you can rarely can do everything in a single "`convert`" command, so you often have to use multiple commands to achieve what you want.

    As such an API like perl, ruby, or a PHP magick module is faster as it removes the all the interpretation aspects of both the shell, and the IM command line API.
    It also reduces the initialization steps IM goes though in reading font and color definations.

-   An API also can hold hold all the images, or even multiple lists of images, for the lifetime of the program (as long as you have enough memory for it).
    This means you can chop and change what images are being worked on, without the need to shuffle and juggle the images, as you do on the command line.

    This is especially usful when you need to also do extra calculations basied on previous image processing steps.

-   Writing the GIF image file format is slow.
    IM has to work hard to color reduce (quantize) the colors of an image to fit into the limited colors of the file format.
    Even then you often need to do extra work to get it right, especially for GIF animations.
    PNG and JPEG are faster but at a cost of size for PNG, and loss of quality for JPEG.
    Though really GIF images are worse in terms of quality!

-   Pre-preparing and caching images such as backgrounds, overlays, frames, masks, or pre-generating color look up tables, distortion maps, templates, masks, etc.
    All these things can make large differences in your processing time.
    Think about what can be done before hand.
    A large library of pre-generated images can be a lot faster that trying to create the images as needed.

    See also the use of "[MPC:](../files/#mpc)" for intermediate and cached images.
    These are memory mapped images on disk, and essentially have zero read time, but are useless for anything else, or on other machines.
    They should only be created at the start of a major image handling process, and not stored for any length of time as any smallest of software or system upgrade will invalidate them and probably case Segmentation Faults..

-   Avoid using [FX, The Special Effects Image Operator](../transform/#fx), if you can use [Alpha Composition](../compose/#compose), or the simpler [Evaluate, Simple Math Operations](../transform/#evaluate), or other techniques instead.

    If you do need to use these, try restricting its use to the smallest image possible, or to a single channel of the image (when handling grayscale).

-   Avoid using large sized [Image Blurs](../blur/#blur) when a few smaller ones may be faster.
    Do some timing tests to see which is faster.
    The same goes for other [Morphology](../morphology/#intro) and [Convolution Operators](../morphology/#convolve) such as Gaussian and Shadow operators.

-   Use smaller sub-images, or regions, for complex processing of small areas.
    For example, find and extract the eyes of an person (using regions), before masking and recoloring, can result in a huge speed increase than processing the full large version of an image.
    The bigger the difference, the bigger the saving.

-   When reading large or even a large number of images, it is better to use a [Read Modifier](../files/#read_modifiers) to resize, or crop them immediately after reading each image, thus reducing its overall memory requirement.
    For JPEG, you can use the special '`jpeg:size`' library modifier to even avoid allocation of the memory.

    This in turn prevents '[Disk Thrashing](http://en.wikipedia.org/wiki/Thrash_(computer_science))' (which makes computers VERY slow).
    Especially when lots of large images are involved, such as when generating [Montaged Directory Indexed](../montage/#index), or other multi-image collages.

-   For [Really Massively Large Images](../files/#massive) that have to be processed from disk, it may be better to process them in smaller chunks.

-   Also for large images...
    If you have a Window 64-bit OS, use the 64-bit ImageMagick distribution.
    It uses a larger address space and can fit larger images into memory than 32-bit Windows.

-   IM by default uses multiple threads for individual image processing operations.
    That means a computer with two or more 'cores' will generally process images faster than a single CPU machine.

    For large images the OpenMP multi-thread capabilities can produce a definite speed advantage as it uses more CPU's to complete the individual image processing operations.

    Note that within IM it is only individual image processing operations that are parallelized.
    So the saving is more with large image processing, and not when processing large numbers of images (see next).

-   For small images using the IM multi-thread capabilities will not give you much of an advantage.
    In this case running multiple converts simultaneously on different images can produce more through put.

    This may also happen in situations where multiple PHP web requests could launch multiple image "convert" commands.

    In either of these situations having multi-threading enabled could be highly detrimental due to CPU contention, and it is better to disable OpenMP by setting the '`MAGICK_THREAD_LIMIT`' environment variable to '`1`'.

    See IM Forum Discussion [Threading slows down 'convert'](../forum_link.cgi?f=2&t=20012&p=79367).

    You may also like to look at `MAGICK_THROTTLE` to get ImageMagick to relinquish control of the CPU's more often at more appropriate points.

-   If you are doing lots of small operations on images (such as drawing) try not using any color names.
    Specify colors using hash colors, such as "`#00AA99`" or rgb numbers, such as "`rgb(0,160,100)`", so as to stop IM from having to load the color name tables (which is rather large!).

    Also you can try removing or cutting back the system 'font' list definition files (from "`type.xml`",) or remove those files completely and specify fonts directly by filename instead.

    Basically reduce the loading of the extra configuration information, which IM will read and initialise when required for a specific image process.
    So either don't use them or reduce the size and impact of configuration files.

-   Building ImageMagick as a shared library (the default) can greatly reduce load time.
    Libraries and coder modules are only loaded as they are needed so a dynamic version of IM will not load anything that it doesn't need to use during image processing.
    Also shared libraries tend to remain available so may not need to be reloaded for a second run.

-   If you call ImageMagick as part of an Apache module it will also reduce startup time, as parts will be loaded once and kept available for multiple use, rather than needing re-loading over and over.
    This may become more practical in the future with a permanently running 'daemon' IM process.

------------------------------------------------------------------------

## Compiling ImageMagick form Sources {#building}

### Building ImageMagick RPMs for linux from SRPMs {#rpms}

You do NOT need root to actually build the RPM's though you do need root to install RPMs.
I use this for generating and installing IM under *Fedora Linux Systems*, but it has also been [reported](../forum_link.cgi?t=12854) to work for *CentOS 5.4 (Enterprise Redhat) Linux Systems* (See more specific [IM on CentOS Notes](http://en.citizendium.org/wiki/User:Dan_Nessett/Technical/Upgrade_to_1.16#ImageMagick_6.6.2-10)).
First get the latest source RPM release from [Linux Source RPMs](ftp://ftp.imagemagick.org/pub/ImageMagick/linux/SRPMS/).

First make sure your machine has all the compilers and tools it needs.

~~~
sudo yum groupinstall "Development Tools"
sudo yum install rpmdevtool libtool-ltdl-devel
~~~

> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> The "`sudo`" is a program to run commands as root, if you are allowed, otherwise use a root shell and remove the "`sudo`" part from the above.

For Older systems like CentOS 5.5 it seems you also need these packages

~~~
sudo yum compat-libstdc++ gcc-c++ gcc-objc++ libstdc++ libstdc++-devel
~~~

Next you should also install development packages for the libraries IM also needs to build.
The simple way to get the most common ones is to first instal the Development version of IM, even though we will build a new one to replace it later.

~~~
sudo yum install ImageMagick-devel
~~~

You should also ensure that the these packages and their dependencies (such as jpeg and png development libraries) are also installed:

~~~
freetype-devel  ghostscript-devel libwmf-devel     jasper-devel  lcms-devel  bzip2-devel librsvg2 librsvg2-devel  liblpr-1     liblqr-1-devel libtool-ltdl-devel autotrace-devel
~~~

Some examples in "ImageMagick examples" also may use programs provided by these optional packages and libraries, but these are not needed for the built process.

~~~
gnuplot autotrace
~~~

Generally all these packages are optional, but if not installed, then the 'coders' and operators that make use of those libraries may not be built in automatically.
For example the "`liblqr`" module is needed to enable the [Liquid Rescale Operator](../resize/#liquid-rescale).

Now download a SRPM (source RPM) package from which to build your binary RPMs.

OR build a SRPM from an existing TAR or SVN download using...

~~~
rm config.status config.log
nice ./configure
rm *.src.rpm
make srpm
~~~

Note that once you have the SRPM you can build the actual RPM's to install.

~~~
nice rpmbuild --nodeps --rebuild   ImageMagick*.src.rpm
~~~

This will create a sub-directory "`rpmbuild`" in your home, in which it will extract the SRPM sources, and build the compiled package RPM version of the IM.
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> On older versions of Fedora and Redhat this was done in "`/usr/src`" which is generally restricted to root only.
However you can make this directory owned or writable by you so you can still do it without needing full root access for the build.

Now get the just built RPMs from build directory.
This only grabs the ImageMagick Core and PerlMagick packages, you may like to grab more than just these two, but that is up to you...

~~~
cp -p ~/rpmbuild/RPMS/*/ImageMagick-[6p]*.i[36]86.rpm .
~~~

Clean up and delete the build areas (including those that may have been created for you)...

~~~
rm -rf /var/tmp/rpm-tmp.*  ~/rpmbuild
~~~

Now you can install the RPM packages you built.
You will need to be root for this, (see note about the "`sudo`" command above)...

~~~
sudo rpm -ihv --force --nodeps  ImageMagick-*.i[36]86.rpm
~~~

The "`--nodeps`" is typically needed due to some unusual dependencies that sometimes exists on Linux systems.
To upgrade an existing installation I generally do this (as root).

~~~
sudo rpm -Uhv --force --nodeps  ImageMagick-*.i[36]86.rpm
~~~

If you want to go further I recommend you look at the [Advanced Unix Source Installation Guide](http://www.imagemagick.org/script/advanced-unix-installation.php) from the IM web site.

To later remove IM, you can just remove the package, like this (again as root)...

~~~
sudo rpm -e --nodeps  ImageMagick\*
~~~

Sometimes I just want to completely clean and wipe out all traces of IM from the system.
To do this I first use the previous command to remove the actual package from the system (a variation is shown below).
I then run the following remove commands.

NOTE I make no guarantees about this, and I would check the commands thoroughly before hand to ensure they don't remove something that it shouldn't.
If it missed anything, or it removed something it shouldn't, then please let me know so I can update it.

~~~
rpm -e --nodeps `rpm -q ImageMagick ImageMagick-perl`
rpm -e --nodeps `rpm -q ImageMagick-devel`
rm -rf /usr/lib/ImageMagick-*
rm -rf /usr/lib/lib{Magick,Wand}*
rm -rf /usr/share/ImageMagick-*
rm -rf /usr/share/doc/ImageMagick-*
rm -rf /usr/include/{ImageMagick,Magick++,magick,wand}
rm -rf /usr/lib/perl5/site_perl/*/i386-linux-thread-multi/Image/Magick*
rm -rf /usr/lib/perl5/site_perl/*/i386-linux-thread-multi/auto/Image/Magick*
rm -rf /usr/share/man/man?/*Magick*
rm -f /usr/lib/pkgconfig/ImageMagick.pc
~~~

Warning, other packages may need an IM installed, so if you remove it, I suggest that you immediately package update your computer system, so it will again install the original default (and usually quite old) version of ImageMagick that was supplied for your Linux system.
This generally involves using a 'GUI Software Update" package or the command "`yum upgrade`".

Enjoy.

### ImageMagick from Source on Ubuntu {#ubuntu}

To get all the development libraries for building ImageMagick use the following

~~~
sudo apt-get install imagemagick libmagick++-dev
~~~

A web page by "Shane" describes how to [Install ImageMagick from Source on Ubuntu 8.04](http://www.digitalsanctum.com/2009/03/18/installing-imagemagick-from-source-on-ubuntu-804/).

I have not tried this, but this installed IM into "/usr/local" directly using "make".
It does not generate a installation 'DEB' package, which is not an ideal solution.

If anyone know how to create a 'DEB' package for Ubuntu, please let me know.
Perhaps using [Intro into Debian Packaging](http://wiki.debian.org/IntroDebianPackaging)

### Compiling on MacOSX {#mac_osx}

The easiest way to install ImageMagick on MacOSX is to use MacPorts.

But the following are pointers to information on compiling for MacOSX.
I don't know if it works or is going to be helpful as I have never used it.
But see [Install ImageMagick without Fink or MacPorts](http://hints.macworld.com/article.php?story=20080818051248464) and [Install ImageMagick in Snow Leopard](http://www.icoretech.org/2009/08/install-imagemagick-in-leopard-snow-leopard/).

The above was paraphrased from a [Discsuion on IM User Forum](../forum_link.cgi?f=1&t=19253).

### Compiling HDRI versions of IM {#hdri}

For information of compiling a HDRI version of IM see [Enabling HDRI in ImageMagick](http://magick.imagemagick.org/script/high-dynamic-range.php) on the main IM website, also for Windows and Ubuntu Linux specific information see [Fourier Transforms Announcement Discussion](../forum_link.cgi?f=4&t=14251) on the user forums.

### Creating a Personal ImageMagick {#personal}

You do not always have the luxury of having superuser access to the machine on which you are doing image work on, and often those that do have that access do not want to update their ImageMagick installation.
Perhaps for package management issues, or compatibility problems.

If you have command line access (for example via SSH) all in not lost.
You can install and use a personal version of ImageMagick.

The bad news is you will still need the system administrators to install the compilers and development packages (see [above](#building)), but often these will already be present, so is not always a problem.

First decide in what sub-directory you want to install your version of IM.
A dedicated directory is the best choice as it mean you only have to delete that whole directory to remove your installation.
In my case I'll install into the "apps/im" sub-directory of my home.

~~~
export MAGICK_HOME=$HOME/apps/im
~~~

Now to install a personal version, download, unpack, and change directory into the ImageMagick Sources.
Then configure it as a 'uninstalled' version.

~~~
rm config.status config.log
nice ./configure --prefix=$MAGICK_HOME --disable-installed \
        --enable-shared --disable-static --without-modules --with-x \
        --without-perl --without-magick-plus-plus --disable-openmp \
        --with-wmf --with-gslib --with-rsvg --with-xml \
        CFLAGS=-Wextra \
        ;
nice make clean
nice make
nice make install
~~~

It is the "`--disable-installed`" with the "`--prefix`" which is important in the above definition.
The other parts disable the compilation of more optional aspects of your personal version ImageMagick.
Modify them as you like.

Now to use your own installed version, instead of the normal system version you only need to set the following environment variables.

~~~
export MAGICK_HOME=$HOME/apps/im
export PATH="$MAGICK_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$MAGICK_HOME/lib:$LD_LIBRARY_PATH"
~~~

Now if I type

~~~
convert -version
~~~

I can see the more up-to-date version of IM you just installed, by default.

Note that the variable "`$MAGICK_HOME`" is required to be set for a Imagemagick created with a "`--disable-installed`" option.

The other two environment variables ensure that we use the personal version rather that any system version that may also be installed.
  
 **WARNING:** do not mix the above variables.
Either define all of them or do not have them defined in this way.
The IM executable you use MUST also use the same libraries, coders, and configuration files that were built with those executable.
Mixing the system and your personal version will likely cause segmentation and memory faults.
  
 You can move the location of your personal IM without re-compiling, but you will need to not only modify the above environment variables, but also change (or remove) the hard coded paths to the "`display`" program used by the "`show:`" delegate in your personal installed version of the "`delegate.xml`" file.
See [Delegates](../files/#delegates) for more information on this aspect of IM.
  
 To make it easy for me to switching between the system installed and multiple personal versions of IM, I typically do not set the above variables at all.
Instead I call a script that sets those variables before calling the specific version of IM.

For example I have a personal version of IM that was compiled with [HDRI](../basics/#hdri), which I only use for specific examples in ImageMagick Examples.
I don't normally want to use this version, perfering the non-HDRI system installed version for most image work.

As such I installed a 'HDRI' version of IM in my personal area "`$HOME/apps/im_hdri`", and created a script I called "`hdri`" containing...

~~~
#!/bin/sh
#
#   hdri imagemagick_command....
#
# Run the HDRI version of imagemagick (or other personal installed IM)
#
# Where is the HDRI version of IM stored
export MAGICK_HOME=$HOME/apps/im_hdri

# Set the other two environment variables
export PATH="$MAGICK_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$MAGICK_HOME/lib:$LD_LIBRARY_PATH"

# Execute the HDRI version of the command
exec "$@"
~~~

Now if I type...

~~~
hdri convert -version
~~~

[![\[IM Text\]](hdri_version.txt.gif)](hdri_version.txt)

I see that I ran my HDRI quality version of ImageMagick, but only when I need it.
If I don't prefix "`hdri`" to the above, I then I would run the normal system version of IM.

WARNING: If your personal version of IM is not found by the script, it will silently revert to using the system version.
The above 'version' check is an important test to make sure that I am actually using my personal version, and not the system version.

You can also check exactly which convert command the script is trying to execute using the 'which'.

~~~
hdri which convert
~~~

That is the script is flexiable enough that you don't actually need to run "`convert`" but can run any command, such as ImageMagick Shell Scripts, so that that script uses the HDRI convert instead of the normal system convert.

~~~
hdri  some_im_script   image.png   image_result_hdri.png
~~~

---
created: 26 October 2006  
updated: 15 March 2011  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen\_AT\_griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.9-6
url: http://www.imagemagick.org/Usage/api/
---