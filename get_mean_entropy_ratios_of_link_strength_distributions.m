function R = get_mean_entropy_ratios_of_link_strength_distributions(OUTPUT_STRUCT)

total_frames = length(OUTPUT_STRUCT);

R = zeros(total_frames,1);

for frame = 1:total_frames
    W = decompress_adjacency_matrix(OUTPUT_STRUCT(frame).Wframes);
    Wnull = decompress_adjacency_matrix(OUTPUT_STRUCT(frame).Wframes_null_mean);
    
    active_obs = sum(W)~=0;
    active_null = sum(Wnull)~=0;
    
    if sum(active_obs)<2 || sum(active_null)<2
        R(frame) = nan;
        continue;
    end
    
    W = W(active_obs,active_obs);
    Wnull = Wnull(active_null,active_null);
        
    H_obs = get_mean_entropy_of_link_strength_distribution(W);
    H_null = get_mean_entropy_of_link_strength_distribution(Wnull);
    
    if H_obs==0 && H_null==0
       R(frame) = 1;
    else
        R(frame) = H_obs/H_null;
    end   
end

end