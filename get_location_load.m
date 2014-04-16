function LL = get_location_load(DATA)
day_indices = get_day_indices(DATA);
total_days = length(day_indices);

total_locations = length(unique(DATA(:,3)));

LL = zeros(total_days,total_locations);

for t=1:total_days
    DATA_DAY = DATA(day_indices{t}(1):day_indices{t}(2),:);
    for loc=1:total_locations
        LL(t,loc) = sum(DATA_DAY(:,3)==loc);
    end
end

end