PATH=$PATH:../scripts

ln -s ../images/bg.gif .
ln -s ../images/tile_* .
ln -s ../images/text_data.txt .
ln -s ../images/pango_test.txt .
# These images always change, due to date contents
# I do not want these to be recovered from backups (yet)
rm -f _ps_*