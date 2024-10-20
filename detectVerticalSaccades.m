function [sacc_vertical, label_sig_ver_sacc] = detectVerticalSaccades(V_det, V_det_der, V_det_der_temp, thresh_sacc_ver, blinks)
    % Detect vertical saccades from eye movement data
    % Inputs:
    %   V_det: Vertical eye position
    %   V_det_der: Derivative of vertical eye position
    %   V_det_der_temp: Temporary derivative of vertical eye position (blinks removed)
    %   thresh_sacc_ver: Threshold for vertical saccade detection
    %   blinks: Matrix containing blink start, peak, and end indices
    % Outputs:
    %   sacc_vertical: Matrix containing saccade start and end indices
    %   label_sig_ver_sacc: Label signal for vertical saccades and blinks

    % Input validation
    if ~isvector(V_det) || ~isvector(V_det_der) || ~isvector(V_det_der_temp)
        error('V_det, V_det_der, and V_det_der_temp must be vectors');
    end
    if ~isscalar(thresh_sacc_ver)
        error('thresh_sacc_ver must be a scalar');
    end
    if ~ismatrix(blinks) || size(blinks, 2) ~= 3
        error('blinks must be a matrix with 3 columns');
    end

    % Find peaks greater than the threshold (positive and negative)
    [peaks_sacc_max, locs_sacc_max] = findpeaks(V_det_der_temp - thresh_sacc_ver, 'MinPeakHeight', 0);
    peaks_sacc_max = peaks_sacc_max + thresh_sacc_ver;
    [peaks_sacc_min, locs_sacc_min] = findpeaks((-V_det_der_temp - thresh_sacc_ver), 'MinPeakHeight', 0);
    peaks_sacc_min = -(peaks_sacc_min + thresh_sacc_ver);

    % Combine and sort peaks
    peaks_sacc = [peaks_sacc_max peaks_sacc_min];
    locs_sacc = [locs_sacc_max locs_sacc_min];
    [locs_sacc, sort_idx] = sort(locs_sacc, 'ascend');
    peaks_sacc = peaks_sacc(sort_idx);

    % Adjust the peaks to get the indices in the original array
    intersection_points_x_sacc = locs_sacc;
    intersection_points_y_sacc = V_det_der_temp(intersection_points_x_sacc);

    sacc_vertical = [];
    for idx_locs = 1:length(locs_sacc)
        % Find saccade start (pre_idx)
        pre_idx = NaN;  % Initialize pre_idx to NaN
        for idx_adj = 3:50
            index = locs_sacc(idx_locs) - idx_adj;
            if index < 2
                break;
            end
            pre_1 = V_det_der(index);
            pre_2 = V_det_der(index - 1);
            if (pre_1 == 0)
                pre_idx = index;
                break
            elseif (pre_2 == 0)
                pre_idx = index - 1;
                break
            elseif (pre_1 * pre_2 < 0)
                if (abs(pre_1) < abs(pre_2))
                    pre_idx = index;
                else
                    pre_idx = index - 1;
                end
                break
            end
        end

        % Find saccade end (post_idx)
        post_idx = NaN;  % Initialize post_idx to NaN
        for idx_adj = 3:50
            index = locs_sacc(idx_locs) + idx_adj;
            if index+1 >= length(V_det_der)
                break
            end
            post_1 = V_det_der(index);
            post_2 = V_det_der(index + 1);
            if (post_1 == 0)
                post_idx = index;
                break
            elseif (post_2 == 0)
                post_idx = index + 1;
                break
            elseif (post_1 * post_2 < 0)
                if (abs(post_1) < abs(post_2))
                    post_idx = index;
                else
                    post_idx = index + 1;
                end
                break
            end
        end

        % Store saccade information only if both pre_idx and post_idx are valid
        if ~isnan(pre_idx) && ~isnan(post_idx)
            sacc_vertical = [sacc_vertical; [pre_idx, post_idx]];
        end
    end

    % Replace saccade indices identified as blinks with 0
    for i = 1:size(sacc_vertical, 1)
        for j = 1:size(blinks, 1)
            if (sacc_vertical(i,1) >= blinks(j,1) && sacc_vertical(i,1) <= blinks(j,3)) || ...
               (sacc_vertical(i,2) >= blinks(j,1) && sacc_vertical(i,2) <= blinks(j,3))
                sacc_vertical(i,:) = [0, 0];
                break;
            end
        end
    end

    % Remove rows with [0, 0] from sacc_vertical
    sacc_vertical = sacc_vertical(any(sacc_vertical, 2), :);

    % Create label signal for vertical saccades
    label_sig_ver_sacc = ones(1, length(V_det));
    for i = 1:size(sacc_vertical, 1)
        % Ensure indices are within bounds
        start_idx = max(1, sacc_vertical(i,1));
        end_idx = min(length(V_det), sacc_vertical(i,2));
        label_sig_ver_sacc(1,start_idx:end_idx) = 2;
    end

    % Label blinks in the signal
    for i = 1:size(blinks, 1)
        % Ensure indices are within bounds
        start_idx = max(1, blinks(i,1));
        end_idx = min(length(V_det), blinks(i,3));
        label_sig_ver_sacc(1,start_idx:end_idx) = 3;
    end

    % Check if any saccades were detected
    if isempty(sacc_vertical)
        warning('No vertical saccades detected in the input signal');
    end
end