function events = getLabeledEvents(label_sig, event_type)
    % Extract start and end indices of labeled events from a signal
    % Inputs:
    %   label_sig: Labeled signal vector
    %   event_type: Integer label of the event type to extract
    % Output:
    %   events: Matrix of event start and end indices

    % Input validation
    if ~isvector(label_sig)
        error('label_sig must be a vector');
    end
    if ~isscalar(event_type) || ~isnumeric(event_type) || floor(event_type) ~= event_type
        error('event_type must be an integer scalar');
    end

    % Find the start and end indices of each event
    diff_sig = diff([0, label_sig, 0]);
    starts = find(diff_sig == event_type);
    ends = find(diff_sig == -event_type) - 1;

    % Ensure starts and ends have the same length
    if length(starts) > length(ends)
        % If the signal ends with the event, add the last index as the end
        ends = [ends, length(label_sig)];
    elseif length(ends) > length(starts)
        % If there's an end without a start, remove the first end
        ends = ends(2:end);
    end

    % Ensure starts and ends are column vectors
    starts = starts(:);
    ends = ends(:);

    % Create the events matrix, ensuring equal length
    events = [starts(1:min(length(starts), length(ends))), ends(1:min(length(starts), length(ends)))];

    % Check if any events were detected
    if isempty(events)
        warning('No events of type %d were detected in the input signal', event_type);
    end
end