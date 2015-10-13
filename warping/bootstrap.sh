
ln -s ../images/koala.gif .
ln -sf ../images/swirl_video.* .
cp ../STORE/distorts/swirl_video.txt .

echo "Animation Scripts..."
echo "  animate_mixer...";        ./animate_mixer
echo "  animate_whirlpool...";    ./animate_whirlpool
echo "  animate_explode...";      ./animate_explode
echo "  animate_flex...";         ./animate_flex
echo "  animate_flag...";         ./animate_flag
echo "  animate_rotate...";       ./animate_rotate
#echo "  animate_affine_rot...";   ./animate_affine_rot
echo "  animate_distort_rot...";  ./animate_distort_rot
