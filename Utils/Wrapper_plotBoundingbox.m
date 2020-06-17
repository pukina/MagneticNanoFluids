function [ ] = Wrapper_plotBoundingbox( exp, frame )
%Wrapper_plotBoundingbox Show bounding box on image
%   experiment is set manually, and frame is acquired from debugger. Frame is
%   image frame as sequence numinitFigure();
    initFigure();
    [w,h] = plotBoundingbox(exp, frame);
    fprintf(sprintf('Horizontal length = %gmm\nVertical length = %gmm\n', w/exp.zoom, h/exp.zoom));

end

