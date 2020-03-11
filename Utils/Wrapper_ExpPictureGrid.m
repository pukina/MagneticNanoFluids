function [  ] = Wrapper_ExpPictureGrid( MMML_dataset )
%Wrapper_ExpPictureGrid image grid each experiment in time
%   Detailed explanation goes here

    concentrations_to_plot = [1 2 3 4 5]; % seciba pec kartas (D107,_05, _067, 33, 25)
    % define required timestamps in s * 1000ms/s
    t = [0 0.5 1 2 3 4 5 7 10 15]*1000; % tikai para skaitu
    
    omitted = struct();
    %omitted.D107 = [12 11 9 23 4 2 3 5 24 20]; % reference by path names
    omitted.D107_05 = []; % reference by path names
    omitted.D107_067 = [];
    omitted.D107_033 = [];
    omitted.D107_025 = [];
    
    % izmeri bounding box experimenta attelosanai
    izmeri = struct();
    izmeri.D107 = [1 20 0]; % 1) izmers mm ietvaram; 2) horizontala nobide px;  3) nobide vertikali px
    izmeri.D107_05 = [1 0 0];
    izmeri.D107_067 = [1 0 0];
    izmeri.D107_033 = [1 0 0];
    izmeri.D107_025 = [1 0 0];

    concentrations = fieldnames(MMML_dataset);
    % for each concentration
    for i=1:numel(concentrations)
        if ismember(i,concentrations_to_plot)
            try
                omitted.(concentrations{i});
            catch
                omitted.(concentrations{i}) = [];
            end
            Concentration = MMML_dataset.(concentrations{i});
            eksperiments = fieldnames(Concentration);
            c =  AcquireConcentrationValue(concentrations(i));
            for j=1:length(eksperiments)
                exp = Concentration.(eksperiments{j});
                if ~ismember(str2double(exp.subpath) ,omitted.(concentrations{i}))
                    hh=initFigure();

                    % Pass experiment data, timestamps,concentration value,
                    % bounding box specification (size in mm, offset according to
                    % horizontal and vertical axis) and row count
                    name = ExpPictureGrid( exp, t, c, izmeri.(concentrations{i}), 2); % last integer is row count
                    F = getframe(hh);
                    imwrite(F.cdata, sprintf('Results/Imgrid_eachexp/%s.jpeg', name'));
                    %hgexport(hh,sprintf('Results/Imgrid_field_intime/%s.eps', name)); %ja nevajag exportu, tad izkomentçt
                    savefig(hh,sprintf('Results/Imgrid_eachexp/%s.fig', name),'compact') %ja nevajag save, tad izkomentçt
                end
            %break
            end
        end
    %break
    end

end

