function [NMI pruned_intracommunity_links Qchange inactive] = compare_Wsign_vs_Wunsign(OUTPUT)

frames = length(OUTPUT);

NMI = zeros(frames,1);
pruned_intracommunity_links = zeros(frames,1);

Qchange = zeros(frames,1);

for frame_index=1:frames
    frame_index
    
    Ws = decompress_adjacency_matrix(OUTPUT(frame_index).Wframes);
    Wu = decompress_adjacency_matrix(OUTPUT(frame_index).Wframes_before_sign_test);
    
    degrees_Wu = sum(Wu);
    sumWu = sum(degrees_Wu);
    
    if ~isempty(Wu) && sumWu~=0 && sum(sum(Ws))==0
        NMI(frame_index) = 0;
        pruned_intracommunity_links(frame_index) = 1;
    elseif isempty(Wu) || sumWu ==0
        NMI(frame_index) = nan;
        pruned_intracommunity_links(frame_index) = nan;
    else
        active_nodes = degrees_Wu~=0;
        
        Ws = Ws(active_nodes,active_nodes);
        Wu = Wu(active_nodes,active_nodes);
        N = size(Wu,1);
        
        
        PRUNED_LINKS = (Ws==0) .* (Wu~=0);
        num_pruned_links = sum(sum(PRUNED_LINKS));
        
        %
        %active_nodes_s = sum(Ws)~=0;
        %active_nodes_s_indices = find(active_nodes_s);
        
        %IM = index_manager(active_nodes_s_indices);
        
        %
        %Ws_active_of_s = Ws(active_nodes_s,active_nodes_s);
        %Wu_active_of_s = Wu(active_nodes_s,active_nodes_s);
        
        %gs = louvain(Ws_active_of_s);
        %gu = louvain(Wu_active_of_s);
        
        
        gu = louvain(Wu);
        Qu = get_modularity(gu,Wu);
        
        
        gs = louvain(Ws);        
        
        
        % local Ws community structure
        active_nodes_s = sum(Ws)~=0;        
        Ws_s = Ws(active_nodes_s,active_nodes_s);
        gs_s = louvain(Ws_s);
        Qs = get_modularity(gs_s,Ws_s);
                
        Qchange(frame_index) = (Qs - Qu);
        
        
        %
        NMI(frame_index) = get_partition_similarity_NMI(gs,gu);
        
        %
        
        K = length(gu);
        
        %
        if num_pruned_links == 0
            pruned_intracommunity_links(frame_index) = nan;
        else
            INTRACOMMUNITY_LINKS = zeros(N);
            
            number_of_singular = 0;
            for k=1:K
                current_com = gu{k};
                if length(current_com) < 2
                    number_of_singular = number_of_singular+1;
                    continue
                else
                    INTRACOMMUNITY_LINKS(current_com,current_com) = logical(Wu(current_com,current_com));
                end
            end
            
            if number_of_singular ==K
                pruned_intracommunity_links(frame_index) = nan;
            else
                PRUNED_INTRACOMMUNITY_LINKS = INTRACOMMUNITY_LINKS.*PRUNED_LINKS;
                num_pruned_intracommunity_links = sum(sum(PRUNED_INTRACOMMUNITY_LINKS));
            end
            
            pruned_intracommunity_links(frame_index) = num_pruned_intracommunity_links/num_pruned_links;
        end
    end
end


inactive = logical(isnan(pruned_intracommunity_links) + (pruned_intracommunity_links==1));
end