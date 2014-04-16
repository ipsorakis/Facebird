function [day_indices absolute_days] = get_day_indices(timestamps,time_window)

% in a normal datastream, where observations are in seconds, time_window
% should be 1. In case the given timestamps are in the form of
% t/time_window timeslots, then the time_window with which these
% observations have been created must be given.
if ~exist('time_window','var')
    time_window = 1;
end

day_indices = {};
absolute_days = 0;

day_timestamps = ceil((timestamps*time_window)/(60*60*24));
rolling_window = 1;
increment_step = 1;

start_index = 1;
frame = 0;

stop_next=false;
while ~stop_next
    frame = frame+1;
    %% EVALUATE END INDICES
    start_time = day_timestamps(start_index);
    
    end_index = find(day_timestamps>start_time+rolling_window-1,1)-1;
    if isempty(end_index)
        end_index = length(day_timestamps);
        stop_next=true;
    end
    
    %% STORE DAY INDICES
    day_indices{frame} = [start_index end_index];
    absolute_days(frame) = ceil((timestamps(start_index)*time_window)/(3600*24));
    %% EVALUATE START INDICES
    start_index = find(day_timestamps>start_time+increment_step-1,1);
end
end