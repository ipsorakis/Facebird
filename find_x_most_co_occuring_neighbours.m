function [CO includes_partner] = find_x_most_co_occuring_neighbours(W,x,BIRDS_DATABASE,PEDIGREE_GLOBAL)

W = decompress_adjacency_matrix(W);

N = size(W,1);

CO = cell(N,1);
includes_partner = false(N,1);

parfor i=1:N
    %% find most connected
    connectivity_profile = W(:,i);
    neighbours = connectivity_profile~=0;
    if sum(neighbours)<2
        continue;
    end
    
    IM_i = index_manager(find(neighbours));
    
    connectivity_profile(~neighbours)=[];
    
    weight_values_sorted = sort(connectivity_profile);
    pivot = round((1-x)*length(weight_values_sorted));
    v = weight_values_sorted(pivot);
    
    %connectivity_histogram = histc(connectivity_profile,weight_value_range);    
    %weight_distribution = connectivity_histogram/sum(connectivity_histogram);
    
    
    %v = find_largest_x_percent_values_in_distribution(weight_distribution,weight_value_range,x);
    
    strongly_connected_neighbours = find(connectivity_profile>=v);
    strongly_connected_neighbours = IM_i.get_original_index(strongly_connected_neighbours);
    CO{i} = strongly_connected_neighbours;
    
    %% study characteristics
    PEDIGREE = PEDIGREE_GLOBAL;
    K = length(strongly_connected_neighbours);
    has_partner = false;
    for k=1:K
        has_partner = has_partner || ...
            PEDIGREE.is_pair_by_index(BIRDS_DATABASE,i,strongly_connected_neighbours(k),BIRDS_DATABASE.timestamp+1) ||...
            PEDIGREE.is_pair_by_index(BIRDS_DATABASE,i,strongly_connected_neighbours(k),BIRDS_DATABASE.timestamp);
    end
    
    includes_partner(i) = has_partner;
end



end