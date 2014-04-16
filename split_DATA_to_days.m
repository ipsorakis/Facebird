function [DATA_DAYS, dt, dID] = split_DATA_to_days(DATA,ignore_same)
if nargin<2
    ignore_same = false;
end

day_indices = get_day_indices(DATA);

total_days = length(day_indices);

DATA_DAYS = cell(total_days,1);

dt = [];
dID = [];

for day_index=1:total_days
    DATA_DAY = DATA(day_indices{day_index}(1):day_indices{day_index}(2),:);
    
    day_locations = unique(DATA_DAY(:,3));
    total_day_locations = length(day_locations);
    
    DATA_DAYS{day_index} = cell(total_day_locations,1);
    
    for location_index = 1:total_day_locations
        current_location = day_locations(location_index);
        DATA_LOC = DATA_DAY(DATA_DAY(:,3)==current_location,:);
        DATA_DAYS{day_index}{location_index} = DATA_LOC;
        
        if size(DATA_LOC,1)>1
            dt = [dt;diff(DATA_LOC(:,1))];
            
            if ignore_same                
               dID = [dID;diff(DATA_LOC(:,2))~=0]; 
            end
        end
    end
end    

end