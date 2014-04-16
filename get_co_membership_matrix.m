function [C Cframes COMMUNITIES]= get_co_membership_matrix(OUTPUT_STRUCT,adjacency_used)

if nargin<2
    adjacency_used = 'W';
end

total_frames = length(OUTPUT_STRUCT);

N = size(OUTPUT_STRUCT(1).Wframes,1);
C = zeros(N);

Cframes = cell(total_frames,1);
COMMUNITIES = cell(total_frames,1);

parfor t=1:total_frames
    
    if strcmp(adjacency_used,'W')
        Wcurrent_frame = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes);
    elseif strcmp(adjacency_used,'Pexp')
        Wcurrent_frame = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Pframes_exp);
    elseif strcmp(adjacency_used,'Pmode')
        Wcurrent_frame = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Pframes_mode);
    elseif strcmp(adjacency_used,'Wnull')
        Wcurrent_frame = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_mean);
    elseif strcmp(adjacency_used,'Wfull')
        Wcurrent_frame = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_before_sign_test);
    end
    Wcurrent_frame(isnan(Wcurrent_frame)) = 0;
    
    active_indices = sum(Wcurrent_frame)~=0;
    number_of_active = sum(active_indices);
    aux_indices = find(active_indices);
    IM = index_manager(aux_indices);
    
    if number_of_active < 2
        continue;
    end
    
    %     inactive_indices = find(~active_indices);
    %     number_of_inactive = N - number_of_active;
    %     INDEX_MANAGER = index_manager(find(active_indices));
    
    W = Wcurrent_frame(active_indices,active_indices);
    
    g = louvain(W);
    
    P = group_to_incidence_matrix(g);
    number_of_communities = length(g);
    
    %     [P g] = commDetNMF(W);
    %     number_of_communities = size(P,2);
    
    
    B = zeros(N,number_of_communities);
    B(active_indices,:) = P;
    
    %     for i=1:number_of_communities
    %        g{i} = INDEX_MANAGER.get_original_index(g{i});
    %     end
    %
    %     group_index = number_of_communities+1;
    %     for i=1:number_of_inactive
    %         g{group_index} = inactive_indices(i);
    %         group_index = group_index+1;
    %     end
    
    Ccurrent_frame = B*B';
    C = C + Ccurrent_frame;
    Cframes{t} = compress_adjacency_matrix(Ccurrent_frame);
    
    for c=1:length(g)
        g{c} = IM.get_original_index(g{c});
    end
    
    COMMUNITIES{t} = g;
    
end

C = compress_adjacency_matrix(C);
end

% if ~iscell(Wframes)
%     N = size(Wframes,1);
%     C = zeros(N);
%
%     frames = size(Wframes,3);
%     Cframes = zeros(N,N,frames);
%     COMMUNITIES = cell(frames,1);
%
%     parfor t=1:frames
%         Wcurrent_frame = Wframes(:,:,t);
%         active_indices = sum(Wcurrent_frame)~=0;
%         number_of_active = sum(active_indices);
%         aux_indices = find(active_indices);
%         IM = index_manager(aux_indices);
%
%         if number_of_active < 2
%             continue;
%         end
%
%         %     inactive_indices = find(~active_indices);
%         %     number_of_inactive = N - number_of_active;
%         %     INDEX_MANAGER = index_manager(find(active_indices));
%
%         W = Wcurrent_frame(active_indices,active_indices);
%
%         W(isnan(W)) = 0;
%
%         g = louvain(W);
%
%         P = group_to_incidence_matrix(g);
%         number_of_communities = length(g);
%
%         %     [P g] = commDetNMF(W);
%         %     number_of_communities = size(P,2);
%
%
%         B = zeros(N,number_of_communities);
%         B(active_indices,:) = P;
%
%         %     for i=1:number_of_communities
%         %        g{i} = INDEX_MANAGER.get_original_index(g{i});
%         %     end
%         %
%         %     group_index = number_of_communities+1;
%         %     for i=1:number_of_inactive
%         %         g{group_index} = inactive_indices(i);
%         %         group_index = group_index+1;
%         %     end
%
%         Ct = B*B';
%         Cframes(:,:,t) = Ct - diag(diag(Ct));
%
%         C = C + Cframes(:,:,t);
%
%         for c=1:length(g)
%             g{c} = IM.get_original_index(g{c});
%         end
%
%         COMMUNITIES{t} = g;
%
%         t
%     end
% else
%     N = size(Wframes{1},1);
%     C = zeros(N);
%
%     frames = length(Wframes);
%     Cframes = zeros(N,N,frames);
%     COMMUNITIES = cell(frames,1);
%
%     for t=1:frames
%         active_indices = sum(Wframes{t})~=0;
%         number_of_active = sum(active_indices);
%
%         if number_of_active < 2
%             continue;
%         end
%
%         %     inactive_indices = find(~active_indices);
%         %     number_of_inactive = N - number_of_active;
%         %     INDEX_MANAGER = index_manager(find(active_indices));
%
%         W = full(Wframes{t}(active_indices,active_indices));
%         W(isnan(W)) = 0;
%
%         g = louvain(W);
%
%         P = group_to_incidence_matrix(g);
%         number_of_communities = length(g);
%
%         %     [P g] = commDetNMF(W);
%         %     number_of_communities = size(P,2);
%
%
%         B = zeros(N,number_of_communities);
%         B(active_indices,:) = P;
%
%         %     for i=1:number_of_communities
%         %        g{i} = INDEX_MANAGER.get_original_index(g{i});
%         %     end
%         %
%         %     group_index = number_of_communities+1;
%         %     for i=1:number_of_inactive
%         %         g{group_index} = inactive_indices(i);
%         %         group_index = group_index+1;
%         %     end
%
%         Ct = B*B';
%         Cframes(:,:,t) = Ct - diag(diag(Ct));
%
%         C = C + Cframes(:,:,t);
%
%         for c=1:length(g)
%             g{c} = IM.get_original_index(g{c});
%         end
%
%         COMMUNITIES{t} = g;
%
%         t
%     end
%
% end