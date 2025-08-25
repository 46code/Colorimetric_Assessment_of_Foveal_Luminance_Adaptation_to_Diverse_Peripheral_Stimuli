function [counts, ranges, groups] = findCloseGroups(vec, thresh)
    % Sort the vector to ensure consecutive closeness can be checked
    vec = sort(vec(:));  % Ensure it's a column vector for consistency
    
    % Compute differences between consecutive elements
    d = diff(vec);
    
    % Find indices where groups break (difference > threshold), add start/end
    breakIdx = [0; find(d > thresh); length(vec)];
    
    % Initialize outputs
    numGroups = length(breakIdx) - 1;
    counts = zeros(numGroups, 1);
    ranges = zeros(numGroups, 1);
    groups = cell(numGroups, 1);
    
    % Loop through each group
    for i = 1:numGroups
        idx = (breakIdx(i) + 1) : breakIdx(i + 1);
        groupVals = vec(idx);
        groups{i} = groupVals;
        counts(i) = length(groupVals);
        ranges(i) = max(groupVals) - min(groupVals);  % Range as max - min
    end
    
    % Display results (optional; comment out if not needed)
    disp('Group Counts:');
    disp(counts');
    disp('Group Ranges:');
    disp(ranges');
end