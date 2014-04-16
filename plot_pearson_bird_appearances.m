function pearson = plot_pearson_bird_appearances(M,F,timestamps,time_window)

%% BUILD TIMESTAMPS
start_date = convert_timestamp_to_date(timestamps(1),time_window);
start_time = convert_date_vector_to_timestamp(start_date,1);

end_date = convert_timestamp_to_date(timestamps(end),time_window);
end_time = convert_date_vector_to_timestamp(end_date,1);

timeline_days = ceil(start_time/(24*3600)):1:ceil(end_time/(24*3600));
baseline_day = timeline_days(1);
timeline_days = timeline_days - baseline_day + 1;

%% EVALUATE pearson
[day_indices_from_timestamps absolute_days] = get_day_indices(timestamps,time_window);
total_days = length(day_indices_from_timestamps);
absolute_days = absolute_days - baseline_day + 1;

pearson = zeros(total_days,1);

for day_index=1:total_days
   m = M(day_indices_from_timestamps{day_index}(1):day_indices_from_timestamps{day_index}(2));
   f = F(day_indices_from_timestamps{day_index}(1):day_indices_from_timestamps{day_index}(2));

   p = get_pearson_coefficient(m,f);
   
   pearson(day_index) = p;
   
end

%% PLOT 
pearson_timeline = zeros(length(timeline_days),1);
for day_index=1:total_days
    pearson_timeline(absolute_days(day_index)) = pearson(day_index);
end

plot(timeline_days,pearson_timeline);
end