function [ hh ] = initFigure()
%plotDeltaVsTime plots delta vs time given specific concentration handle
%   Detailed explanation goes here
    hh=figure;
    set(hh,'PaperPositionMode','auto');
    set(hh,'Units','centimeters');
    set(hh,'Position',[1 2 21 10]);
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(gcf,'color','w');

    fsize=10;
    msize=7;
    fname='Times';
end
