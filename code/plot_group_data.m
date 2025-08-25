function h_lines = plot_group_data(group_data, order, plot_type, colors, color_names)
    % Determine indices for current order (1st or 2nd)
    indices = order:2:14;
    
    hold on;
    grid on;
    box on;
    
    % Preallocate handles array
    h_lines = gobjects(1, 7);
    
    for i = 1:7
        idx = indices(i);
        data = group_data{idx};
        if isempty(data)
            continue;
        end
        color = colors{i};
        
        switch plot_type
            case 'J'
                % Plot with solid line
                h = plot(data(:,1), 'Color', color, 'LineWidth', 1.5);
                h_lines(i) = h;
                
            case 'ab'
                % Solid dots with face color
                h = scatter(data(:,2), data(:,3), 70, ...
                    'Marker', 'o', ...
                    'MarkerEdgeColor', color, ...
                    'MarkerFaceColor', color);
                h_lines(i) = h;
                
            case 'deltaE'
                % Solid line
                h = plot(data(:,4), 'Color', color, 'LineWidth', 1.5);
                h_lines(i) = h;
                
            case '3D'
                % Solid dots with face color
                h = scatter3(data(:,2), data(:,3), data(:,1), 70, ...
                    'Marker', 'o', ...
                    'MarkerEdgeColor', color, ...
                    'MarkerFaceColor', color);
                h_lines(i) = h;
                
                grid on;
                view(3);
                rotate3d on;
        end
    end
    
    hold off;
end