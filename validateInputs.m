function validateInputs(V_det, H_det, blinks, sacc_vertical, sacc_horizontal, label_sig, sample_rate)
    % Validate inputs for eye movement analysis
    % Inputs:
    %   V_det: Vertical eye position signal
    %   H_det: Horizontal eye position signal
    %   blinks: Matrix of blink start, peak, and end times
    %   sacc_vertical: Matrix of vertical saccade start and end times
    %   sacc_horizontal: Matrix of horizontal saccade start and end times
    %   label_sig: Label signal
    %   sample_rate: Sampling rate of the signals

    % Check if all inputs are provided
    if nargin < 7
        error('Not enough input arguments. Please provide all required inputs.');
    end

    % Validate V_det and H_det
    if ~isvector(V_det) || ~isvector(H_det)
        error('V_det and H_det must be vectors.');
    end
    if length(V_det) ~= length(H_det)
        error('V_det and H_det must have the same length.');
    end

    % Validate sample_rate
    if ~isnumeric(sample_rate) || ~isscalar(sample_rate) || sample_rate <= 0
        error('sample_rate must be a positive scalar.');
    end

    % Validate blinks
    try
        validateattributes(blinks, {'numeric'}, {'2d', 'ncols', 3}, 'analyzeEyeMovements', 'blinks');
    catch
        error('blinks must be a numeric matrix with 3 columns (start, peak, end).');
    end

    % Validate sacc_vertical and sacc_horizontal
    try
        validateattributes(sacc_vertical, {'numeric'}, {'2d', 'ncols', 2}, 'analyzeEyeMovements', 'sacc_vertical');
        validateattributes(sacc_horizontal, {'numeric'}, {'2d', 'ncols', 2}, 'analyzeEyeMovements', 'sacc_horizontal');
    catch
        error('sacc_vertical and sacc_horizontal must be numeric matrices with 2 columns (start, end).');
    end

    % Validate label_sig
    try
        validateattributes(label_sig, {'numeric'}, {'vector'}, 'analyzeEyeMovements', 'label_sig');
    catch
        error('label_sig must be a numeric vector.');
    end

    % Check if label_sig has the same length as V_det and H_det
    if length(label_sig) ~= length(V_det)
        error('label_sig must have the same length as V_det and H_det.');
    end

    % Check if all indices in blinks, sacc_vertical, and sacc_horizontal are within the signal length
    signal_length = length(V_det);
    if any(blinks(:) > signal_length) || any(sacc_vertical(:) > signal_length) || any(sacc_horizontal(:) > signal_length)
        error('Some indices in blinks, sacc_vertical, or sacc_horizontal exceed the signal length.');
    end

    % Additional checks could be added here, such as:
    % - Ensuring blinks, sacc_vertical, and sacc_horizontal have non-negative integers
    % - Checking if start times are always before end times
    % - Verifying that label_sig only contains expected values (e.g., 0, 1, 2, 3)
end