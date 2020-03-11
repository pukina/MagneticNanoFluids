%%
hh=figure;
set(hh,'Units','centimeters');
set(hh,'PaperPositionMode','auto');
set(hh,'Position',[10 5 18 8]);

flows=[1,3,5,7];
curr=[1,1.3,1.5,1.7,2.0];
dx=0.19;
dy=0.23;
dxx=0.18;
dyy=0.22;

for i=1:length(flows)
    for j=1:length(curr)
        %im=imread(sprintf('1_2\\%d_%3.1f.tif',flows(i),curr(j)));
        %im1=(double(im)-85)/(210-85);%1_2
        %im1=(double(im)-99)/(210-99);%1_1
        %im2=imresize(im1,0.5);
        %im1=im;
        %max(im1(:))
        h=axes('Position',[0.04+dx*(j-1) 0.99-dy*i dxx dyy]);
        imshow(im,'Border','tight');
        
    end

end

hc=axes('Position',[0 0 1 1],'Visible','off');
for j=1:length(curr)
    text(0.04+dx*(j-1)+dxx/2,0.01,sprintf('%5.0f Oe',50*curr(j)),...
    'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',10);
end

for i=1:length(flows)
    text(0.01,0.99-dy*(i-1)-dyy/2,[sprintf('%d ',flows(i)),'$\mu$l/min'],...
    'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
    'Rotation',90,'interpreter','latex');
end

%hgexport(hh,'1_2-all.eps');