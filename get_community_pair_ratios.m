function R = get_community_pair_ratios(COMMUNITIES,BIRDS_DATABASE,PEDIGREE_GLOBAL)

total_days = length(COMMUNITIES);
current_year = BIRDS_DATABASE.timestamp+1;

R = zeros(total_days,1);

fprintf('frame: ');
parfor day=1:total_days
    PEDIGREE = PEDIGREE_GLOBAL;
    fprintf('%d, ',day);
    g = COMMUNITIES{day};
    C = length(g);
    
    pair_ratio_per_community = zeros(C,1);
    non_singleton_community_index = 0;
    for c=1:C
        current_group = g{c};
        K = length(current_group);
        if K>1
            non_singleton_community_index = non_singleton_community_index + 1;
            % no of possible pairs
            if mod(K,2) == 0
                possible_pairs = K/2;
            else
                possible_pairs = (K-1)/2;
            end
            mated_pairs = 0;
            
            for i=1:K-1
                for j=i+1:K
                    mated_pairs = mated_pairs + ...
                        (PEDIGREE.is_pair_by_index(BIRDS_DATABASE,current_group(i),current_group(j),current_year)...
                        || PEDIGREE.is_pair_by_index(BIRDS_DATABASE,current_group(i),current_group(j),current_year-1)); %% see previous year too
                end
            end
            
            pair_ratio_per_community(non_singleton_community_index) = mated_pairs/possible_pairs;
        end
    end
    
    pair_ratio_per_community = pair_ratio_per_community(1:non_singleton_community_index);
        
    R(day) = mean(pair_ratio_per_community);
end
fprintf('\n');
end