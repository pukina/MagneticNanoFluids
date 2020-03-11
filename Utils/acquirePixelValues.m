function [rect, t] = acquirePixelValues(exp, frame, x,y)
%
%   takes as input experiment and some timestep from experiment start and
%   returns nearest frame with corresponding timestep
    path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
    names_all=dir(path); %atgriez visus failus, kas ir tajaa direktoorija; sajaa gad cik daudz attelu ir zem viena konkr exp, tik ari atgriez-- iegust sarakstu ar vinjiem
    Fstart = exp.frames(1); % Experiment start frame
    Fend = exp.frames(2); % Experiment end frame
    names=names_all(Fstart:Fend);
    im=imread(fullfile(path,names(frame).name));%read imane
    avg = mean(mean(im(y:y+3, x:x+3)));
    rect = rectangle('Position',[x y 3 3]);
    t = text(x,y,['  ',num2str(avg)]);

end