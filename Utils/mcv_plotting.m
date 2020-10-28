
filenames = {'\..\dati_deltaVSbezdim\D107.csv','\..\dati_deltaVSbezdim\066_D107.csv','\..\dati_deltaVSbezdim\05_D107.csv','\..\dati_deltaVSbezdim\033_D107.csv'};
concentration_keys =  {'MF_1','MF_2','MF_3','MF_4'}; %{'D107','D107_0_67','D107_0_5','D107_0_33'}

plot_errorbars = true;

%concentrations = fieldnames(MMML_dataset);
data = struct();
for i=1:numel(concentration_keys)
    conc_data = struct();
    filename = filenames(i);
    filename = fullfile(pwd,filename);
    [folderis,mt,oe,oe_kv,delta_kv4,sakuma_pacelums,stdev,ram,delta,delta_mc_bd,slope,slope_stdev,delta_res,delta_res_bd,experimental] = import_deltamcv_csv(filename{1});
    % datu formatesana
    conc_data.folderis = folderis;
    conc_data.mt = mt;
    conc_data.oe = oe;
    conc_data.oe_kv = oe_kv;
    conc_data.delta_kv4 = delta_kv4;
    conc_data.sakuma_pacelums = sakuma_pacelums;
    conc_data.stdev = stdev;
    conc_data.ram = ram;
    conc_data.delta = delta;
    conc_data.delta_mc_bd = delta_mc_bd;
    conc_data.slope = slope;
    conc_data.slope_stdev = slope_stdev;
    conc_data.delta_res = delta_res;
    conc_data.delta_res_bd = delta_res_bd;
    conc_data.experimental = experimental;
    %aprekinatas jaunas vertibas
    conc_data.delta_res_kv4 = (delta_res.^2)/4;
    conc_data.delta_res_bd_kv4 = (delta_res_bd.^2)/4;
    conc_data.logdelta_kv4 = log(delta_kv4);
    conc_data.logoe_kv = log(oe_kv);
    conc_data.ram_vecaisdiffkoef = ram*125/60;
    conc_data.delta_mc_bd_kv4 = (delta_mc_bd.^2)/4;
    conc_data.logdelta_mc_bd_kv4 = log((delta_mc_bd.^2)/4);
    conc_data.logram_v = log(ram*125/60);
    % datu masivs
    data.(concentration_keys{i}) = conc_data;
end

% plot delta vs Oe^2
Cols=[182,69,80;
      182,69,80;
      104,108,183;
      104,108,183;
      75,174,128;
      75,174,128;
      255,153,204;
      255,153,204]/255; % color format
symbs1={'o';'s';'d';'^';'p';'v'};
symbs={'y-';'b-';'g-';'c-';'m-';'r-'};
%%
%plot_mcv(data,concentration_keys,'delta','oe','delta_res', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'delta','oe_kv','delta_res', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'delta_kv4','oe','delta_res_kv4', Cols, symbs1,plot_errorbars, 1/2,false)%false, ja izðíirtspeja; true, ja STDEV
%plot_mcv(data,concentration_keys,'delta_mc_bd','ram','delta_res_bd', Cols, symbs1,plot_errorbars,1/2,false)
plot_mcv(data,concentration_keys,'slope','oe','slope_stdev', Cols, symbs1,plot_errorbars,1,true)
%plot_mcv(data,concentration_keys,'logdelta_kv4','logoe_kv','', Cols, symbs1,false,1,false)
%plot_mcv(data,concentration_keys,'delta_mc_bd','ram_vecaisdiffkoef','delta_res_bd', Cols, symbs1,plot_errorbars,1/2,false)
%plot_mcv(data,concentration_keys,'delta_kv4','oe_kv','delta_res_kv4', Cols, symbs1,plot_errorbars, 1/2,false)
%plot_mcv(data,concentration_keys,'logdelta_mc_bd_kv4','logram_v','', Cols, symbs1,false,1,false)
%plot_mcv(data,concentration_keys,'delta_mc_bd_kv4','ram_vecaisdiffkoef','delta_res_bd_kv4', Cols, symbs1,plot_errorbars,1/2,false)
