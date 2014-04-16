function [X Y arrival_timestamps] = get_arrival_vectors(DATA,x,y,time_interval)

total_observations = size(DATA,1);
total_locations = max(DATA(:,3));

DATA(:,1) = ceil(DATA(:,1)/time_interval);

X = zeros(1,total_locations);
Y = zeros(1,total_locations);

t = 1;
prev_t = DATA(1,1);
arrival_timestamps(1) = DATA(1,1);

for i=1:total_observations
    current_bird = DATA(i,2);
    if current_bird==x || current_bird==y
        
        if DATA(i,1)==prev_t
            record = zeros(1,total_locations);
            record(1,DATA(i,3)) = 1;
            
            if current_bird == x
                X(t,:) = X(t,:)+record;
            elseif current_bird == y
                Y(t,:) = Y(t,:)+record;
            end
        else
            t = t + 1;
            record = zeros(1,total_locations);
            record(1,DATA(i,3)) = 1;
            
            if current_bird == x
                X(t,:) = record;
                Y(t,:) = zeros(1,total_locations);
            elseif current_bird == y
                Y(t,:) = record;
                X(t,:) = zeros(1,total_locations);
            end
            
            prev_t = DATA(i,1);
            arrival_timestamps(t) = DATA(i,1);
        end
    end
end
end