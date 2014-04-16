function [Anull_frames, Anull_std_frames] = get_Anull_month_frames(Bframes,randomisations)

T = length(Bframes);

Anull_frames = cell(T,1);
Anull_std_frames = cell(T,1);

N = size(Bframes{1},2);

for t=1:T
    t
    Bt = full(Bframes{t});
    active_t = sum(Bt)~=0;
    
    if sum(active_t)==0
        Anull_frames{t} = sparse(zeros(N));
        Anull_std_frames{t} = sparse(zeros(N));
        continue
    end
    
    At = get_coocurences_in_bipartite_graph(Bt);        
    
    A = At(active_t,active_t);
    B = Bt(:,active_t);
    
    [aux1 aux2 Anull Anull_std] = do_significance_test_of_adjancency_given_indidence_matrix(A,B,.05,randomisations);
    
    Anull_t = zeros(N);
    Anull_t(active_t,active_t) = Anull;
    
    Anull_frames{t} = compress_adjacency_matrix(Anull_t);
    
    Anull_t_std = zeros(N);
    Anull_t_std(active_t,active_t) = Anull_std;
    Anull_std_frames{t} = compress_adjacency_matrix(Anull_t_std);
end

end