function plot_daily_activity(Occs,observation_timestamps,unique_timestamps,day_indices,location_index,day_number)

day_start = day_indices{day_number}(1);
day_end = day_indices{day_number}(2);

time_steps = zeros(observation_timestamps,1)

for i=1:size(unique_timestamps)
    
end

%tmp = full(Occs{location_index}(:,day_start:day_end));
%plot(sum(tmp));

end