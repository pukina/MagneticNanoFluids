function [ MMML_dataset ] = CalcConcAndDelta( MMML_dataset )
%CalcConcAndDelta Calculates Concentration and Delta for all experiments
%   Iterates over all concentration values in Dataset structure
%   and calculates concentration and delta values.
%   SAVING has been commented OUT!

    concentrations = fieldnames(MMML_dataset); %uzdod mainigo fields=koncentracijas
    for i=1:numel(concentrations) %no 1 lidz 5- mmml esosas konc.
        % take first sample
        Concentration = MMML_dataset.(concentrations{i}); %konkreta koncentracijas izvele
        fprintf('Current concentration sample: %s\n',concentrations{i}); % Print current conectration sample
        Cfields = fieldnames(Concentration); %paòem jau no konc eksperimentus pie konkr laukiem
        for j=1:numel(Cfields)
            exp = Concentration.(Cfields{j}); %konkretajaa konc panjem konkr lauku
            fprintf('Current experiment: %s\n',Cfields{j}); % Print current experiment
            if exp.calculated
                fprintf('Current experiment has been calculated already\n'); % Print current experiment
                continue
            else
                fprintf('Current experiment not calculated\n'); % Print current experiment
            end
            path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
            %%% Sakt experimenta apstradi deltam un koncentracijam
            % Prieksapstrade
            names_all=dir(path); %atgriez visus failus, kas ir tajaa direktoorija; sajaa gad cik daudz attelu ir zem viena konkr exp, tik ari atgriez-- iegust sarakstu ar vinjiem
            Fstart = exp.frames(1); % Experiment start frame
            Fend = exp.frames(2); % Experiment end frame
            names=names_all(Fstart:Fend); % no kura lidz kuram kadram, names- visi tie faili, kuri jaanalize (no kura lidz kuram att.)
            frame=[exp.bbox(1) exp.bbox(2) exp.bbox(3) exp.bbox(4)]; % [xmin xmax ymin ymax] attela kadrejumam
            bws=[exp.bws(1) exp.bws(2)]; % izveleties katra skidruma saturacijas vertibu krasai [min max]
            delta=zeros(length(names),2); %sagatavot deltu matricu
            x = zeros(length(names),2); %prieks xmin max saglabasanas, ja nevajag erf- so var nonemt
            cs=zeros(frame(4)-frame(3)+1,length(names)); % koncentraciju sagalabasana// matrica katrai pikselu rindai

            for m=1:length(names)
                im=imread(fullfile(path,names(m).name));%read imane
                %im2=imrotate(im,3.5);
                im3=im(frame(3):frame(4),frame(1):frame(2)); %crop image (useful area)
                cim=ConcField(double(im3),bws,1); %convert from Intensity to Concentration plot
                c=mean(cim,2); %find average concentration
                cs(:,m)=c; %save average concentration
                [~,x0]=min((c-(erf(-1)+1)/2).^2); %find -delta point
                [~,x1]=min((c-(erf(+1)+1)/2).^2); %find +delta point
                x(m,:)=[x0, x1];
                delta(m,2)=(x1-x0)/2; %calculate delta
                delta(m,1)=str2double(names(m).name(1:7)); %read time from the image name
                if mod(m,500)==0;
                    %break
                    display(sprintf('%d of %d',m,length(names))); %print calculation progress
                end
            end
            exp.delta = delta; % save all required values
            exp.cs = cs;
            exp.x = x;
            fprintf('Setting experiment to calculated\n');
            exp.calculated = 1; % if calculated then avoid redundant computation
            MMML_dataset.(concentrations{i}).(Cfields{j})=exp;
            %save('MMML_dataset.mat','MMML_dataset'); % save dataset so progress is not lost

        end
        %save('MMML_dataset.mat','MMML_dataset'); % save dataset so progress is not lost
    end
    %save('MMML_dataset_fittings.mat','MMML_dataset'); % save dataset so progress is not lost

end

