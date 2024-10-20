function fix_hor_dur = detectHorizontalFixations(label_sig_hor_sacc)
    % Detect horizontal fixations from a labeled signal
    % Input:
    %   label_sig_hor_sacc: Labeled signal for horizontal saccades (1 for fixation, 2 for saccade)
    % Output:
    %   fix_hor_dur: Vector of fixation durations

    % Input validation
    if ~isvector(label_sig_hor_sacc)
        error('label_sig_hor_sacc must be a vector');
    end
    if ~all(ismember(label_sig_hor_sacc, [1, 2]))
        warning('label_sig_hor_sacc should only contain values 1 and 2');
    end

    fix_hor_dur = [];
    dur_temp = 0;

    % Iterate through the labeled signal
    for i = 1:length(label_sig_hor_sacc)
        if label_sig_hor_sacc(1,i) == 1
            % Increment duration for fixation
            dur_temp = dur_temp + 1;
        else
            % End of fixation, store duration and reset
            fix_hor_dur = [fix_hor_dur dur_temp];
            dur_temp = 0;
        end
    end

    % Add the last fixation duration if the signal ends with a fixation
    if dur_temp > 0
        fix_hor_dur = [fix_hor_dur dur_temp];
    end

    % Ensure output is a row vector
    fix_hor_dur = fix_hor_dur(:)';

    % Check if any fixations were detected
    if isempty(fix_hor_dur)
        warning('No fixations detected in the input signal');
    end
end