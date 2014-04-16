function [Anull_frames Anull_std_frames] = get_Anull_day_frames(output,ACTIVE,randomisations)

T = length(output);

Anull_frames = cell(T,1);
Anull_std_frames = cell(T,1);

N = size(output(1).Wframes,1);

for t=1:T
    t
    At = decompress_adjacency_matrix(output(t).Wframes);
    Bt = full(output(t).Bframes);
    
    if isempty(At) || isempty(Bt)
        Anull_frames{t} = sparse(zeros(N));
        Anull_std_frames{t} = sparse(zeros(N));
        continue
    end
    
    active_t = ACTIVE{t};
    
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