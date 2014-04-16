function [D time_bins ALL_DIFFS total_observations] = get_inter_event_time_distribution(DATA,day_indices)

secs_in_day = 3600*24;

time_bins = 0:60:secs_in_day;

total_days = length(day_indices);

total_observations = 0;

D = zeros(length(time_bins),1);

ALL_DIFFS = [];

max_diff = 0;

for day=1:total_days
    DATA_WORKER = DATA;
    DATA_DAY = DATA_WORKER(day_indices{day}(1):day_indices{day}(2),:);
    
    locations = unique(DATA_DAY(:,3));
    
    for loc_index=1:length(locations)
        current_location = locations(loc_index);
        
        loc_indices = DATA_DAY(:,3)==current_location;
        
        DATA_LOC = DATA_DAY(loc_indices,:);
        
        %
        time_diffs_unfiltered = diff(DATA_LOC(:,1));
        ID_diffs = logical(diff(DATA_LOC(:,2)));
        
        time_diffs = time_diffs_unfiltered(ID_diffs);
        
        ALL_DIFFS = [ALL_DIFFS;time_diffs];
        
        %
        local_max_diff = max(time_diffs);
        if local_max_diff>max_diff
           max_diff = local_max_diff; 
        end
        
        %
        d = histc(time_diffs,time_bins);
        
        if isempty(d)
            continue;
        end
        
        if isrow(d)
            d = d';
        end
        
        D = D + d;
        
        total_observations = total_observations+1;
    end    
end

max_index = find(time_bins>max_diff,1);

time_bins(max_index:end) = [];
D(max_index:end) = [];
end