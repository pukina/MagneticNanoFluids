concentrations = fieldnames(MMML_dataset);
for i=1:numel(concentrations)
    concentration = MMML_dataset.(concentrations{i});
    concentration_fields = fieldnames(concentration);
    num_experiments = length(concentration_fields);
    results_table = zeros(num_experiments,4);
    c = char(concentrations(i));
    if length(c)>4
        c =  str2num(c(6:end));
        decimals = length(num2str(c));
        c = c/(10^decimals);
        fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
    else
        c = 1;
        fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
    end
    for j=1:length(concentration_fields)
        exp = concentration.(concentration_fields{j});
        old_coef = (exp.coef + exp.coef2) / 2;
        new_coef = (exp.bezdim_coef1 + exp.bezdim_coef2) / 2;
        H = exp.lauksmT;
        numenator = (c*exp.lauksmT*10*0.016*0.013).^2;
        denumenator = 12*0.01*(5.7*10^(-7));
        RAM = log( numenator / denumenator );
        results_table(j,:) = [old_coef(2), new_coef(2), H, RAM];
    end
    filename = sprintf('15_12_2019/coef_old_new_vs_H_RAM_%s.csv',char(concentrations(i)));
    dlmwrite(filename, results_table);

end