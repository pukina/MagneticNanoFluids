function [ im ] = readImg(path,names, ind, xmid, placex, ymid, placey, background, bws)    
    
    im=imread(fullfile(path,names(ind).name));%read image

    xstart = max(1, floor(xmid - placex/2)); % sakuma koordinâta x asij. Vienmçr > 1. 
    xend = min(size(im,2), floor(xmid + placex/2)); % beigu koordinâta x asij. Vienmçr mazâka par attçla dimensiju.
    padx = max(0, placex -(xend-xstart)); % cik papildus pikseïi vajadzîgi kopâ. 
    padx_right = min(size(im,2), xend+padx) - xend; % vispirms pikseïu vieno no labâs puses cik var.
    padx_left = padx - padx_right; % atlikuðos no kreisâs puses
    xend = xend+padx_right; % modificçts beigu punkts
    xstart = max(1, xstart-padx_left); %modificçts jaunais sakuma punkts

    %Y koordinâtçm netiek modificçts
    ystart = max(1, floor(ymid - placey/2)); % 
    yend = min(size(im,1), floor(ymid + placey/2)); % 

    im = im(ystart:yend, xstart:xend); % no pilna attela paòem izraudzîto kadru
    % izveido attçla template ar nepiecieðamajâm dimensijâm un
    % background krâsâ
    placeholder=ones(max(placey,size(im,1)), max(placex,size(im,2))) * 1;
    im = mat2gray(im,[bws(1),bws(2)]); % normalizç kadra pikseïus lai bûtu kontrasts

    %uzlieku offsetus kadra sakuma un beigu punktam
    offsetx = max(0,floor((size(placeholder,2) - size(im,2))/2));
    offsety = max(0,floor((size(placeholder,1) - size(im,1))/2));
    % ievieto kadru placeholderî
    placeholder(1+ offsety:size(im,1)+offsety, 1+ offsetx:size(im,2)+offsetx)=im;
    % mainigo parsaukðana çrtîbai
    im = placeholder;
    %im = imresize(im,0.1); %scalo par koeficientu attelu
    im = imresize(im, [300,300]); % resize attelu uz noteiktam dimensijam, piem 150x150
end