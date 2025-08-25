function cluster_line_plot(mean_data, std_data, label)
    
    figure;
    hold on;
    
    for block = 1:14
        [~, code, ~] = colorName(block);
        
        mean_vals = mean_data(:, block); 
        std_vals = std_data(:, block); 
        
        x = block * ones(30, 1);
        y = mean_vals;
        
        % Plot horizontal error bars
        for i = 1:length(y)
            line([x(i) - std_vals(i), x(i) + std_vals(i)], [y(i), y(i)], ...
                'Color', code, 'LineWidth', 1.5);
        end
        
        % Plot mean points
        plot(x, y, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', code, ...
            'MarkerSize', 6);
    end
    
    hold off;
    
    % Formatting with order in x-axis
    xlim([0.5, 14.5]);
    xticks(1:14);
    
    % Create x-tick labels with color and order
    tick_labels = cell(1,14);
    for i = 1:14
        [name, ~, order] = colorName(i);
        tick_labels{i} = [name(1) order(1)];  % First letter + order number
    end
    set(gca, 'XTickLabel', tick_labels, 'FontSize', 10);
    
    xlabel('Color Channel (Name + Order)');
    ylabel(label);
    title(['Mean ' label ' for 30 Observers']);
    grid on;
    
    % Save figure
    filename = sprintf('Figures/Cluster_Line_luma_%s.png', label);        
    exportgraphics(gcf, filename, 'Resolution', 300);

end