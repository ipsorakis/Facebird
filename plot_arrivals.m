function [outputs] = plot_arrivals(DATA,t_step,bin_size)

if ~exist('t_step','var')
    t_step = -1;
end

event_timestamps = DATA(:,1);
[clock_time clock_time_properties] = convert_event_time_to_clock_time(event_timestamps,t_step);

if ~exist('bin_size','var')
    bin_size = clock_time_properties.mean_time_between_events;
end

%%
binned_event_timestamps = ceil(event_timestamps/bin_size);
unique_binned_event_timestamps = unique(binned_event_timestamps);
number_of_unique_binned_event_timestamps = length(unique_binned_event_timestamps);

number_of_arrivals_per_event_bin = zeros(number_of_unique_binned_event_timestamps,1);

for i=1:number_of_unique_binned_event_timestamps
    t_indices = binned_event_timestamps == unique_binned_event_timestamps(i);
    number_of_arrivals_per_event_bin(i) = sum(t_indices);
end


%%
binned_clock_time = ceil(clock_time/bin_size);
unique_binned_clock_timestamps = unique(binned_clock_time);
number_of_unique_binned_clock_timestamps = length(unique_binned_clock_timestamps);

number_of_arrivals_per_clock_bin = zeros(number_of_unique_binned_clock_timestamps,1);

for i=1:number_of_unique_binned_event_timestamps
    arrival_index = find(unique_binned_clock_timestamps == unique_binned_event_timestamps(i),1);
    number_of_arrivals_per_clock_bin(arrival_index) = number_of_arrivals_per_event_bin(i);
end

%%
plot(unique_binned_clock_timestamps,number_of_arrivals_per_clock_bin);

outputs = struct('number_of_arrivals_per_clock_bin',number_of_arrivals_per_clock_bin,...
    'unique_binned_clock_timestamps',unique_binned_clock_timestamps,...
    'bin_size',bin_size);
%% deprecated
% number_of_total_observations = size(DATA(:,1));
%
% t0 = DATA(1,1);
% tend = DATA(number_of_total_observations,1);
%
% location_indices = unique(DATA(:,3));
% number_of_locations = length(location_indices);
%
% total_observation_timestamps = DATA(:,1);
% timeline_bined = ceil(total_observation_timestamps/bin_size);
% timeline = unique(timeline_bined);
%
% for location_index = 1:number_of_locations
%     current_location = location_indices(location_index);
%
%     DATA_location = DATA(DATA(:,3)==current_location);
%     location_timestamps = DATA_location(:,1);
%
%
%
% end

end