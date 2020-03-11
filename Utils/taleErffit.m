% import experiment database of calculated values if these exist
%load('MMML_dataset_fittings.mat')
%%
concentrations = fieldnames(MMML_dataset);
for i=1:numel(concentrations)
    if ismember(i,[3, 4, 5])
        fprintf('Skipped concentration: %s\n',concentrations{i});
        continue
    end
    Sample = MMML_dataset.(concentrations{i});
    experiments = fieldnames(Sample);
    for j=1:length(experiments)
        if strcmp(concentrations{i},'D107')
            if ismember(experiments{j}, [{'f5'},{'f12'},{'f20'}])
                fprintf('Current experiment: %s - %s\n',concentrations{i},experiments{j}); % Print current experiment
                exp = Sample.(experiments{j});
                exp = normalizeData( exp );
                exp = normalizeTale( exp );
                exp = normalizeErffit( exp );
                MMML_dataset.(concentrations{i}).(experiments{j}) = exp;
            end
        elseif strcmp(concentrations{i},'D107_05')
            if ismember(experiments{j}, [{'f3'},{'f4'},{'f5'},{'f6'},{'f7'},{'f8'},{'f14'}])
            	fprintf('Current experiment: %s - %s\n',concentrations{i},experiments{j}); % Print current experiment
                exp = Sample.(experiments{j});
                exp = normalizeData( exp );
                exp = normalizeTale( exp );
                exp = normalizeErffit( exp );
                MMML_dataset.(concentrations{i}).(experiments{j}) = exp;
            end
        end
%         exp = Sample.(experiments{j});
%         exp = normalizeData( exp );
%         exp = normalizeTale( exp );
%         exp = normalizeErffit( exp );
%         MMML_dataset.(concentrations{i}).(experiments{j}) = exp;
    end
end
%%
%save('MMML_dataset_fittings','MMML_dataset');