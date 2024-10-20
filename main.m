% Main script for eye movement analysis
% This script processes eye movement data, detects blinks, saccades, and fixations,
% and provides statistical analysis of the eye movements.

% Clear workspace, close all figures, and clear command window
clear all;
close all;
clc;

% Set the main directory
mainDir = fileparts(which('main.m'));
if isempty(mainDir)
    error('main.m not found in the MATLAB path. Please ensure it exists and is in the MATLAB path.');
end

% Set parameters
dataFile = 'test.mat'; % Name of the data file to be processed
time_task = [1 52]; % Time range for the task (in seconds)
thresh_sac_dur = 10;  % The minimum duration of saccades = 40 ms ~ 10 samples with sample frequency of 250 Hz
thresh_fix_dur = 50;  % The minimum duration of fixations = 200 ms ~ 50 samples with sample frequency of 250 Hz
sample_rate = 250;    % Hz
thresh_blinks = 0.260;  % Set the threshold to detect blinks
thresh_sacc_ver = 0.0030;  % Set the threshold to detect Vertical saccades
thresh_sacc_hor = 0.0035;  % Set the threshold to detect Horizontal saccades 
windowSize = 1500;  % Window size for moving average

% Preprocess data
[H_proc, V_proc, H_det_der, V_det_der, time_in_sec_for_plot] = preprocessEyeMovementData(dataFile, time_task, sample_rate, windowSize);

% Blink detection
[blinks, label_signal_blinks, V_det_der_temp, H_det_der] = detectBlinks(V_proc, V_det_der, H_det_der, thresh_blinks);

% Vertical saccade detection
[sacc_vertical, label_sig_ver_sacc] = detectVerticalSaccades(V_proc, V_det_der, V_det_der_temp, thresh_sacc_ver, blinks);

% Horizontal saccade detection
[sacc_horizontal, label_sig_hor_sacc] = detectHorizontalSaccades(H_proc, H_det_der, thresh_sacc_hor);

% Fixation detection
fix_ver_dur = detectVerticalFixations(label_sig_ver_sacc);
fix_hor_dur = detectHorizontalFixations(label_sig_hor_sacc);

% Combined labeling
label_sig = combinedEyeMovementLabeling(H_proc, sacc_horizontal, sacc_vertical, blinks, label_sig_ver_sacc, label_sig_hor_sacc, thresh_sac_dur, thresh_fix_dur);

% Plot results with enhanced function
plotEyeMovementResults(time_in_sec_for_plot, V_proc, H_proc, V_det_der, H_det_der, blinks, sacc_vertical, sacc_horizontal, label_sig_ver_sacc, label_sig_hor_sacc, label_sig, thresh_blinks, thresh_sacc_ver, thresh_sacc_hor);

% Additional analysis
total_time = length(label_sig) / sample_rate;
fixation_time = sum(label_sig == 1) / sample_rate;
saccade_time = sum(label_sig == 2) / sample_rate;
blink_time = sum(label_sig == 3) / sample_rate;

fprintf('Total recording time: %.2f seconds\n', total_time);
fprintf('Total fixation time: %.2f seconds (%.2f%%)\n', fixation_time, fixation_time/total_time*100);
fprintf('Total saccade time: %.2f seconds (%.2f%%)\n', saccade_time, saccade_time/total_time*100);
fprintf('Total blink time: %.2f seconds (%.2f%%)\n', blink_time, blink_time/total_time*100);
fprintf('\n');

% Assuming these are the correct variable names in your main script
% Updated function call in your main script
[blink_stats, sacc_ver_stats, sacc_hor_stats, fix_stats, sacc_concat_stats] = analyzeEyeMovements(V_proc, H_proc, blinks, sacc_vertical, sacc_horizontal, label_sig, sample_rate);

% Extract blink statistics
fprintf('Blink Statistics:\n');
fprintf('Number of blinks: %d\n', blink_stats.number);
fprintf('Blink amplitude mean: %.4f\n', blink_stats.amplitude_mean);
fprintf('Blink amplitude standard deviation: %.4f\n', blink_stats.amplitude_std);
fprintf('Blink duration mean: %.2f ms\n', blink_stats.duration_mean);
fprintf('Blink duration standard deviation: %.2f ms\n', blink_stats.duration_std);
fprintf('\n');

% Extract saccade statistics (using combined saccade stats)
fprintf('Saccade Statistics:\n');
fprintf('Number of saccades: %d\n', sacc_concat_stats.number);
fprintf('Saccade amplitude mean: %.4f\n', sacc_concat_stats.amplitude_mean);
fprintf('Saccade amplitude standard deviation: %.4f\n', sacc_concat_stats.amplitude_std);
fprintf('Saccade duration mean: %.2f ms\n', sacc_concat_stats.duration_mean);
fprintf('Saccade duration standard deviation: %.2f ms\n', sacc_concat_stats.duration_std);
fprintf('\n');

% Extract fixation statistics
fprintf('Fixation Statistics:\n');
fprintf('Number of fixations: %d\n', fix_stats.number);
fprintf('Fixation duration mean: %.2f ms\n', fix_stats.duration_mean);
fprintf('Fixation duration standard deviation: %.2f ms\n', fix_stats.duration_std);
fprintf('\n');

% Save results and workspace variables

% Create a results structure
results = struct();
results.total_time = total_time;
results.fixation_time = fixation_time;
results.saccade_time = saccade_time;
results.blink_time = blink_time;
results.blink_stats = blink_stats;
results.sacc_ver_stats = sacc_ver_stats;
results.sacc_hor_stats = sacc_hor_stats;
results.sacc_concat_stats = sacc_concat_stats;
results.fix_stats = fix_stats;

% Get current date and time for filename
current_datetime = datestr(now, 'yyyymmdd_HHMMSS');

% Save results structure
results_filename = sprintf('eye_movement_results_%s.mat', current_datetime);
save(results_filename, 'results');
fprintf('Results saved to: %s\n', results_filename);

% Save entire workspace
workspace_filename = sprintf('eye_movement_workspace_%s.mat', current_datetime);
save(workspace_filename);
fprintf('Workspace saved to: %s\n', workspace_filename);

% Optional: Save a text file with key results
txt_filename = sprintf('eye_movement_summary_%s.txt', current_datetime);
fid = fopen(txt_filename, 'w');
fprintf(fid, 'Eye Movement Analysis Summary\n');
fprintf(fid, 'Date: %s\n\n', datestr(now));
fprintf(fid, 'Total recording time: %.2f seconds\n', total_time);
fprintf(fid, 'Total fixation time: %.2f seconds (%.2f%%)\n', fixation_time, fixation_time/total_time*100);
fprintf(fid, 'Total saccade time: %.2f seconds (%.2f%%)\n', saccade_time, saccade_time/total_time*100);
fprintf(fid, 'Total blink time: %.2f seconds (%.2f%%)\n\n', blink_time, blink_time/total_time*100);

fprintf(fid, 'Blink Statistics:\n');
fprintf(fid, 'Number of blinks: %d\n', blink_stats.number);
fprintf(fid, 'Blink amplitude mean: %.4f\n', blink_stats.amplitude_mean);
fprintf(fid, 'Blink amplitude standard deviation: %.4f\n', blink_stats.amplitude_std);
fprintf(fid, 'Blink duration mean: %.2f ms\n', blink_stats.duration_mean);
fprintf(fid, 'Blink duration standard deviation: %.2f ms\n\n', blink_stats.duration_std);

fprintf(fid, 'Saccade Statistics:\n');
fprintf(fid, 'Number of saccades: %d\n', sacc_concat_stats.number);
fprintf(fid, 'Saccade amplitude mean: %.4f\n', sacc_concat_stats.amplitude_mean);
fprintf(fid, 'Saccade amplitude standard deviation: %.4f\n', sacc_concat_stats.amplitude_std);
fprintf(fid, 'Saccade duration mean: %.2f ms\n', sacc_concat_stats.duration_mean);
fprintf(fid, 'Saccade duration standard deviation: %.2f ms\n\n', sacc_concat_stats.duration_std);

fprintf(fid, 'Fixation Statistics:\n');
fprintf(fid, 'Number of fixations: %d\n', fix_stats.number);
fprintf(fid, 'Fixation duration mean: %.2f ms\n', fix_stats.duration_mean);
fprintf(fid, 'Fixation duration standard deviation: %.2f ms\n', fix_stats.duration_std);

fclose(fid);
fprintf('Summary saved to: %s\n', txt_filename);
