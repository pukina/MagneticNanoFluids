function [] = Wrapper_PlotDeltaVsTime( MMML_dataset )
%Wrapper_Plot for each concentration delta vs time for each magnetic field
%   Detailed explanation goes here

    used = struct();
    used.D107 = [25]; % reference by path names 9 or 10; 17 or 23
    used.D107_05 = []; % reference by path names
    used.D107_067 = [];
    used.D107_033 = []; %
    used.D107_025 = [];

    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        hh=initFigure();
        hold on
        Concentration = MMML_dataset.(concentrations{i});
        used_exp = used.(concentrations{i});
        %plotDeltaVsTime(Concentration);
        plotDeltaVsTime(Concentration);
        title((concentrations{i}));
        hold off
    end


end

