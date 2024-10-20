function [H_proc, V_proc, H_det_der, V_det_der, time_in_sec_for_plot] = preprocessEyeMovementData(dataFile, time, sample_rate, windowSize)
    % Preprocess eye movement data
    % Inputs:
    %   dataFile: Path to the data file
    %   time: [start_time, end_time] in seconds
    %   sample_rate: Sampling rate of the data in Hz
    %   windowSize: Window size for smoothing
    % Outputs:
    %   H_proc, V_proc: Processed horizontal and vertical eye position signals
    %   H_det_der, V_det_der: Derivatives of detrended horizontal and vertical signals
    %   time_in_sec_for_plot: Time vector for plotting

    % Input validation
    if ~ischar(dataFile) || ~exist(dataFile, 'file')
        error('Invalid data file path');
    end
    if ~isvector(time) || length(time) ~= 2
        error('Time must be a vector with 2 elements [start_time, end_time]');
    end
    if ~isscalar(sample_rate) || sample_rate <= 0
        error('Sample rate must be a positive scalar');
    end
    if ~isscalar(windowSize) || windowSize <= 0 || mod(windowSize, 1) ~= 0
        error('Window size must be a positive integer');
    end

    % Load data
    try
        load(dataFile);
    catch
        error('Failed to load data from file: %s', dataFile);
    end

    % Extract time range
    t0_sec = time(1,1);
    t1_sec = time(1,2);
    t0 = round(t0_sec * sample_rate);
    t1 = round(t1_sec * sample_rate);

    % Check if A and B exist and have sufficient length
    if ~exist('A', 'var') || ~exist('B', 'var') || length(A) < t1 || length(B) < t1
        error('Data variables A and B not found or insufficient length');
    end

    % Extract signals
    H = A(t0 : t1);
    V = B(t0 : t1);

    % Create time vector for plotting
    time_in_sec_for_plot = (0:numel(H)-1) / sample_rate;

    % Smooth signals
    H_smth = smoothdata(H, "movmedian", windowSize);
    V_smth = smoothdata(V, "movmedian", windowSize);

    % Detrend signals
    H_det = H - H_smth;
    V_det = V - V_smth;

    % Filter signals
    a_coeff = 1/20 * ones(20, 1);
    V_filt = filtfilt(a_coeff, 1, V_det);
    H_filt = filtfilt(a_coeff, 1, H_det);

    % Processed signals
    V_proc = V_filt;
    H_proc = H_filt;

    % Calculate derivatives
    V_det_der = diff(V_det);
    H_det_der = diff(H_det);
end