function [] = CheckExperiments( MMML_dataset )
%CheckExperiments Prints how many experiments for each concentration done
%   Goes through each concentration and checks if experiments is done
%   Displays summary statistic for each 
    concentrations = fieldnames(MMML_dataset);
    % Calculate fraction of processed samples
    Cfin = 0;
    Ctot = length(concentrations);
    Cres = zeros(3, Ctot);
    for i=1:numel(concentrations)
        % take first sample
        Concentration = MMML_dataset.(concentrations{i});
        % Calculate fraction of processed experiments for each connentration
        % sample
        Sfin = 0.0;
        Stot = length(fieldnames(MMML_dataset.(concentrations{i})));
        %fprintf('Current concentration sample: %s\n',fields{i}); % Print current conectration sample
        Cfields = fieldnames(Concentration);
        for j=1:numel(Cfields)
            exp = Concentration.(Cfields{j});
            if exp.calculated
                Sfin = Sfin + 1;
            end
        Cres(:,i) = [100*Sfin / Stot, Sfin, Stot];

       end
    end
    fprintf('\nSamples processed:\n');
    for i=1:length(Cres(1,:))
        fprintf('Concetration sample %i is %.1f%% processed (%i of %i)\n',i,Cres(1,i),Cres(2,i),Cres(3,i)); % Print current conectration sample
    end

end

