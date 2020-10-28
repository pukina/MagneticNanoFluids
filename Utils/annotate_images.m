image_dir = 'E:\Darbs\MMML\rakstam2\VIDEO\';
exp_dirs = {'tiff_067D107_f25_106Oe',...
            'tiff_D107_f3_89Oe',...
            'tiff_D107_f8_47Oe',...
            'tiff_D107_f15_50Oe',...
            'tiff_D107_f21_106Oe'};
 settings = [180 350 390 710 312 0.1 3031 1423;
             244 54 790 1034 1100 0.1 4657 2269;
             160 384 506 732 790 0.1 4657 729;
             160 384 506 732 790 0.1 4657 637;
             336 154 884 1006 630 0.1 4657 3268;]; % [x0 y0 x1 y1 zoom scale_length_mm rag ram]
        
for i=1:length(exp_dirs)
    exp = exp_dirs{i};
    exp_dir = fullfile(image_dir,exp);
    new_dir = fullfile(image_dir,strcat(exp,'_annotated'));
    status = mkdir(new_dir);
    names_all = dir(fullfile(exp_dir,'*.tif'));
    x0 = settings(i,1);
    y0 = settings(i,2);
    x1 = settings(i,3);
    y1 = settings(i,4);
    zoom = settings(i,5);
    scale_length_mm = settings(i,6);
    rag = settings(i,7);
    ram = settings(i,8);
    start_time = str2double(names_all(1).name(1:7));
    x_end = -1;
    y_last = -1;
    position = [-1,-1];
    font_size = 40;

    
    for j=1:length(names_all)
        imname = names_all(j).name;
        time=str2double(imname(1:7)) - start_time;  %read time from the image name ms
        time_text = sprintf('t=%0.1fs',time/1000);
        im_path = fullfile(exp_dir,imname);
        res_path = fullfile(new_dir,imname);
        im=imread(im_path);                         %read image
        I=im(y0:y1,x0:x1);                          %crop image (useful area)
        
        if x_end == -1
            [y_end, x_end] = size(I);
            position = [10,x_end - 120];
            xsize_bar = round(zoom * scale_length_mm);
            black_bar = zeros(10, xsize_bar);
            yb1 = y_end - 30;
            yb0 = yb1 - 9;
            xb0 = x_end - xsize_bar -10;
            xb1 = xb0 + xsize_bar - 1;
        end
        I(yb0:yb1,xb0:xb1) = black_bar;
        I = AddTextToImage(I,time_text,position,[0,0,0],'Times New Roman',font_size);
        I = AddTextToImage(I,'0.1mm',[y_end-30,x_end-75],[0,0,0],'Times New Roman',25);
        imwrite(I,res_path);
    end
end
            
            
            