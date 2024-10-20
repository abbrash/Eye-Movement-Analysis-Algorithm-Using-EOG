function fix_ver_dur = detectVerticalFixations(label_sig_ver_sacc)
    % Detect vertical fixations from a labeled signal
    % Input:
    %   label_sig_ver_sacc: Labeled signal for vertical saccades (1 for fixation, 2 for saccade)
    % Output:
    %   fix_ver_dur: Vector of fixation durations

    % Input validation
    if ~isvector(label_sig_ver_sacc)
        error('label_sig_ver_sacc must be a vector');
    end
    if ~all(ismember(label_sig_ver_sacc, [1, 2]))
        warning('label_sig_ver_sacc should only contain values 1 and 2');
    end

    fix_ver_dur = [];
    dur_temp = 0;

    % Iterate through the labeled signal
    for i = 1:length(label_sig_ver_sacc)
        if label_sig_ver_sacc(1,i) == 1
            % Increment duration for fixation
            dur_temp = dur_temp + 1;
        else
            % End of fixation, store duration and reset
            fix_ver_dur = [fix_ver_dur dur_temp];
            dur_temp = 0;
        end
    end

    % Add the last fixation duration if the signal ends with a fixation
    if dur_temp > 0
        fix_ver_dur = [fix_ver_dur dur_temp];
    end

    % Ensure output is a row vector
    fix_ver_dur = fix_ver_dur(:)';

    % Check if any fixations were detected
    if isempty(fix_ver_dur)
        warning('No vertical fixations detected in the input signal');
    end
end