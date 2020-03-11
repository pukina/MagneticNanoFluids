function [ c ] = acquiremeta( filename, concentration, path )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    c = struct;
    [Folderis,starttimems,endtimems,startkadrs,endkadrs,palielinajums,Zoom,Amperi,LauksmT,BWS_min,BWS_max,Xmin,Xmax,Ymin,Ymax] = importfile_exp(filename', 6, 40);
    for i=1:length(Folderis)
        % set some parameters for metadata
        % replace all invalid characters for struct name
        folderis = strcat('f',strrep(Folderis{i},'.','_'));
        % add main folder path, e.g. which experimental day
        c.(folderis).mainpath = path;
        % add folder path of experimental data for that sample
        c.(folderis).subpath = Folderis{i};
        % which conectration it was
        c.(folderis).concentration = concentration;
        % import from file
        stoptime = -1;
        if strcmp(endtimems{i}, 'viss')
            stoptime = -1;
        else
            stoptime = str2num(endtimems{i});
        end
        c.(folderis).times = [starttimems(i), stoptime];
        c.(folderis).frames = [startkadrs(i), endkadrs(i)];
        c.(folderis).palielinajums = palielinajums(i);
        c.(folderis).zoom = Zoom(i);
        c.(folderis).amperi = Amperi(i);
        c.(folderis).lauksmT = LauksmT(i);
        c.(folderis).bws = [BWS_min(i), BWS_max(i)];
        c.(folderis).bbox = [Xmin(i),Xmax(i),Ymin(i),Ymax(i)];
        c.(folderis).calculated = false; 
        
       
    end
end

