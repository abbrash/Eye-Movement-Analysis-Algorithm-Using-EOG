# EyeTrack: Advanced EOG-based Eye Movement Analysis

EyeTrack is a sophisticated MATLAB algorithm for processing and analyzing eye movement data from electrooculography (EOG) recordings. It detects and classifies blinks, saccades, and fixations using advanced signal processing techniques across both horizontal and vertical EOG channels.

## Features

- Robust blink detection in the vertical EOG channel
- Independent saccade detection in both vertical and horizontal channels
- Minimum duration thresholding for saccades and fixations
- Integration of vertical and horizontal channel data for comprehensive event classification
- Clear delineation of overlapping events with priority given to blinks
- Visualization tools for analysis results

## Algorithm Overview

The algorithm is structured into six primary stages:

1. **Preprocessing**: Applies moving median and bandpass filters to reduce noise and eliminate low-frequency drift.
2. **Blink Detection**: Identifies blinks using peak detection and derivative analysis.
3. **Saccade Detection**: Analyzes both channels to detect saccades using thresholds on the EOG signal derivative.
4. **Saccade Duration Thresholding**: Applies a minimum duration threshold to differentiate genuine saccades from artifacts.
5. **Label Fusion**: Integrates vertical and horizontal label signals for a composite representation.
6. **Fixation Identification and Thresholding**: Identifies and thresholds fixations between detected saccades and blinks.

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/abbrash/Eye-Movement-Analysis-Algorithm-Using-EOG.git
   ```
2. Ensure you have MATLAB installed (version R2019b or later recommended).
3. Add the Eye-Movement-Analysis-Algorithm-Using-EOG directory to your MATLAB path.

## Usage

1. Ensure your EOG data file (e.g., 'test.mat') is in the same directory as the main script or specify the full path.

2. Open the main script ('main.m') and set the parameters at the beginning of the script:

   ```matlab
   dataFile = 'test.mat'; % Name of the data file to be processed
   time_task = [1 52]; % Time range for the task (in seconds)
   thresh_sac_dur = 10;  % Minimum duration of saccades (in samples)
   thresh_fix_dur = 50;  % Minimum duration of fixations (in samples)
   sample_rate = 250;    % Sampling rate in Hz
   thresh_blinks = 0.260;  % Threshold to detect blinks
   thresh_sacc_ver = 0.0030;  % Threshold to detect vertical saccades
   thresh_sacc_hor = 0.0035;  % Threshold to detect horizontal saccades
   windowSize = 1500;  % Window size for moving average
   ```

3. Run the main script in MATLAB. The script will:
   - Preprocess the EOG data
   - Detect blinks, saccades, and fixations
   - Generate visualizations
   - Calculate and display statistics
   - Save results and workspace

4. The script outputs:
   - Printed statistics in the MATLAB console
   - Visualization figures
   - Saved files:
     * `eye_movement_results_[timestamp].mat`: Contains a structure with all calculated statistics
     * `eye_movement_workspace_[timestamp].mat`: Complete workspace for further analysis
     * `eye_movement_summary_[timestamp].txt`: Text file with key results

5. To access the results programmatically after running the script:
   - Use the `results` structure for all calculated statistics
   - The `label_sig` variable contains the composite label where:
     * 3 = blinks
     * 2 = saccades
     * 1 = fixations
     * 0 = unknown events

Example of accessing results:
```matlab
% After running the main script
disp(['Number of blinks: ' num2str(results.blink_stats.number)]);
disp(['Mean fixation duration: ' num2str(results.fix_stats.duration_mean) ' ms']);
```

## Example Output

When you run the main script, you'll get output similar to the following:

```
Total recording time: 51.00 seconds
Total fixation time: 30.97 seconds (60.72%)
Total saccade time: 8.24 seconds (16.16%)
Total blink time: 6.01 seconds (11.78%)

Blink Statistics:
Number of blinks: 15
Blink amplitude mean: 0.4264
Blink amplitude standard deviation: 0.0550
Blink duration mean: 396.53 ms
Blink duration standard deviation: 61.33 ms

Saccade Statistics:
Number of saccades: 49
Saccade amplitude mean: 0.0462
Saccade amplitude standard deviation: 0.0460
Saccade duration mean: 84.98 ms
Saccade duration standard deviation: 347.74 ms

Fixation Statistics:
Number of fixations: 54
Fixation duration mean: 2964.44 ms
Fixation duration standard deviation: 1663.59 ms

Results saved to: eye_movement_results_20241020_131304.mat
Workspace saved to: eye_movement_workspace_20241020_131304.mat
Summary saved to: eye_movement_summary_20241020_131304.txt
```

This output provides a comprehensive summary of the eye movement analysis, including:

1. Overall time distribution between fixations, saccades, and blinks
2. Detailed statistics for each type of eye movement event
3. Information about the saved result files for further analysis

In addition to this textual output, the script generates several visualization plots to help you interpret the data visually. These plots include:

1. Vertical Eye Movements
2. Horizontal Eye Movements
3. Combined Eye Movement Labels

These visualizations offer a graphical representation of the detected eye movements over time, allowing for easy identification of patterns and events in the data.
```

## Visualizations

The algorithm generates several plots:
1. Vertical Eye Movements
2. Horizontal Eye Movements
3. Combined Eye Movement Labels

## Applications

- Reading behavior analysis
- Visual attention studies
- Neurological assessments
- Human-computer interaction research

## Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) file for details on how to submit pull requests, report issues, or request features.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- [List any individuals, labs, or institutions that contributed to or inspired this work]
- [Mention any relevant papers or resources that were crucial in developing this algorithm]

## Contact

[Arash Abbasi Larki] - [arash.abbasi20@gmail.com]

Project Link: [https://github.com/abbrash/Eye-Movement-Analysis-Algorithm-Using-EOG](https://github.com/abbrash/Eye-Movement-Analysis-Algorithm-Using-EOG)
