function [all_e_mean,all_e_std] = deltaE_plot(option,last_p)
    % define the colors
    colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};
    
    % it holds the mean and std of deltaE for last_p stimulis
    % for each color channel and each observer
    all_e_mean=zeros(30,14);
    all_e_std=zeros(30,14);
    
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
                deltaE=numericData(:,8);
                row_idx = find(~numericData(:, end));
                mistakePoints = numericData(row_idx, 8);
            
                plot(deltaE);
                scatter(row_idx,mistakePoints);
                
            else
                % plot last last_p data points
                n = size(numericData, 1);
                last5_idx = (n - (last_p-1)):n;
            
                deltaE = numericData(last5_idx, 8);
                mask = ~numericData(last5_idx, end);
                row_idx = last5_idx(mask);
                mistakePoints= numericData(row_idx, 8);
            
                plot(last5_idx, deltaE);
                scatter(row_idx, mistakePoints);
            end

            % hold the values
            all_e_mean(obs,i)=mean(deltaE);
            all_e_std(obs,i)=std(deltaE);
        end

        hold off;
        xlabel('No of Stimuli')
        ylabel('\DeltaE')
        xlim([0 120])
        % ylim([0 10])
        [name,~,order]=colorName(i);
        title("JzAzBz | Color: " + name + " | Order: " + order);
        legend('\DeltaE','Mistake Point')
        grid on;

        filename = sprintf('Figures/JzAzBz_deltaE_%s_%s_5.png', name, order);        
        % exportgraphics(gca, filename, 'Resolution', 300);

    end
            

end