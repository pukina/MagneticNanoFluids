function [ ] = Wrapper_RagVsTimeImgrid( MMML_dataset )
%Wrapper_RagVsTimeImgrid image grid RAG vs Time in 4x4 or other configuration
%   Detailed explanation goes here

    concentrations_to_plot = [1 2 3]; % seciba pec kartas (D107,_05, _067, 33, 25)
    % define required timestamps in s * 1000ms/s
    t = [0 1 2 5 10 30 60 90]*1000; % laiks milisekundes

    % specify which experiments to use by subpath id. Order is by Ram (935,
    % 1084, 1244, 1415). If any experiment is not to be used than change
    % its id to -1. If whole concentration is removed then change
    % experiments_to_plot variable
    used = struct();
    used.D107 = [12 9 8 23]; % reference by path names 9 or 10; 17 or 23
    used.D107_05 = [10 4 17 18]; % reference by path names
    used.D107_067 = [9 17 15 2];
    %used.D107_033 = [14 12 4 10]; %
    %used.D107_025 = [-1 -1 25 23];

    % izmeri bounding box experimenta attelosanai
    izmeri = struct();
    izmeri.D107 = [0.5 20 0]; % 1) izmers mm ietvaram; 2) horizontala nobide px;  3) nobide vertikali px
    izmeri.D107_05 = [0.5 0 0];
    izmeri.D107_067 = [0.5 0 0];
    izmeri.D107_033 = [1 0 0];
    izmeri.D107_025 = [1 0 0];

    RAM_INTERVALS = [552 1084 1415 2209;560 1095 1431 2234];

    for i=1:length(used.D107)
        hh=initFigure();
        mod_used = used;
        mod_used.D107 = used.D107(i);
        mod_used.D107_05 = used.D107_05(i);
        mod_used.D107_067 = used.D107_067(i);
        RAM = [RAM_INTERVALS(i*2 -1) RAM_INTERVALS(i*2)];
        name = GravTimePictureGrid( MMML_dataset,mod_used, concentrations_to_plot, t, izmeri, RAM);
        F = getframe(hh);
        imwrite(F.cdata, sprintf('Results/Imgrid_grav_intime/%s.jpeg', name'));
        %hgexport(hh,sprintf('Results/Imgrid_grav_intime/%s.eps', name)); %ja nevajag exportu, tad izkomentÁt
        savefig(hh,sprintf('Results/Imgrid_grav_intime/%s.fig', name),'compact') %ja nevajag save, tad izkomentÁt
    end

end

