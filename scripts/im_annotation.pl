#!/usr/bin/perl
#
#  Generate a animated image showing the effects of the rotation options
#  on annotated (drawn) text.
#
use Image::Magick;

#$font = '-adobe-helvetica-medium-r-normal--25-180-100-100-p-130-iso8729-1';
#$font = 'Times';
$font = 'Arial';

$image = Image::Magick->new();
$x = 100;
$y = 100;
for ($angle=0; $angle < 360; $angle+=30)
{
  my ($label);

  print "angle $angle\n";
  $label=Image::Magick->new(size=>"600x600",pointsize=>24,font=>$font);
  $label->Read("xc:white");

  $label->Draw(primitive=>'line', points=>"300,100 300,500", stroke=>'#600');
  $label->Draw(primitive=>'line', points=>"100,300 500,300", stroke=>'#600');
  $label->Draw(primitive=>'rectangle',points=>"100,100 500,500",fill=>'none',
               stroke=>'#600');

  $label->Annotate(text=>"Default",    undercolor=>'yellow',
                   x=>$x*1.5, y=>$y*1.5, rotate=>$angle);
  $label->Annotate(text=>"North West", gravity=>"NorthWest",
                   x=>$x, y=>$y, rotate=>$angle);
  $label->Annotate(text=>"North",      gravity=>"North",
                   x=>0,  y=>$y, rotate=>$angle);
  $label->Annotate(text=>"North East", gravity=>"NorthEast",
                   x=>$x, y=>$y, rotate=>$angle);
  $label->Annotate(text=>"West",       gravity=>"West",
                   x=>$x, y=>0,  rotate=>$angle);
  $label->Annotate(text=>"Center",     gravity=>"Center",
                   x=>0,  y=>0,  rotate=>$angle);
  $label->Annotate(text=>"East",       gravity=>"East",
                   x=>$x, y=>0,  rotate=>$angle);
  $label->Annotate(text=>"South West", gravity=>"SouthWest",
                   x=>$x, y=>$y, rotate=>$angle);
  $label->Annotate(text=>"South",      gravity=>"South",
                   x=>0,  y=>$y, rotate=>$angle);
  $label->Annotate(text=>"South East", gravity=>"SouthEast",
                   x=>$x, y=>$y, rotate=>$angle);

  push(@$image,$label);
}
$image->Set(delay=>20);
$image->Write("im_annotate_pl.miff");
$image->Animate();

