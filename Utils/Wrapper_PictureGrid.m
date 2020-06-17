function [ ] = Wrapper_PictureGrid( MMML_dataset )
%Wrapper_PictureGrid plot images normalized
%   Detailed explanation goes here

    concentrations_to_plot = [1]; % seciba pec kartas (D107,_05, _067, 33, 25)
    % define required timestamps in s * 1000ms/s
    t = [0 1 5 15 30]*1000;
    % omit these experiments by subpath values
    omitted = struct();
    omitted.D107 = [1 2 3 4 5 6 8 9 11 12 14 15 16 17 18 20 21 23 24 25]; % reference by path names
    omitted.D107_05 = []; % reference by path names
    omitted.D107_067 = [];
    omitted.D107_033 = [];
    omitted.D107_025 = [];
    
    izmeri = struct();
    izmeri.D107 = [1 50 0]; % 1) izmers mm ietvaram; 2) horizontala nobide px;  3) nobide vertikali px
    izmeri.D107_05 = [1 5 0];
    izmeri.D107_067 = [1 -4 0];
    izmeri.D107_033 = [1 5 0];
    izmeri.D107_025 = [1 5 0];

    concentrations = fieldnames(MMML_dataset);
    % for each concentration
    for i=1:numel(concentrations)
        if ismember(i,concentrations_to_plot)
            hh=initFigure();
            Concentration = MMML_dataset.(concentrations{i});
            try
                omitted.(concentrations{i});
            catch
                omitted.(concentrations{i}) = [];
            end
            % Pass Concentration data, experiment IDs to omit, timestamps,
            % required configuration (Oe vs Ram), concentration name field and
            % bounding box specification (size in mm, offset according to
            % horizontal and vertical axis)
            name = PictureGrid( Concentration, omitted.(concentrations{i}), t, 'Ram', concentrations(i), izmeri.(concentrations{i}));
            %hgexport(hh,sprintf('Results/Imgrid_field_intime/%s.eps', name)); %ja nevajag exportu, tad izkomentçt
            %savefig(hh,sprintf('Results/Imgrid_field_intime/%s.fig', name),'compact') %ja nevajag save, tad izkomentçt
            F = getframe(hh);
            imwrite(F.cdata, sprintf('Results/Imgrid_field_intime/%s.jpeg', name'));
            
            hh=initFigure();
            name = PictureGrid( Concentration, omitted.(concentrations{i}), t, 'Oe', concentrations(i), izmeri.(concentrations{i}));
            F = getframe(hh);
            %hgexport(hh,sprintf('Results/Imgrid_field_intime/%s.eps', name));
            %savefig(hh,sprintf('Results/Imgrid_field_intime/%s.fig', name),'compact')
            imwrite(F.cdata, sprintf('Results/Imgrid_field_intime/%s.jpeg', name'));
        end
    end

end

