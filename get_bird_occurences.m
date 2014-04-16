function [Occs unique_time_slots] = get_bird_occurences...
    (DATA,BIRDS,LOCATIONS,time_window,start_obs,end_obs)
%% INITIALISATIONS

observations = size(DATA,1);
if ~exist('start_obs','var') || ~exist('end_obs','var') || start_obs==-1 || end_obs==-1
    start_obs = 1;
    end_obs = observations;
end

if ~exist('time_window','var')
    time_window = 60;
end

DATA_chunk = DATA(start_obs:end_obs,:);
index_span = length(start_obs:end_obs);

total_birds = BIRDS.birds_number;
total_locations = LOCATIONS.number_of_active_locations;

DATA_chunk(:,1) = ceil(DATA_chunk(:,1)/time_window);
unique_time_slots = unique(DATA_chunk(:,1));

%DATA_chunk(:,1) = DATA_chunk(:,1) - DATA_chunk(1,1) + 1;

%% BUILD OCCURENCES
% dimensionality: bird_number X number_of_time_slots X number_of_locations

Occs = cell(1,total_locations);
for i=1:total_locations
    Occs{i} = sparse(total_birds,length(unique_time_slots));
end


current_time_slot_index = 1;
prev_time_slot = DATA_chunk(1,1);

for i=1:index_span
    current_time_slot = DATA_chunk(i,1);
    if current_time_slot ~= prev_time_slot
        current_time_slot_index = current_time_slot_index+1;
    end
    
    Occs{DATA_chunk(i,3)}(DATA_chunk(i,2),current_time_slot_index) = Occs{DATA_chunk(i,3)}(DATA_chunk(i,2),current_time_slot_index) + 1;
    
    prev_time_slot = current_time_slot;
end

end