function [ names, ind, xmid, ymid,placex, placey, background, bws ] = readBBoxProperties(exp ,path, t, nobides,max_box)
% function declaration
    nobide_x = nobides(1);
    nobide_y = nobides(2);
    
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

    nobide_x = nobides(1);
    xmid = x_dim /2 + frame(1) +nobide_x; %vidus izmçri anotetajam bounding box pret pilnâ attela sakuma koordinçtu
    % get y coordinate of transition line for 1st image
    cs = exp.cs(:,1);
    nobide_y = nobides(2);
    ymid = exp.bbox(3) + length(find(cs<0.5)) + nobide_y;
end