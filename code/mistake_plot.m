function mistake_plot(color_indices, total_obs_mistake)
    % Create figure with proper size
    fig = figure('Position', [100, 100, 1200, 700]); % Width x Height = 1200x700
   
    pos = 1;
    for i = color_indices
        [name, code, order] = colorName(i);
        subplot(2, 4, pos);
        
        % Create bar plot with specified color
        bar_handle = bar(total_obs_mistake(:, i));
        bar_handle.FaceColor = code;
        
        xlabel('Observer')
        ylabel('Mistake')
        xlim([0.5 30.5]) 
        ylim([0 max(10, max(total_obs_mistake(:)) + 1)])
        title(['Color: ' name ' | Order: ' order], 'FontSize', 10);
        
        % Add grid for better readability
        grid on;
        
        pos = pos + 1;
    end

    % Add overall title to the figure
    sgtitle(['Mistake in Last 5 Stimuli per Observer: ' order ' Order'], 'FontSize', 12);
    
    % Adjust subplot spacing (replace problematic LooseInset)
    padding = 0.05;  % Adjust this value as needed
    set(fig, 'Units', 'normalized');
    ha = findobj(fig, 'Type', 'axes');
    
    % Save the figure
    filename = sprintf('Figures/Total_Mistake_%s_5.png', order);        
    exportgraphics(fig, filename, 'Resolution', 300);
end