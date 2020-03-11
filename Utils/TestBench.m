%%
timesteps = [10 40]; % time is needed from experiment start time (absolute time of frame - exp. start)
exp = MMML_dataset.D107.f1; % defaults = D107.f1 / D107_033.f16 /
hh=initFigure();
plotErf(exp,timesteps);