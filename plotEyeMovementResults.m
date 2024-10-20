function plotEyeMovementResults(time_in_sec_for_plot, V_proc, H_proc, V_det_der, H_det_der, blinks, sacc_vertical, sacc_horizontal, label_sig_ver_sacc, label_sig_hor_sacc, label_sig, thresh_blinks, thresh_sacc_ver, thresh_sacc_hor)
    % Plot the results of eye movement analysis
    % Inputs:
    %   time_in_sec_for_plot: Time vector in seconds
    %   V_proc, H_proc: Vertical and horizontal eye position signals
    %   V_det_der, H_det_der: Vertical and horizontal velocity signals
    %   blinks: Matrix of blink start and end indices
    %   sacc_vertical, sacc_horizontal: Matrices of saccade start and end indices
    %   label_sig_ver_sacc, label_sig_hor_sacc: Labeled signals for vertical and horizontal movements
    %   label_sig: Combined labeled signal
    %   thresh_blinks, thresh_sacc_ver, thresh_sacc_hor: Thresholds for blinks and saccades

    % Input validation
    if ~isvector(time_in_sec_for_plot) || ~isvector(V_proc) || ~isvector(H_proc) || ...
       ~isvector(V_det_der) || ~isvector(H_det_der) || ~isvector(label_sig_ver_sacc) || ...
       ~isvector(label_sig_hor_sacc) || ~isvector(label_sig)
        error('Time, signal, derivative, and label inputs must be vectors');
    end
    if ~ismatrix(blinks) || ~ismatrix(sacc_vertical) || ~ismatrix(sacc_horizontal)
        error('blinks, sacc_vertical, and sacc_horizontal must be matrices');
    end
    if ~isscalar(thresh_blinks) || ~isscalar(thresh_sacc_ver) || ~isscalar(thresh_sacc_hor)
        error('Threshold inputs must be scalars');
    end

    % Figure 1: Vertical signal with blinks, saccades, fixations, label signal, and derivative
    figure('Name', 'Vertical Eye Movements', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 800]);
    
    % Vertical signal plot
    subplot(3,1,1);
    plot(time_in_sec_for_plot, V_proc, 'k', 'DisplayName', 'Signal');
    hold on;
    
    % Plot blinks
    blinks_plotted = false;
    for i = 1:size(blinks, 1)
        if ~blinks_plotted
            plot(time_in_sec_for_plot(blinks(i,1):blinks(i,3)), V_proc(blinks(i,1):blinks(i,3)), 'r', 'LineWidth', 1, 'DisplayName', 'Blinks');
            blinks_plotted = true;
        else
            plot(time_in_sec_for_plot(blinks(i,1):blinks(i,3)), V_proc(blinks(i,1):blinks(i,3)), 'r', 'LineWidth', 1, 'HandleVisibility', 'off');
        end
    end
    
    % Plot vertical saccades
    saccades_plotted = false;
    for i = 1:size(sacc_vertical, 1)
        if ~saccades_plotted
            plot(time_in_sec_for_plot(sacc_vertical(i,1):sacc_vertical(i,2)), V_proc(sacc_vertical(i,1):sacc_vertical(i,2)), 'g', 'LineWidth', 1, 'DisplayName', 'Saccades');
            saccades_plotted = true;
        else
            plot(time_in_sec_for_plot(sacc_vertical(i,1):sacc_vertical(i,2)), V_proc(sacc_vertical(i,1):sacc_vertical(i,2)), 'g', 'LineWidth', 1, 'HandleVisibility', 'off');
        end
    end
    
    % Plot blink threshold
    yline(thresh_blinks, 'r--', 'DisplayName', 'Blink Threshold');
    
    xlabel('Time (s)');
    ylabel('Vertical position');
    title('Vertical Eye Movements');
    legend('Location', 'best');
    
    % Vertical derivative plot
    subplot(3,1,2);
    plot(time_in_sec_for_plot(1:end-1), V_det_der, 'k');
    hold on;
    yline(thresh_sacc_ver, 'g--');
    yline(-thresh_sacc_ver, 'g--');
    xlabel('Time (s)');
    ylabel('Vertical velocity');
    title('Vertical Eye Movement Derivative');
    legend('Derivative', 'Saccade Threshold');
    
    % Vertical label signal plot
    subplot(3,1,3);
    plot(time_in_sec_for_plot, label_sig_ver_sacc);
    xlabel('Time (s)');
    ylabel('Label');
    title('Vertical Label Signal');
    ylim([0 4]);
    yticks(0:3);
    yticklabels({'Undefined (0)', 'Fixation (1)', 'Saccade (2)', 'Blink (3)'});
    
    % Figure 2: Horizontal signal with saccades, fixations, label signal, and derivative
    figure('Name', 'Horizontal Eye Movements', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 800]);
    
    % Horizontal signal plot
    subplot(3,1,1);
    plot(time_in_sec_for_plot, H_proc, 'k');
    hold on;
    
    % Plot horizontal saccades
    for i = 1:size(sacc_horizontal, 1)
        x = [time_in_sec_for_plot(sacc_horizontal(i,1)), time_in_sec_for_plot(sacc_horizontal(i,2))];
        y = [H_proc(sacc_horizontal(i,1)), H_proc(sacc_horizontal(i,2))];
        plot(x, y, 'g', 'LineWidth', 1);
    end
    
    xlabel('Time (s)');
    ylabel('Horizontal position');
    title('Horizontal Eye Movements');
    legend('Signal', 'Saccades');
    
    % Horizontal derivative plot
    subplot(3,1,2);
    plot(time_in_sec_for_plot(1:end-1), H_det_der, 'k');
    hold on;
    yline(thresh_sacc_hor, 'g--');
    yline(-thresh_sacc_hor, 'g--');
    xlabel('Time (s)');
    ylabel('Horizontal velocity');
    title('Horizontal Eye Movement Derivative');
    legend('Derivative', 'Saccade Threshold');
    
    % Horizontal label signal plot
    subplot(3,1,3);
    plot(time_in_sec_for_plot, label_sig_hor_sacc);
    xlabel('Time (s)');
    ylabel('Label');
    title('Horizontal Label Signal');
    ylim([0 3]);
    yticks(0:2);
    yticklabels({'Undefined (0)', 'Fixation (1)', 'Saccade (2)'});
    
    % Figure 3: Combined label signal
    figure('Name', 'Combined Eye Movement Labels', 'NumberTitle', 'off');
    plot(time_in_sec_for_plot, label_sig);
    xlabel('Time (s)');
    ylabel('Label');
    title('Combined Eye Movement Labels');
    ylim([0 4]);
    yticks(0:3);
    yticklabels({'Undefined (0)', 'Fixation (1)', 'Saccade (2)', 'Blink (3)'});
end