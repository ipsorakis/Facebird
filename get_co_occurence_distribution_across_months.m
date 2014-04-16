function d = get_co_occurence_distribution_across_months(OUTPUT_STRUCT,Wsum,month_indices_in_days,pair_indices,do_null,threshold)

if ~exist('do_null','var')
   do_null = false; 
end

if ~exist('threshold','var')
    threshold = 25;
end

total_months = length(month_indices_in_days);
N = size(OUTPUT_STRUCT(1).Wframes,1);

total_pairs = size(pair_indices,1);

active = false(total_pairs,1);
for i=1:total_pairs
    active(i) = Wsum(pair_indices(i,1),pair_indices(i,2))>=threshold;
end
pair_indices(~active,:) = [];
total_pairs = size(pair_indices,1);

d = zeros(total_pairs,total_months);

for month_index = 1:total_months
    
    Wmonth = zeros(N);
    for day_index = month_indices_in_days{month_index}(1):month_indices_in_days{month_index}(2)
        if do_null
            Wmonth = Wmonth + decompress_adjacency_matrix(OUTPUT_STRUCT(day_index).Wframes_null_mean);
        else            
            Wmonth = Wmonth + decompress_adjacency_matrix(OUTPUT_STRUCT(day_index).Wframes);
        end
    end
        
    for i=1:total_pairs
        x = pair_indices(i,1);
        y = pair_indices(i,2);
        
        d(i,month_index) = Wmonth(x,y)/Wsum(x,y);
    end
    %d(month_index) = d(month_index)/total_pairs;
end


% active = false(total_pairs,1);
% for i=1:total_pairs
%     active(i) = sum(d(i,:)==0)<total_months-2;
% end
% 
% d(~active,:) = [];
end