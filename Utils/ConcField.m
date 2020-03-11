function cimg=ConcField(img,B,Phi0)
%Create a concentration field from an image by assuming, that maximum
%(peak in histogram)intensity is for 0% and minimum (peak) - for the
%concentration of magnetic fluid Phi0
%B consists of Black peak value (FF) and White peak value (H20), in the
%same units as the image (easier if double from 0 to 1)

    cimg=(log10(B(2))-log10(img))/(log10(B(2))-log10(B(1)));
    cimg(cimg>2)=2;
    cimg=Phi0*cimg;
end