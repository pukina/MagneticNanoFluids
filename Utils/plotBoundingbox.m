function [w, h] = plotBoundingbox(exp, frame)
%
%   plot erf and delta  
    %path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
    path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
    names_all=dir(path); %atgriez visus failus, kas ir tajaa direktoorija; sajaa gad cik daudz attelu ir zem viena konkr exp, tik ari atgriez-- iegust sarakstu ar vinjiem
    Fstart = exp.frames(1); % Experiment start frame
    Fend = exp.frames(2); % Experiment end frame
    names=names_all(Fstart:Fend);
    x0 = exp.bbox(1);
    x1 = exp.bbox(2);
    y0 = exp.bbox(3);
    y1 = exp.bbox(4);
    h = y1 - y0;
    w = x1 - x0;
    im=imread(fullfile(path,names(frame).name));%read imane
    %im=im(y0:y1, x0:x1);
    imshow(im);
    rectangle('Position',[x0 y0 w h]);
end