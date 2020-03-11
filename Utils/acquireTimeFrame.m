function [ frame, timestep, delta ] = acquireTimeFrame(exp, timestep)
%
%   takes as input experiment and some timestep from experiment start and
%   returns nearest frame with corresponding timestep
    frame = exp.delta(:,1) - exp.delta(1,1);
    frame = 1 + length(frame) - length(frame(frame > timestep*1000));

    bot = abs(timestep*1000 - (exp.delta((frame - 1),1) - exp.delta(1,1)));
    top = abs(timestep*1000 - (exp.delta((frame),1) - exp.delta(1,1)));

    if bot < top
        frame = frame - 1;
    end
    timestep = (exp.delta((frame),1) - exp.delta(1,1))/1000;
    delta = exp.delta(frame,2);
end