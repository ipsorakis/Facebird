function [R tw od] = get_correlation_between_density_and_time_window(DATA,L,time_window_value_range)
day_indices_from_DATA = get_day_indices(DATA(:,1),1);
total_days = length(day_indices_from_DATA);

tw = zeros(total_days,1);
od = zeros(total_days,1);

for day = 1 : total_days
   tw(day) = get_dissimilarity_plot(L,time_window_value_range,day);
   od(day) = get_observation_density(DATA(day_indices_from_DATA{day}(1):day_indices_from_DATA{day}(2),1));
end

R = get_pearson_coefficient(tw,od);
scatter(tw,od);
end