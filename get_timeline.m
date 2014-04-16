function timeline = get_timeline(unique_time_slots,time_interval)

start_date = convert_timestamp_to_date(unique_time_slots(1),time_interval);
start_date(1:3) = 0;
start_time = convert_date_vector_to_timestamp(start_date,time_interval);

end_date = convert_timestamp_to_date(unique_time_slots(end),time_interval);
end_date(1) = 59;
end_date(2) = 59;
end_date(3) = 23;
end_time = convert_date_vector_to_timestamp(end_date,time_interval);

timeline = start_time:end_time;

end