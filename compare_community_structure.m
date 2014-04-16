function [I Q1 Q2] = compare_community_structure(W1,W2)

% if issparse(W1)
%     W1 = full(W1);
% end
% if ~is_symmetric(W1)
%     W1 = W1 + W1';
% end
% 
% if issparse(W2)
%     W2 = full(W2);
% end
% if ~is_symmetric(W2)
%     W2 = W2 + W2';
% end

W1 = decompress_adjacency_matrix(W1);
W2 = decompress_adjacency_matrix(W2);

active1 = sum(W1)~=0;
if sum(active1)<2
    I = nan;
    Q1 = nan;
    Q2 = nan;
    return;
end

active2 = sum(W2)~=0;
if sum(active2)<2
    I = nan;
    Q1 = nan;
    Q2 = nan;
    return;
end

active = or(active1,active2);

if sum(active)<2
    I = nan;
    Q1 = nan;
    Q2 = nan;
    return;
else
    
    W1 = W1(active,active);
    W2 = W2(active,active);
    
    g1 = louvain(W1);
    Q1 = get_modularity(g1,W1);
    
    g2 = louvain(W2);
    Q2 = get_modularity(g2,W2);
    
    I = get_partition_similarity_NMI(g1,g2);
    
end
end
