function Rhist = get_intracommunity_relatedness_coefficient_timeline(COMMUNITY_TIMELINE,PEDIGREE,BIRDS_DATABASE)

total_days = length(COMMUNITY_TIMELINE);
Rhist = zeros(total_days,1);

parfor day = 1:total_days
    BIRD_db_local = BIRDS_DATABASE;
    PEDIGREE_local = PEDIGREE;
    
    communities_day = COMMUNITY_TIMELINE{day};
    
    if ~isempty(communities_day)
       number_of_communities_day = length(communities_day);
       intracommunity_relatedness = 0;
       non_singleton_communities = 0;
       
       for c=1:number_of_communities_day
            curr_comm_indices = communities_day{c};
            size_curr_comm = length(curr_comm_indices);
            if size_curr_comm == 1
                continue
            else
               non_singleton_communities = non_singleton_communities + 1;
               R = zeros(size_curr_comm);
               for i=1:size_curr_comm-1
                   for j=i+1:size_curr_comm
                       bird_i_index = curr_comm_indices(i);
                       bird_j_index = curr_comm_indices(j);
                       
                       bird_i = BIRD_db_local.get_bird_by_index(bird_i_index);
                       bird_j = BIRD_db_local.get_bird_by_index(bird_j_index);
                       
                       R(i,j) = PEDIGREE_local.get_relatedness_coefficient(bird_i.ringNo,bird_j.ringNo);
                   end
               end
               
               intracommunity_relatedness = intracommunity_relatedness + mean(get_triu_vector(R));
            end
       end
       
       Rhist(day) = intracommunity_relatedness/non_singleton_communities;
    else
        Rhist(day) = nan;
    end
    
    day
end

end