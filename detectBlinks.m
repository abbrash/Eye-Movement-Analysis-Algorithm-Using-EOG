function [blinks, label_signal_blinks, V_det_der_temp, H_det_der] = detectBlinks(V_det, V_det_der, H_det_der, thresh_blinks)
    % Detect blinks in eye movement data
    % Inputs:
    %   V_det: Vertical eye position
    %   V_det_der: Derivative of vertical eye position
    %   H_det_der: Derivative of horizontal eye position
    %   thresh_blinks: Threshold for blink detection
    % Outputs:
    %   blinks: Matrix containing blink start, peak, and end indices
    %   label_signal_blinks: Label signal for blinks
    %   V_det_der_temp: Modified vertical derivative signal
    %   H_det_der: Modified horizontal derivative signal

    % Input validation
    if ~isvector(V_det) || ~isvector(V_det_der) || ~isvector(H_det_der)
        error('V_det, V_det_der, and H_det_der must be vectors');
    end
    if ~isscalar(thresh_blinks)
        error('thresh_blinks must be a scalar');
    end

    % Find peaks greater than the threshold
    [peaks_blinks, locs_blinks] = findpeaks(V_det - thresh_blinks, 'MinPeakHeight', 0);
    peaks_blinks = peaks_blinks + thresh_blinks;

    % Adjust the peaks to get the indices in the original array
    intersection_points_x_blinks = locs_blinks;
    intersection_points_y_blinks = V_det(intersection_points_x_blinks);

    blinks = [];
    for idx_locs = 1:length(locs_blinks)
        % Find blink start (pre_idx)
        for idx_adj = 5:100
            index = locs_blinks(idx_locs) - idx_adj;
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

        % Find blink end (post_idx)
        for idx_adj = 5:100
            index = locs_blinks(idx_locs) + idx_adj;
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

        % Store blink information
        blinks = [blinks; [pre_idx, locs_blinks(idx_locs), post_idx]];
    end

    % Create label signal for blinks
    label_signal_blinks = ones(1, length(V_det));
    V_det_der_temp = V_det_der;
    for i = 1:size(blinks, 1)
        % Ensure indices are within bounds
        start_idx = max(1, blinks(i,1));
        end_idx = min(length(V_det), blinks(i,3));
        label_signal_blinks(1,start_idx:end_idx) = 3;
    end

    % Zero out blink regions in derivative signals
    for i = 1:size(blinks, 1)
        % Ensure indices are within bounds
        start_idx = max(1, blinks(i,1));
        end_idx = min(length(V_det), blinks(i,3));
        V_det_der_temp(1,start_idx:end_idx) = 0;
        H_det_der(1,start_idx:end_idx) = 0;
    end
end