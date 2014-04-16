function visits = plot_bird_arrivals_timeline(Occs,unique_time_slots,time_interval,location_specifier)
%% initialisations
if ~exist('location_specifier','var') || (exist('location_specifier','var') && length(location_specifier)==1 && location_specifier == -1)
    location_specifier = 1:length(Occs);
end

timeline = get_timeline(unique_time_slots,time_interval);
normalised_timeline = timeline - timeline(1) + 1;

total_timeslots = length(timeline);
total_locations = length(location_specifier);
visits = zeros(total_timeslots,total_locations);

%% find day indicies
day_timestamps = ceil((timeline*time_interval) /(60*60*24))+1;
day_timestamps = day_timestamps - day_timestamps(1) +1;
stop_next=false;
start_index = 1;

day_iterator = 1;
day_indices = zeros(length(unique(day_timestamps)),1);
while ~stop_next
    start_time = day_timestamps(start_index);
    end_index = find(day_timestamps>start_time,1);
    
    if isempty(end_index)
        stop_next = true;
    else
        %end_time = day_timestamps(end_index);
        day_indices(day_iterator) = end_index;
        day_iterator = day_iterator + 1;
    end
    
    start_index = end_index+1;
end

%% plot arrivals
for location_index = 1:total_locations
    subplot(total_locations,1,location_index);
    hold on
    
    unique_arrivals = sum(1*logical(full(Occs{location_specifier(location_index)})));
    
    for i=1:length(unique_arrivals)
        %timeline_index = find(timeline == unique_time_slots(i),1);
        timeline_index = binary_search(unique_time_slots(i),timeline);
        visits(timeline_index,location_index) = unique_arrivals(i);
    end
    
    plot(normalised_timeline,visits(:,location_index));
    
    for i=1:length(day_indices)
       vline(day_indices(i),'k'); 
    end
    
    hold off
end

end