function COMM_STATS = get_daily_community_stats(output,randomisations)

T = length(output);

Q = zeros(randomisations,T);
Q_NULL = zeros(randomisations,T);

NMI = zeros(randomisations,T);

C = zeros(randomisations,T);
C_NULL = zeros(randomisations,T);

%KL = zeros(randomisations,T);

for t=1:T
    t
    At = decompress_adjacency_matrix(output(t).Wframes);
    Bt = full(output(t).Bframes);
    active = sum(At)~=0;
    
    A = At(active,active);
    if sum(active)<3
        Q(:,t) = nan;
        Q_NULL(:,t) = nan;
        NMI(:,t) = nan;
        C(:,t) = nan;
        C_NULL(:,t) = nan;
        continue
    end
    
    B = Bt(:,active);
    Nm = size(A,1);
    K = size(B,1);
    
    
    parfor r=1:randomisations
        Bnull = B;
        for n=1:Nm
            visitation_profile = Bnull(:,n);
            Bnull(:,n) = visitation_profile(randperm(K));
        end
        
        % find Anull
        Anull = get_coocurences_in_bipartite_graph(Bnull);
        Anull(isnan(Anull)) = 0;
        
        [P,g] = commDetNMF(A);
        Q(r,t) = get_modularity(g,A);
        C(r,t) = length(g);
        
        if isempty(Anull) || sum(sum(Anull))==0
            NMI(r,t) = 0;
            Q_NULL(r,t) = 0;
            C_NULL(r,t) = 0;
        else
            [Pnull,gnull] = commDetNMF(Anull);
            
            NMI(r,t) = get_partition_similarity_NMI(g,gnull);
            Q_NULL(r,t) = get_modularity(gnull,Anull);
            C_NULL(r,t) = length(gnull);
        end
    end    
end

COMM_STATS = struct('Q',Q,'Q_NULL',Q_NULL,...
    'NMI',NMI,...
    'C',C,'C_NULL',C_NULL);
end