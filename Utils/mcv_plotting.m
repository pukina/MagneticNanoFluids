
filenames = {'../dati_deltaVSbezdim/D107.csv'};
concentration_keys =  {'D107'};

concentrations = fieldnames(MMML_dataset);
data = struct();
for i=1:numel(concentration_keys)
    conc_data = struct();
    filname= filenames(i);
    [folderis,mt,oe,delta_kv4,delta_kv4_0,stdev,ram,delta_kv4_bd,delta_bd,experimental] = import_deltamcv_csv(filename);
    % datu formatesana
    conc_data.folderis = folderis;
    conc_data.mt = mt;
    conc_data.oe = oe;
    conc_data.delta_kv4 = delta_kv4;
    conc_data.delta_kv4_0 = delta_kv4_0;
    conc_data.stdev = stdev;
    conc_data.ram = ram;
    conc_data.delta_kv4_bd = delta_kv4_bd;
    conc_data.delta_bd = delta_bd;
    conc_data.experimental = experimental;
    % datu masivs
    data.(concentration_keys{i}) = conc_data;
end

% plot delta^2 / 4 vs Oe^2
Cols=[230,159,0;
      86,180,233;
      0,158,115;
      240,228,66;
      0,114,178;
      213,94,0;
      204,121,167]/255; % color format
names = cell(1,length(concentration_keys) * 2);
hh=initFigure();
hold on
for i=1:numel(concentration_keys)
    raw_indexes = data.(concentration_keys{i}).experimental;
    for j = 1:2
        
        name_index = i*2-1 + j-1;
        color = Cols(name_index,:);
        if j - 1 == 0
            stage = 'estimated';
            indexes = find(raw_indexes == 0);
        else
            stage = 'experimental';
            indexes = find(raw_indexes == 1);
        end
        names{name_index} = [concentration_keys{i},' ',stage];
        x = data.(concentration_keys{i}).oe(indexes);
        y = data.(concentration_keys{i}).delta_kv4(indexes);
        scatter(x,y,[],color)
    end
end
legend(names);
    
