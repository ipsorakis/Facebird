function [Wframes Wsum] = build_feeder_network(DATA)

day_indices = get_day_indices(DATA);
total_days = length(day_indices);
DATA_per_day = cell(total_days,1);
for t=1:total_days
    DATA_per_day{t} = DATA(day_indices{t}(1):day_indices{t}(2),:);
end

total_feeders = length(unique(DATA(:,3)));
Wframes = cell(total_days,1);
Wsum = zeros(total_feeders);

fprintf('\n');
parfor t=1:total_days
    index_sets = cell(total_feeders,1);
    W = zeros(total_feeders);
    DATA_day = DATA_per_day{t};
    
    for f=1:total_feeders
       index_sets{f} = DATA_day(DATA_day(:,3)==f,2); 
    end
    
    for i=1:total_feeders-1
        for j=i+1:total_feeders
            W(i,j) = length(intersect(index_sets{i},index_sets{j}));
        end
    end
    
    Wframes{t} = sparse(W);
    Wsum = Wsum + W;
    
    fprintf('%d, ',t);
end

Wsum = sparse(Wsum);
fprintf('\n');
end

% rolling_window unit of measure = day
%
% %% INITIALIZE
% load(datafilename);
% 
% day_timestamps = ceil((unique_time_slots*time_interval_length)/(60*24));
% 
% start_index = 1;
% frame = 0;
% 
% Whist = zeros(total_locations,total_locations,1);
% Xhist_visitor_indices = cell(total_locations,1);
% Xhist_number_of_visitors = zeros(total_locations,1);
% 
% stop_next=false;
% while ~stop_next
%     frame = frame+1;
%     %% EVALUATE END INDICES
%     start_time = day_timestamps(start_index);
%     
%     end_index = find(day_timestamps>start_time+rolling_window-1,1)-1;
%     if isempty(end_index)
%         end_index = length(day_timestamps);
%         stop_next=true;
%     end
%     %end_time = day_timestamps(end_index);
%     
%     %% BUILD WEIGHT MATRIX
%     [W Xvisitors Xnumber_of_visitors] = build_feeder_weights_matrix(Occs,start_index,end_index);
%     Whist(:,:,frame) = W;
%     Xhist_visitor_indices(:,frame) = Xvisitors;
%     Xhist_number_of_visitors(:,frame) = Xnumber_of_visitors;
%     %% EVALUATE START INDICES
%     start_index = find(day_timestamps>start_time+increment_step-1,1);
% end
% %% FINALIZE AND SAVE
% if exist('save_flag','var') && save_flag
%     save(strcat('temporal_',datafilename));
% end
% end
% 
% function [W X_indices X_num] = build_feeder_weights_matrix(Occs,start_index,end_index)
% if ~iscell(Occs)
%     Occs = {Occs};
% end
% 
% % if ~exist('start_index','var')
% %     start_index = 1;
% % end
% % 
% % if ~exist('end_index','var')
% %     end_index = size(Occs{1});
% %     end_index = end_index(2);
% % end
% 
% total_locations = length(Occs);
% 
% % weights matrix
% W = zeros(total_locations);
% 
% % absolute bird appearances
% X_indices = cell(total_locations,1);
% X_num = zeros(total_locations,1);
% 
% for location_index=1:total_locations
%    X_indices{location_index} = find(sum(Occs{location_index}(:,start_index:end_index),2));   
%    X_num(location_index) = length(X_indices{location_index});
% end
% 
% for i=1:total_locations-1
%     for j=i+1:total_locations
%         W(i,j) = length(intersect(X_indices{i},X_indices{j}));
%         W(j,i) = W(i,j);
%     end
% end
% 
% end