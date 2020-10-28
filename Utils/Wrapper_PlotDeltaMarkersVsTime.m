function [  ] = Wrapper_PlotDeltaMarkersVsTime( MMML_dataset )
%Wrapper_PlotDeltaMarkersVsTime Plot for each concentration delta vs time for each magnetic field
%   Detailed explanation goes here

    used = struct();
    used.D107 = []; % reference by path names 9 or 10; 17 or 23
    used.D107_05 = [1 3 5 13 16]; % reference by path names
    used.D107_067 = [2 3 4 13 24];
    used.D107_033 = [9 12 16 17 19]; %
    used.D107_025 = [];

    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        hh=initFigure();
        hold on
        Concentration = MMML_dataset.(concentrations{i});
        used_exp = used.(concentrations{i});
        %plotDeltaVsTime(Concentration);
        plotDeltaMarkersVsTime(Concentration, used_exp);
        title((concentrations{i}));
        hold off
    end

end

