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
   git clone https://github.com/yourusername/eye-track.git
   ```
2. Ensure you have MATLAB installed (version R2019b or later recommended).
3. Add the EyeTrack directory to your MATLAB path.

## Usage

1. Load your EOG data into MATLAB.
2. Run the main script:
   ```matlab
   [compositeLabel, stats, figures] = eyeTrack(verticalEOG, horizontalEOG);
   ```
3. The function returns:
   - `compositeLabel`: A vector where 3 = blinks, 2 = saccades, 1 = fixations, 0 = unknown events
   - `stats`: A struct containing statistics about detected events
   - `figures`: MATLAB figure handles for visualizations

## Example Output

```matlab
Total recording time: 51.00 seconds
Fixation time: 30.97 seconds (60.72%)
Saccade time: 8.24 seconds (16.16%)
Blink time: 6.01 seconds (11.78%)
Number of blinks: 15
Number of saccades: 49
Number of fixations: 54
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

[Your Name] - [your.email@example.com]

Project Link: [https://github.com/yourusername/eye-track](https://github.com/yourusername/eye-track)
