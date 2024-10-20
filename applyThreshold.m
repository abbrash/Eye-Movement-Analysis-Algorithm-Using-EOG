function label_sig = applyThreshold(label_sig, target_label, threshold, replacement_label)
    % Apply a threshold to relabel short sequences in a label signal
    %
    % Inputs:
    %   label_sig - Input label signal (vector)
    %   target_label - Label to be thresholded
    %   threshold - Minimum length for a sequence to remain unchanged
    %   replacement_label - Label to replace short sequences
    %
    % Output:
    %   label_sig - Modified label signal

    % Input validation
    if ~isvector(label_sig)
        error('Input label_sig must be a vector');
    end
    if ~isscalar(target_label) || ~isscalar(replacement_label)
        error('target_label and replacement_label must be scalars');
    end
    if ~isscalar(threshold) || threshold < 1 || floor(threshold) ~= threshold
        error('threshold must be a positive integer');
    end

    count = 0;
    for i = 1:length(label_sig)
        if label_sig(i) == target_label
            count = count + 1;
        else
            % If a sequence of target_label ends
            if count > 0 && count < threshold
                % Replace short sequences with replacement_label
                label_sig(i - count:i - 1) = replacement_label;
            end
            count = 0;
        end
    end

    % Check for sequences at the end of the signal
    if count > 0 && count < threshold
        label_sig(end - count + 1:end) = replacement_label;
    end
end