concentration_names = fieldnames(MMML_dataset);
for i=1:numel(concentration_names)
    tabula = [];
    koncentracija = MMML_dataset.(concentration_names{i});
    eksperimentu_nosaukumi = fieldnames(koncentracija);
    for j=1:length(eksperimentu_nosaukumi)
        exp = koncentracija.(eksperimentu_nosaukumi{j});
        % ja validity ir 1
        if exp.validity == 1
            % iegustam lauku un koeficientu;
            lauks=exp.lauksmT;
            koef = exp.coef2(1);
            slope = exp.coef(2);
            
            % pievienojam tabulas datiem
            tabula = [tabula; lauks, koef, slope];
        end
    end
    csvwrite(['Results/Tabulas/',concentration_names{i},'_mT_koef_slope.csv'],tabula);

end
