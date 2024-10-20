function [blink_stats, sacc_ver_stats, sacc_hor_stats, fix_stats, sacc_concat_stats] = analyzeEyeMovements(V_det, H_det, blinks, sacc_vertical, sacc_horizontal, label_sig, sample_rate)
    % Analyze eye movements and calculate comprehensive statistics
    %
    % Inputs:
    %   V_det: Vertical eye movement signal (detrended)
    %   H_det: Horizontal eye movement signal (detrended)
    %   blinks: Matrix of blink events [start_index, peak_index, end_index]
    %   sacc_vertical: Matrix of vertical saccade events [start_index, end_index]
    %   sacc_horizontal: Matrix of horizontal saccade events [start_index, end_index]
    %   label_sig: Combined label signal
    %   sample_rate: Sampling rate of the signals in Hz
    %
    % Outputs:
    %   blink_stats: Structure containing blink statistics
    %   sacc_ver_stats: Structure containing vertical saccade statistics
    %   sacc_hor_stats: Structure containing horizontal saccade statistics
    %   fix_stats: Structure containing fixation statistics
    %   sacc_concat_stats: Structure containing combined saccade statistics

    % Input validation
    validateInputs(V_det, H_det, blinks, sacc_vertical, sacc_horizontal, label_sig, sample_rate);

    % Derive fix_concat and sacc_concat from label_sig
    fix_concat = getLabeledEvents(label_sig, 1);  % 1 for fixations
    sacc_concat = getLabeledEvents(label_sig, 2);  % 2 for saccades

    % Blink analysis
    blinks_dur = (blinks(:,3) - blinks(:,1)) / sample_rate * 1000; % convert to ms
    blinks_amp = V_det(blinks(:,2)) - V_det(blinks(:,1));
    
    blink_stats = struct('number', size(blinks, 1), ...
                         'duration_mean', mean(blinks_dur), ...
                         'duration_std', std(blinks_dur), ...
                         'duration_total', sum(blinks_dur), ...
                         'amplitude_mean', mean(blinks_amp), ...
                         'amplitude_std', std(blinks_amp));

% Vertical saccade analysis
    sacc_ver_dur = max(sacc_vertical(:,2) - sacc_vertical(:,1), 0) / sample_rate * 1000; % convert to ms, ensure non-negative
    sacc_ver_amp = abs(V_det(sacc_vertical(:,2)) - V_det(sacc_vertical(:,1)));
    
    sacc_ver_stats = struct('number', size(sacc_vertical, 1), ...
                            'duration_mean', mean(sacc_ver_dur), ...
                            'duration_std', std(sacc_ver_dur), ...
                            'duration_total', sum(sacc_ver_dur), ...
                            'amplitude_mean', mean(sacc_ver_amp), ...
                            'amplitude_std', std(sacc_ver_amp));

    % Horizontal saccade analysis
    sacc_hor_dur = max(sacc_horizontal(:,2) - sacc_horizontal(:,1), 0) / sample_rate * 1000; % convert to ms, ensure non-negative
    sacc_hor_amp = abs(H_det(sacc_horizontal(:,2)) - H_det(sacc_horizontal(:,1)));
    
    sacc_hor_stats = struct('number', size(sacc_horizontal, 1), ...
                            'duration_mean', mean(sacc_hor_dur), ...
                            'duration_std', std(sacc_hor_dur), ...
                            'duration_total', sum(sacc_hor_dur), ...
                            'amplitude_mean', mean(sacc_hor_amp), ...
                            'amplitude_std', std(sacc_hor_amp));


    % Fixation analysis
    fix_dur = (fix_concat(:,2) - fix_concat(:,1)) / sample_rate * 1000; % convert to ms
    
    fix_stats = struct('number', size(fix_concat, 1), ...
                       'duration_mean', mean(fix_dur), ...
                       'duration_std', std(fix_dur), ...
                       'duration_total', sum(fix_dur));

    % Combined saccade analysis
    sacc_concat_dur = max(sacc_concat(:,2) - sacc_concat(:,1), 0) / sample_rate * 1000; % convert to ms, ensure non-negative
    sacc_concat_amp = zeros(size(sacc_concat, 1), 1);
    
    for i = 1:size(sacc_concat, 1)
        hor_idx = find(sacc_horizontal(:,1) == sacc_concat(i,1));
        ver_idx = find(sacc_vertical(:,1) == sacc_concat(i,1));
        
        if ~isempty(hor_idx)
            hor_idx = hor_idx(1);
            sacc_concat_amp(i) = abs(H_det(sacc_horizontal(hor_idx,2)) - H_det(sacc_horizontal(hor_idx,1)));
        elseif ~isempty(ver_idx)
            ver_idx = ver_idx(1);
            sacc_concat_amp(i) = abs(V_det(sacc_vertical(ver_idx,2)) - V_det(sacc_vertical(ver_idx,1)));
        else
            sacc_concat_amp(i) = sqrt((V_det(sacc_concat(i,2)) - V_det(sacc_concat(i,1)))^2 + ...
                                      (H_det(sacc_concat(i,2)) - H_det(sacc_concat(i,1)))^2);
        end
    end
    
    sacc_concat_stats = struct('number', size(sacc_concat, 1), ...
                               'duration_mean', mean(sacc_concat_dur), ...
                               'duration_std', std(sacc_concat_dur), ...
                               'duration_total', sum(sacc_concat_dur), ...
                               'amplitude_mean', mean(sacc_concat_amp), ...
                               'amplitude_std', std(sacc_concat_amp));
end