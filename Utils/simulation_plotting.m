
filenames = {'\..\grafiki_deltaVsh_bezdim\D107_ram.csv','\..\grafiki_deltaVsh_bezdim\066_D107_ram.csv','\..\grafiki_deltaVsh_bezdim\05_D107_ram.csv','\..\grafiki_deltaVsh_bezdim\033_D107_ram.csv'};
concentration_keys =  {'MF_1','MF_2','MF_3','MF_4'}; %{'D107','D107_0_67','D107_0_5','D107_0_33'}
skip_list = [];
addpath('../');

deleted_keys = 0;
for i=1:numel(concentration_keys)
    j = i -deleted_keys;
    if ismember(i,skip_list)
       filenames(j) = [];
       concentration_keys(j) = [];
       deleted_keys = deleted_keys + 1;
    end
    
end

plot_errorbars = true;

%concentrations = fieldnames(MMML_dataset);
data = struct();
for i=1:numel(concentration_keys)
    conc_data = struct();
    filename = filenames(i);
    filename = fullfile(pwd,filename);
    [Ram_exp1,delta_MC_BD_exp1,deltaresolutionBD1,to_exclude,type_id,plot_meaning] = import_simulationdata(filename{1});
    % datu formatesana
    conc_data.Ram_exp1 = Ram_exp1;
    conc_data.delta_MC_BD_exp1 = delta_MC_BD_exp1;
    conc_data.deltaresolutionBD1 = deltaresolutionBD1;
    conc_data.to_exclude = to_exclude;
    conc_data.type_id = type_id;
    conc_data.plot_meaning = plot_meaning;

    %aprekinatas jaunas vertibas

    % datu masivs
    data.(concentration_keys{i}) = conc_data;
end

% plot delta vs Oe^2
Cols=[126,47,142;
      222,125,0;
      0,191,191;
      0,127,0;
      0,127,0]/255; % color format
symbs1={'o';'s';'d';'^';'p';'v'};
symbs={'y-';'b-';'g-';'c-';'m-';'r-'};
%%
plot_simulation(data,concentration_keys,'delta_MC_BD_exp1','Ram_exp1','deltaresolutionBD1', Cols, symbs1,plot_errorbars,1/2)
%plot_mcv(data,concentration_keys,'delta','oe_kv','delta_res', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'delta_kv4','oe','delta_res_kv4', Cols, symbs1,plot_errorbars, 1/2,false)%false, ja izðíirtspeja; true, ja STDEV
%plot_mcv(data,concentration_keys,'delta_mc_bd','ram','delta_res_bd', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'slope','oe','slope_stdev', Cols, symbs1,plot_errorbars,1,true)
%plot_mcv(data,concentration_keys,'logdelta_kv4','logoe_kv','', Cols, symbs1,false,1,false)
%plot_mcv(data,concentration_keys,'delta_mc_bd','ram_vecaisdiffkoef','delta_res_bd', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'delta_kv4','oe_kv','delta_res_kv4', Cols, symbs1,plot_errorbars, 1/2,false)
%plot_mcv(data,concentration_keys,'logdelta_mc_bd_kv4','logram_v','', Cols, symbs1,false,1,false)
%plot_mcv(data,concentration_keys,'delta_mc_bd_kv4','ram_vecaisdiffkoef','delta_res_bd_kv4', Cols, symbs1,plot_errorbars,1/2,false)
