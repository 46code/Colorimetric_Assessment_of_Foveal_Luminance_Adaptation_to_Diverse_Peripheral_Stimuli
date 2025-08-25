function [all_l_mean,all_l_std,all_time] = luma_plot(option,last_p)
    % define the color channel
    colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};      
    
    % it holds the mean luminance for last_p stimulis
    % for each color channel and each observer
    all_l_mean=zeros(30,14);
    all_l_std=zeros(30,14);
    all_time=zeros(30,14);
    
    for i = 1:14
        % Plot J (Lightness)
        figure;
        hold on;
    
        for obs=1:30
            filename = fullfile(pwd, 'resultsAni', sprintf('obs_%02d.csv', obs));
            data = readtable(filename);
            
            % extract color block
            colorCol = data{:,1}; 
            match = strcmp(colorCol, colors{i});
            block = data(match, :);
            numericData = table2array(block(:, 2:end));
       
            
            % Find all row indices where luminance stabilize
            luma=numericData(:,13);
            
            [time_idx,th] = find_steady_start(luma, 6, 3);
            val_time=sum(numericData(1:time_idx,end-1));
            [name,~,order] = colorName(i);
            if th<6
                disp("Observer: "+obs+" Color: "+name+"_"+order+" Th: "+th);
            end
            
            if option=='A'
                %plot all points
                luma=numericData(:,13);
                row_idx = find(~numericData(:, end));
                mistakePoints = numericData(row_idx, 13);
        
                plot(luma);
                scatter(row_idx,mistakePoints);
                
            else
                % plot last last_p data points
                n = size(numericData, 1);
                last5_idx = (n - (last_p-1)):n;
        
                luma = numericData(last5_idx, 13);
                mask = ~numericData(last5_idx, end);
                row_idx = last5_idx(mask);
                mistakePoints= numericData(row_idx, 13);
         
                plot(last5_idx, luma);
                scatter(row_idx, mistakePoints);
            end
    
            % hold the values
            all_l_mean(obs,i)=mean(luma);
            all_l_std(obs,i)=std(luma);
            all_time(obs,i)=val_time;
        end 
        
        hold off;
        xlabel('No of Stimuli')
        ylabel('Luminance')
        xlim([0 120])
        ylim([0 350])
        [name,~,order]=colorName(i);
        title("Color: " + name + " | Order: " + order);
        legend('Luminance','Mistake Point')
        grid on;

        filename = sprintf('Figures/luma_%s_%s_5.png', name, order);        
        exportgraphics(gca, filename, 'Resolution', 300);

    end

end