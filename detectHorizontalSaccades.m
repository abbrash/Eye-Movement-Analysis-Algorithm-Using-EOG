function [sacc_horizontal, label_sig_hor_sacc] = detectHorizontalSaccades(H_det, H_det_der, thresh_sacc_hor)
    % Detect horizontal saccades from eye movement data
    % Inputs:
    %   H_det: Horizontal eye position
    %   H_det_der: Derivative of horizontal eye position
    %   thresh_sacc_hor: Threshold for saccade detection
    % Outputs:
    %   sacc_horizontal: Matrix containing saccade start and end indices
    %   label_sig_hor_sacc: Label signal for horizontal saccades

    % Input validation
    if ~isvector(H_det) || ~isvector(H_det_der)
        error('H_det and H_det_der must be vectors');
    end
    if ~isscalar(thresh_sacc_hor)
        error('thresh_sacc_hor must be a scalar');
    end

    % Find peaks greater than the threshold (positive and negative)
    [peaks_sacc_max, locs_sacc_max] = findpeaks(H_det_der - thresh_sacc_hor, 'MinPeakHeight', 0);
    peaks_sacc_max = peaks_sacc_max + thresh_sacc_hor;
    [peaks_sacc_min, locs_sacc_min] = findpeaks((-H_det_der - thresh_sacc_hor), 'MinPeakHeight', 0);
    peaks_sacc_min = -(peaks_sacc_min + thresh_sacc_hor);

    % Combine and sort peaks
    peaks_sacc = [peaks_sacc_max peaks_sacc_min];
    locs_sacc = [locs_sacc_max locs_sacc_min];
    [locs_sacc, sort_idx] = sort(locs_sacc, 'ascend');
    peaks_sacc = peaks_sacc(sort_idx);

    % Adjust the peaks to get the indices in the original array
    intersection_points_x_sacc = locs_sacc;
    intersection_points_y_sacc = H_det_der(intersection_points_x_sacc);

    sacc_horizontal = [];
    for idx_locs = 1:length(locs_sacc)
        % Find saccade start (pre_idx)
        pre_idx = NaN;  % Initialize pre_idx to NaN
        for idx_adj = 3:50
            index = locs_sacc(idx_locs) - idx_adj;
            if index < 2
                break;
            end
            pre_1 = H_det_der(index);
            pre_2 = H_det_der(index - 1);
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
            if index+1 >= length(H_det_der)
                break
            end
            post_1 = H_det_der(index);
            post_2 = H_det_der(index + 1);
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
            sacc_horizontal = [sacc_horizontal; [pre_idx, post_idx]];
        end
    end

    % Create label signal for horizontal saccades
    label_sig_hor_sacc = ones(1, length(H_det));
    for i = 1:size(sacc_horizontal, 1)
        % Ensure indices are within bounds
        start_idx = max(1, sacc_horizontal(i,1));
        end_idx = min(length(H_det), sacc_horizontal(i,2));
        label_sig_hor_sacc(1,start_idx:end_idx) = 2;
    end

    % Check if any saccades were detected
    if isempty(sacc_horizontal)
        warning('No horizontal saccades detected in the input signal');
    end
end