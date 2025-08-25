function [start_index,current_threshold] = find_steady_start(v, threshold, min_steady_length)
    max_retries = threshold;
    retry_count = 0;
    current_threshold = threshold;
    n = length(v);
    
    if n < min_steady_length
        start_index = NaN;
        return;
    end
    
    while retry_count <= max_retries
        for start_index = (n - min_steady_length + 1) : -1 : 1
            segment = v(start_index : start_index + min_steady_length - 1);
            diffs = abs(diff(segment));
            if any(diffs >= current_threshold)
                return;
            end
        end
        % If no segment found, reduce threshold and retry
        current_threshold = current_threshold-1;
        retry_count = retry_count + 1;
    end
    
    start_index = NaN;
end