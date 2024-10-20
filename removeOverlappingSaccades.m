function sacc_filtered = removeOverlappingSaccades(sacc, overlap_periods)
    % Remove saccades that overlap with specified periods
    % Inputs:
    %   sacc: Matrix of saccade start and end times (n x 2)
    %   overlap_periods: Matrix of periods to check for overlap (m x 2 or m x 3)
    % Output:
    %   sacc_filtered: Matrix of non-overlapping saccades

    % Input validation
    if ~ismatrix(sacc) || size(sacc, 2) ~= 2
        error('sacc must be a matrix with 2 columns');
    end
    if ~ismatrix(overlap_periods) || ~ismember(size(overlap_periods, 2), [2, 3])
        error('overlap_periods must be a matrix with 2 or 3 columns');
    end

    % Initialize mask for non-overlapping saccades
    overlap_mask = false(size(sacc, 1), 1);

    % Check each saccade for overlap
    for i = 1:size(sacc, 1)
        saccade_start = sacc(i, 1);
        saccade_end = sacc(i, 2);

        % Check against each overlap period
        for j = 1:size(overlap_periods, 1)
            period_start = overlap_periods(j, 1);
            period_end = overlap_periods(j, end); % Use 'end' to accommodate both 2 and 3 column matrices

            % Check for overlap
            if (saccade_start <= period_end && saccade_end >= period_start)
                overlap_mask(i) = true;
                break; % No need to check further periods for this saccade
            end
        end
    end

    % Filter out overlapping saccades
    sacc_filtered = sacc(~overlap_mask, :);

    % Check if any saccades were removed
    num_removed = sum(overlap_mask);
    if num_removed > 0
        warning('%d saccades were removed due to overlap', num_removed);
    end
end