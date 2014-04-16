function [DATA, cluster_boundaries] = create_data_stream_given_graph2(A,P_dt,dt,Z,Tg)
% MAX_RECORDS: maximum data stream size

N = size(A,1);
%A = A + eye(N);

DATA = ones(Z,2);
cluster_boundaries = zeros(Z-1,1);

PL_tail = find(dt>Tg,1)-1;

t=1;
z=1;

degrees = sum(A);

ref_node = draw_sample_given_distribution(degrees,1:N,1);
ref_node_adjacency_profile = A(:,ref_node);
%random_walk_allowed_nodes_vector = ref_node_adjacency_profile~=0;
%random_walk_allowed_nodes_set = find(random_walk_allowed_nodes_vector);

random_walk_nodes_visited = false(N,1);
random_walk_nodes_visited(ref_node) = true;

DATA(z,:) = [t,ref_node];

jump_k = false;

while z<Z
    z = z + 1;
    if jump_k
        dtz = ceil(draw_sample_given_distribution(P_dt(PL_tail:end),dt(PL_tail:end),1));
        cluster_boundaries(z) = 1;
    else
        dtz = ceil(draw_sample_given_distribution(P_dt,dt,1));        
    end
    t = t + dtz;
    
    if dtz < Tg
        Pjump = ref_node_adjacency_profile/sum(ref_node_adjacency_profile);
        
        next_node = draw_sample_given_distribution(Pjump,1:N,1);
        
        DATA(z,:) = [t,next_node];
        
        random_walk_nodes_visited(next_node) = true;
        
        next_node_adjacency_profile = A(:,next_node).*A(:,ref_node).*(~random_walk_nodes_visited);
        random_walk_allowed_nodes_vector = next_node_adjacency_profile~=0;
        
        % >>>> check if all visited <<<<
        if sum(random_walk_allowed_nodes_vector) == 0
            % if yes
            jump_k = true;
        else
            % if not
            ref_node = next_node;
            ref_node_adjacency_profile = next_node_adjacency_profile;
        end
    else
        ref_node = draw_sample_given_distribution(degrees,1:N,1);
        ref_node_adjacency_profile = A(:,ref_node);
        random_walk_nodes_visited = false(N,1);random_walk_nodes_visited(ref_node) = true;
        
        DATA(z,:) = [t,ref_node];
        jump_k = false;
    end
end

DATA = [DATA,ones(Z,1)];
cluster_boundaries = sparse(cluster_boundaries);
end

%%
% stop_criterion = false;
% while ~stop_criterion
%     %% select a random community
%     %     current_community = floor(1+rand(1)*C);
%     %     nodes_in_current_community = g{current_community};
%     %     %Csize = length(nodes_in_current_community);
%
%     %% Pi: probability of picking a node, based on either a) its degree b) uniform
%     % a)
%     %degrees = sum(A);
%     %Pi = degrees/sum(degrees);
%     % b)
%     Pi = ones(N,1)/N;
%
%     %% pick a random node from current_community based on Pi
%     ref_node = draw_sample_given_distribution(Pi,1:N);
%     if A(ref_node,ref_node) == 0
%         A(ref_node,ref_node) = mean(A(:,ref_node));
%     end
%
%     visited(ref_node) = 1;
%
%     partner_node = ref_node;
%
%     DATA(record_index,1) = t;
%     DATA(record_index,2) = ref_node;
%
%     t=t+1;
%     record_index = record_index+1;
%
%     cluster_size = poissrnd(mean_cluster_size-2)+2;
%     for c = 1:cluster_size
%         if partner_node == ref_node
%             % identify neighbours (including self)
%             neighbours = A(ref_node,:)~=0;
%             neighbour_indices = find(neighbours);
%             % pick a partner (or self) based on its strength
%             p_neighbour = A(ref_node,neighbours)/sum(A(ref_node,neighbours));
%             partner_node = draw_sample_given_distribution(p_neighbour,neighbour_indices);
%         else
%             % identify common neighbours
%             Ac = A(ref_node,:) .* A(partner_node,:);
%             neighbours = Ac~=0;
%             neighbour_indices = find(neighbours);
%             % pick a partner (or self) based on its strength
%             p_neighbour = Ac(neighbours)/sum(Ac);
%             partner_node = draw_sample_given_distribution(p_neighbour,neighbour_indices);
%         end
%
%         %% place the new node in the data stream
%         DATA(record_index,1) = t;
%         DATA(record_index,2) = partner_node;
%
%         visited(partner_node) = 1;
%
%         t=t+1;
%         record_index = record_index+1;
%     end
%
%     % increment time
%     t = t + poissrnd(mean_time_between_clusters);
%
%
%     %% termination criteria
%     max_iterations_limit_reached = record_index>MAX_RECORDS;
%     all_visited = sum(visited)==N;
%
%     stop_criterion = max_iterations_limit_reached && all_visited;
% end
%
% DATA = [DATA ones(size(DATA,1),1)];
% end

%% DEPRECATED CODE
% %% pick a random neighbour of that node
% ref_node_neighbours = find(A(ref_node,:));
% degree_ref_node = length(ref_node_neighbours);
% partner_node = ref_node_neighbours(floor(1+rand(1)*degree_ref_node));
% %partner_node = draw_sample_given_distribution(ones(1,degree_ref_node)/degree_ref_node,ref_node_neighbours);
%
% %% place one after the other in the data stream
% DATA(record_index,1) = t;
% DATA(record_index,2) = ref_node;
%
% t=t+1;
% record_index = record_index+1;
%
% DATA(record_index,1) = t;
% DATA(record_index,2) = partner_node;