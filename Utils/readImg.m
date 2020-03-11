function [ im ] = readImg(path,names, ind, xmid, placex, ymid, placey, background, bws)    
    
    im=imread(fullfile(path,names(ind).name));%read image

    xstart = max(1, floor(xmid - placex/2)); % sakuma koordin�ta x asij. Vienm�r > 1. 
    xend = min(size(im,2), floor(xmid + placex/2)); % beigu koordin�ta x asij. Vienm�r maz�ka par att�la dimensiju.
    padx = max(0, placex -(xend-xstart)); % cik papildus pikse�i vajadz�gi kop�. 
    padx_right = min(size(im,2), xend+padx) - xend; % vispirms pikse�u vieno no lab�s puses cik var.
    padx_left = padx - padx_right; % atliku�os no kreis�s puses
    xend = xend+padx_right; % modific�ts beigu punkts
    xstart = max(1, xstart-padx_left); %modific�ts jaunais sakuma punkts

    %Y koordin�t�m netiek modific�ts
    ystart = max(1, floor(ymid - placey/2)); % 
    yend = min(size(im,1), floor(ymid + placey/2)); % 

    im = im(ystart:yend, xstart:xend); % no pilna attela pa�em izraudz�to kadru
    % izveido att�la template ar nepiecie�amaj�m dimensij�m un
    % background kr�s�
    placeholder=ones(max(placey,size(im,1)), max(placex,size(im,2))) * 1;
    im = mat2gray(im,[bws(1),bws(2)]); % normaliz� kadra pikse�us lai b�tu kontrasts

    %uzlieku offsetus kadra sakuma un beigu punktam
    offsetx = max(0,floor((size(placeholder,2) - size(im,2))/2));
    offsety = max(0,floor((size(placeholder,1) - size(im,1))/2));
    % ievieto kadru placeholder�
    placeholder(1+ offsety:size(im,1)+offsety, 1+ offsetx:size(im,2)+offsetx)=im;
    % mainigo parsauk�ana �rt�bai
    im = placeholder;
    %im = imresize(im,0.1); %scalo par koeficientu attelu
    im = imresize(im, [300,300]); % resize attelu uz noteiktam dimensijam, piem 150x150
end