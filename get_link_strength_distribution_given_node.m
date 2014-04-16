function [S H] = get_link_strength_distribution_given_node(W,node)

W = decompress_adjacency_matrix(W);

N = size(W,1);
%total_frames = length(W);

%S = zeros(N,total_frames);
%H = zeros(total_frames,1);

% for t=1:total_frames
%    W = decompress_adjacency_matrix(Wframes{t});
%    
%    connectivity_profile = W(:,node);
%    
%    S(:,t) = connectivity_profile / sum(connectivity_profile);
%    
%    H(t) = get_entropy(S(:,t)','nats');
% end

connectivity_profile = W(:,node);
S = connectivity_profile / sum(connectivity_profile);
H = get_entropy(S','nats');
end