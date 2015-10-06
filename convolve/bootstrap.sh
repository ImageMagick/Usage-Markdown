PATH=$PATH:../scripts
ln -s ../images/face.png .
ln -s ../images/glider_gun.gif .
ln -s ../images/test_morphology.gif ./test.gif
convert ../images/shape_man.gif -crop 10x10+56+20! area.gif
# Example requires `pnmnoraw' from NetPBM (http://netpbm.sourceforge.net/doc/pnmnoraw.html)