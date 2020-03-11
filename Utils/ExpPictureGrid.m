function [ name ] = ExpPictureGrid( exp, t, c, izmers, rows )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here    
%   Plot picture grid with same scale

    % ja grib hardcoded izmçru piemçram 1x1mm tad noòemt komentâru zemâk!
    % Size is in mm
    max_box = [izmers(1) izmers(1) -1];
    
    %fprintf('Current concentration sample: %s_%s\n',exp.concentration, exp.subpath); % Print current conectration sample
    %eksperimenti = fieldnames(Koncentracija);

    %Calculate fraction of each subimage
    v = length(t)/ rows; % images per x axis
    n = length(t)/ v; % rows
    
    dxs = 0.01; % sakuma atstarpe x asij no 0 punkta
    dys = 0.05; % sakuma atstarpe y asij no 0 punkta
    dxx = 0.01; % atstarpe starp secigiem atteliem
    dyy = 0.05;
    dx=(1 - dxs - (v)*dxx)/v; % aprekina garuma proporciju vienam attelam
    dy=(1 - dys - (n)*dyy)/n;

    % each experiment
    path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
    %%% Sakt experimenta apstradi deltam un koncentracijam
    % Prieksapstrade
    %panemts no Guntara
    names_all=dir(path);
    Fstart = exp.frames(1); % Experiment start frame
    Fend = exp.frames(2); % Experiment end frame
    names = names_all(Fstart:Fend); % izvelies no kura lidz kuram kadram
    % get vector of timestamp for each frame from experiment start time
    times = zeros(1,length(names));
    for i=1:length(names)
        times(i) = str2double(names(i).name(1:7)); % parveido nosaukumus uz laikiem
    end
    times = times - times(1); % normalize laiku lai sakas ar 0
    % find indexes of required images
    ind = zeros(1, length(t)); %visu indexu (timestamps) matrica
    for i=1:length(ind)
        id = min(find(times>t(i))); %minimialâ indeksa(laika) vçrtîba, kas ir vistuvâkâ pieprasîtajam- pirmâ vçrt,kas pârsniedz.
        if isempty(id); % ja nav tada laika kadra
            id = NaN;
        end
       ind(i) = id;
    end

    zoom = exp.zoom;
    frame=[exp.bbox(1) exp.bbox(2) exp.bbox(3) exp.bbox(4)]; % [xmin xmax ymin ymax] attela kadrejumam
    x_dim = frame(2) - frame(1); % garums pikseïos
    y_dim = frame(4) - frame(3);
    bws=[exp.bws(1) exp.bws(2)]; % izveleties katra skidruma saturacijas vertibu krasai [min max]
    % katram laika periodam uzzimet kadru
    cur_box = [x_dim / zoom , y_dim / zoom]; %esoða kadra izmçri mm x un y asis

    scale_x = max_box(1) / cur_box(1); % cik reiþu lielâks ir nepiecieðamais kadrs
    scale_y = max_box(2) / cur_box(2);

    background = (bws(1) + (bws(2)-bws(1))/2)/257; % krasa backgroundam attçlu paddingam

    placex = round(scale_x * x_dim); % aprekina nepiecieðamo attelâ izmçru pikseïos
    placey = round(scale_y * y_dim);

    nobide_x = izmers(2);
    xmid = x_dim /2 + frame(1) +nobide_x; %vidus izmçri anotetajam bounding box pret pilnâ attela sakuma koordinçtu
    % get y coordinate of transition line for 1st image
    cs = exp.cs(:,1);
    nobide_y = izmers(3);
    ymid = exp.bbox(3) + length(find(cs<0.5)) + nobide_y;
    %ymid = y_dim/2 + frame(3);
    m = 1;
    for i=1:length(t)
        % ja neeksistç tâds indekss tad nezîmç
        if isnan(ind(i))
            continue
        end

        im=imread(fullfile(path,names(ind(i)).name));%read image


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
        placeholder=ones(max(placey,size(im,1)), max(placex,size(im,2))) * background;
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
        
        
        j = mod(i-1, v);
        if i / v > m
           m = m + 1; 
        end
        
        xcoordinate = dxs+dxx*(j) + dx*(j);
        ycoordinate = dys+dyy*(rows-m) + dy*(rows-m);
        h=axes('Position',[xcoordinate, ycoordinate, dx, dy]); % vieta kur attçlu novietot

        %break
        imshow(im,'Border','tight'); % uzzimç attçlu
        hc=axes('Position',[0 0 1 1],'Visible','off');
        text(xcoordinate + 0.5*(dxx+dx), ycoordinate,[sprintf('t = %g ',t(i)/1000),'s'],...
        'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
        'Rotation',0);
        drawnow
        %break
    end
    %break
    
    
    if c == 1
        rag = 4657;
    elseif c == 0.67
        rag = 3031;
    elseif c == 0.5
        rag = 2225;
    elseif c == 0.33
        rag = 1412;
    elseif c == 0.25
        rag = 718;
    end
    
    RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
    %name = strcat('Rag_',num2str(rag,'%.0f'),'_',config_name_,'_',)
    ID = str2double(exp.subpath);
    name = sprintf('Rag_%.0f_Ram_%.0f_subpath_%i_%ix%imm_v1', rag, RAM,ID, izmers(1), izmers(1));
end
