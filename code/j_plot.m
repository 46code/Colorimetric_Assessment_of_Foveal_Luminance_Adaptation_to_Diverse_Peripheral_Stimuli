function [all_j_mean,all_j_std,total_obs_mistake,all_stimuli] = j_plot(option,last_p)
    % define the color channel
    colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};      
     
    % it holds total number of mistake for last_p points
    total_obs_mistake=zeros(30,14);
    
    % it holds the mean and std of J for last_p stimulis
    % for each color channel and each observer
    all_j_mean=zeros(30,14);
    all_j_std=zeros(30,14);
    all_stimuli=zeros(30,14);

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
      
            if option=='A'
                %plot all points
                J=numericData(:,9);
                row_idx = find(~numericData(:, end));
                mistakePoints = numericData(row_idx, 9);
        
                plot(J);
                scatter(row_idx,mistakePoints);
                
            else
                % plot last last_p data points
                n = size(numericData, 1);
                last5_idx = (n - (last_p-1)):n;
        
                J = numericData(last5_idx, 9);
                mask = ~numericData(last5_idx, end);
                row_idx = last5_idx(mask);
                mistakePoints= numericData(row_idx, 9);
         
                plot(last5_idx, J);
                scatter(row_idx, mistakePoints);
            end
    
            % hold the values
            all_j_mean(obs,i)=mean(J);
            all_j_std(obs,i)=std(J);
            total_obs_mistake(obs,i)=numel(mistakePoints);
            all_stimuli(obs,i)=size(numericData,1);
        
        end 
        
        hold off;
        xlabel('No of Stimuli')
        ylabel('Jz (Lightness)')
        xlim([0 120])
        % ylim([0 0.002])
        [name,~,order]=colorName(i);
        title("JzAzBz | Color: " + name + " | Order: " + order);
        legend('Jz (Lightness)', 'Mistake Point')
        grid on;

        filename = sprintf('Figures/JzAzBz_J_%s_%s_5.png', name, order);        
        exportgraphics(gca, filename, 'Resolution', 300);

    end
    

end