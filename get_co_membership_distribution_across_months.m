function d = get_co_membership_distribution_across_months(Cframes,C,month_indices_in_days,pair_indices,threshold)

if ~exist('threshold','var')
    threshold = 1;
end

total_months = length(month_indices_in_days);
N = size(Cframes{1},1);

total_pairs = size(pair_indices,1);

active = false(total_pairs,1);
for i=1:total_pairs
    active(i) = C(pair_indices(i,1),pair_indices(i,2))>=threshold;
end
pair_indices(~active,:) = [];
total_pairs = size(pair_indices,1);

d = zeros(total_pairs,total_months);

for month_index = 1:total_months
    
    Cmonth = zeros(N);
    for day_index = month_indices_in_days{month_index}(1):month_indices_in_days{month_index}(2)
        Ctemp = decompress_adjacency_matrix(Cframes{day_index});
        if ~isempty(Ctemp)
            Cmonth = Cmonth + Ctemp;
        end
    end
    
    for i=1:total_pairs
        x = pair_indices(i,1);
        y = pair_indices(i,2);
        
        d(i,month_index) = Cmonth(x,y)/C(x,y);
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