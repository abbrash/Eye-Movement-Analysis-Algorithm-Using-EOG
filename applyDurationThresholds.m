function label_sig = applyDurationThresholds(label_sig, thresh_sac_dur, thresh_fix_dur)
    % Apply saccade duration threshold
    label_sig = applyThreshold(label_sig, 2, thresh_sac_dur, 1);
    
    % Apply fixation duration threshold
    label_sig = applyThreshold(label_sig, 1, thresh_fix_dur, 0);
end