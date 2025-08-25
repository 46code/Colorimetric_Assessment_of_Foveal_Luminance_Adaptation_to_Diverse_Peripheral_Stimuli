function [] = jabplot(jab_male, jab_female, jab_20_30, jab_30_40, jab_40, jab_all)
    % Define plot parameters
    colors = {'k', 'r', 'g', 'b', 'y', 'm', 'c'}; % Black for 'white' values
    color_names = {'White', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta', 'Cyan'};
    plot_types = {'J', 'ab', 'deltaE', '3D'};
    
    %% Gender-based plots (2x2 grid: row=order, column=gender)
    for ptype = 1:length(plot_types)
        fig = figure('Position', [100, 100, 1000, 800], 'Name', 'Gender Analysis');
        
        % Pre-calculate global axis limits
        [xlims, ylims, zlims] = calculate_global_limits({jab_male, jab_female}, plot_types{ptype});
        
        % First Order (Row 1)
        subplot(2, 2, 1);
        h1 = plot_group_data(jab_male, 1, plot_types{ptype}, colors, color_names);
        title('Male (First Order)');
        set_common_labels(plot_types{ptype});
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        subplot(2, 2, 2);
        plot_group_data(jab_female, 1, plot_types{ptype}, colors, color_names);
        title('Female (First Order)');
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        % Second Order (Row 2)
        subplot(2, 2, 3);
        plot_group_data(jab_male, 2, plot_types{ptype}, colors, color_names);
        title('Male (Second Order)');
        set_common_labels(plot_types{ptype});
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        subplot(2, 2, 4);
        plot_group_data(jab_female, 2, plot_types{ptype}, colors, color_names);
        title('Female (Second Order)');
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        % Create unified legend at top-right
        lgd = legend(h1, color_names, 'Location', 'northeast');
        lgd.Box = 'on';
        
        sgtitle('Gender Analysis', 'FontSize', 14, 'FontWeight', 'bold');
    
    end

    %% Age-based plots (2x3 grid: row=order, column=age group)
    age_groups = {jab_20_30, jab_30_40, jab_40};
    age_names = {'20-30', '30-40', '40+'};
    
    for ptype = 1:length(plot_types)
        fig = figure('Position', [100, 100, 1500, 800], 'Name', 'Age Group Analysis');
        
        % Pre-calculate global axis limits
        [xlims, ylims, zlims] = calculate_global_limits(age_groups, plot_types{ptype});
        
        % First Order (Row 1)
        for age = 1:3
            subplot(2, 3, age);
            if age == 1
                h1 = plot_group_data(age_groups{age}, 1, plot_types{ptype}, colors, color_names);
            else
                plot_group_data(age_groups{age}, 1, plot_types{ptype}, colors, color_names);
            end
            title([age_names{age} ' (First Order)']);
            set_common_labels(plot_types{ptype});
            set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        end
        
        % Second Order (Row 2)
        for age = 1:3
            subplot(2, 3, age+3);
            plot_group_data(age_groups{age}, 2, plot_types{ptype}, colors, color_names);
            title([age_names{age} ' (Second Order)']);
            set_common_labels(plot_types{ptype});
            set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        end
        
        % Create unified legend at top-right
        lgd = legend(h1, color_names, 'Location', 'northeast');
        lgd.Box = 'on';
        
        sgtitle('Age Group Analysis', 'FontSize', 14, 'FontWeight', 'bold');
        
    end

    %% Combined data plot (2x1 grid: row=order)
    for ptype = 1:length(plot_types)
        fig = figure('Position', [100, 100, 700, 800], 'Name', 'All Observers');
        
        % Pre-calculate global axis limits
        [xlims, ylims, zlims] = calculate_global_limits({jab_all}, plot_types{ptype});
        
        % First Order (Row 1)
        subplot(2, 1, 1);
        h1 = plot_group_data(jab_all, 1, plot_types{ptype}, colors, color_names);
        title('First Order', 'FontSize', 12);
        set_common_labels(plot_types{ptype});
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        % Second Order (Row 2)
        subplot(2, 1, 2);
        plot_group_data(jab_all, 2, plot_types{ptype}, colors, color_names);
        title('Second Order', 'FontSize', 12);
        set_common_labels(plot_types{ptype});
        set_axis_limits(gca, plot_types{ptype}, xlims, ylims, zlims);
        
        % Create unified legend at top-right
        lgd = legend(h1, color_names, 'Location', 'northeast');
        lgd.Box = 'on';
        
        sgtitle('All Observers', 'FontSize', 16, 'FontWeight', 'bold');
        
    end
end

function set_common_labels(plot_type)
    switch plot_type
        case 'J'
            xlabel('No of Stimuli');
            ylabel('J*');
        case 'ab'
            xlabel('a*');
            ylabel('b*');
        case 'deltaE'
            xlabel('No of Stimuli');
            ylabel('\DeltaE*');
        case '3D'
            xlabel('a*');
            ylabel('b*');
            zlabel('J*');
    end
end

function [xlims, ylims, zlims] = calculate_global_limits(groups, plot_type)
    % Initialize with extreme values
    xmin = inf; xmax = -inf;
    ymin = inf; ymax = -inf;
    zmin = inf; zmax = -inf;
    
    for g = 1:length(groups)
        group_data = groups{g};
        for order = 1:2
            indices = order:2:14;
            for i = 1:7
                data = group_data{indices(i)};
                if isempty(data)
                    continue;
                end
                
                switch plot_type
                    case 'J'
                        yvals = data(:,1);
                        ymin = min(ymin, min(yvals));
                        ymax = max(ymax, max(yvals));
                    case 'ab'
                        xvals = data(:,2);
                        yvals = data(:,3);
                        xmin = min(xmin, min(xvals));
                        xmax = max(xmax, max(xvals));
                        ymin = min(ymin, min(yvals));
                        ymax = max(ymax, max(yvals));
                    case 'deltaE'
                        yvals = data(:,4);
                        ymin = min(ymin, min(yvals));
                        ymax = max(ymax, max(yvals));
                    case '3D'
                        xvals = data(:,2);
                        yvals = data(:,3);
                        zvals = data(:,1);
                        xmin = min(xmin, min(xvals));
                        xmax = max(xmax, max(xvals));
                        ymin = min(ymin, min(yvals));
                        ymax = max(ymax, max(yvals));
                        zmin = min(zmin, min(zvals));
                        zmax = max(zmax, max(zvals));
                end
            end
        end
    end
    
    % Add padding and handle edge cases
    padding = 0.1;
    if isinf(xmin)
        xlims = [0 1];
    else
        range = max(1, xmax - xmin);
        xlims = [xmin - padding*range, xmax + padding*range];
    end
    
    if isinf(ymin)
        ylims = [0 1];
    else
        range = max(1, ymax - ymin);
        ylims = [ymin - padding*range, ymax + padding*range];
    end
    
    if isinf(zmin)
        zlims = [0 1];
    else
        range = max(1, zmax - zmin);
        zlims = [zmin - padding*range, zmax + padding*range];
    end
end

function set_axis_limits(ax, plot_type, xlims, ylims, zlims)
    switch plot_type
        case 'J'
            ylim(ax, ylims);
        case 'ab'
            xlim(ax, xlims);
            ylim(ax, ylims);
            axis(ax, 'equal');
        case 'deltaE'
            ylim(ax, ylims);
        case '3D'
            xlim(ax, xlims);
            ylim(ax, ylims);
            zlim(ax, zlims);
    end
end