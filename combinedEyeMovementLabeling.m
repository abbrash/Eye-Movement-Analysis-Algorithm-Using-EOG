function label_sig = combinedEyeMovementLabeling(H_det, sacc_horizontal, sacc_vertical, blinks, label_sig_ver_sacc, label_sig_hor_sacc, thresh_sac_dur, thresh_fix_dur)
    % Combined Eye Movement Labeling
    % This function processes and combines horizontal and vertical saccade data,
    % removes overlaps with blinks, and applies duration thresholds.
    
    % Input validation
    if ~isvector(H_det) || ~isvector(label_sig_ver_sacc) || ~isvector(label_sig_hor_sacc)
        error('H_det, label_sig_ver_sacc, and label_sig_hor_sacc must be vectors');
    end
    if ~ismatrix(sacc_horizontal) || ~ismatrix(sacc_vertical) || ~ismatrix(blinks)
        error('sacc_horizontal, sacc_vertical, and blinks must be matrices');
    end
    if ~isscalar(thresh_sac_dur) || ~isscalar(thresh_fix_dur)
        error('thresh_sac_dur and thresh_fix_dur must be scalars');
    end
    
    % Remove horizontal saccades that overlap with blinks
    sacc_h = removeOverlappingSaccades(sacc_horizontal, blinks);
    
    % Remove horizontal saccades that overlap with vertical saccades
    sacc_h = removeOverlappingSaccades(sacc_h, sacc_vertical);
    
    % Update horizontal saccade label signal
    label_sig_hor_sacc = ones(1, length(H_det));
    for i = 1:size(sacc_h, 1)
        % Ensure indices are within bounds
        start_idx = max(1, sacc_h(i,1));
        end_idx = min(length(H_det), sacc_h(i,2));
        label_sig_hor_sacc(1, start_idx:end_idx) = 2;
    end
    
    % Combine vertical and horizontal label signals
    label_sig = max(label_sig_ver_sacc, label_sig_hor_sacc);
    
    % Apply duration thresholds
    label_sig = applyDurationThresholds(label_sig, thresh_sac_dur, thresh_fix_dur);
    
    % Ensure output is a row vector
    label_sig = label_sig(:)';
end