function COMM_STATS = get_monthly_community_stats(output,Aframes_monthly,DATA,ACTIVE,...
    month_indices_in_DATA,month_indices_in_days,randomisations)

months = 8;
days = length(output);

T = length(output);

Q = zeros(randomisations,T);
Q_NULL = zeros(randomisations,T);

NMI = zeros(randomisations,T);

C = zeros(randomisations,T);
C_NULL = zeros(randomisations,T);


N = size(Aframes_monthly{1},1);

for m=1:months
    m
    %% OBSERVED FEATURES
    start_month = month_indices_in_DATA{m}(1);
    end_month = month_indices_in_DATA{m}(2);
    
    DATAm = DATA(start_month:end_month,:);
    
    Occ_m = histc(DATAm(:,2),1:N);
    active_m = Occ_m~=0;
    IM = index_manager(find(active_m));
    
    %% OBSERVED MATRICES
    Am = decompress_adjacency_matrix(Aframes_monthly{m});
    
    start_month = month_indices_in_days{m}(1);
    end_month = month_indices_in_days{m}(2);
    days_in_current_month = start_month:end_month;
    number_days_in_current_month = end_month-start_month-1;
    Bm = cell(number_days_in_current_month,1);
    i=0;
    for mu=start_month:end_month
        i=i+1;
        Baux = full(output(mu).Bframes);
        if isempty(Baux)
            continue
        end
        Bm{i} = Baux(:,active_m);
    end
    
    A = Am(active_m,active_m);
    %% NULL MATRICES
    parfor r=1:randomisations
        Bnull = [];
        for d=1:number_days_in_current_month
            day_index = days_in_current_month(d);
            Nd = length(ACTIVE{day_index});
            Bd = Bm{d};
            Kd = size(Bd,1);
            if Kd==0
                continue
            end
            for i=1:Nd
                n = IM.get_relative_index(ACTIVE{day_index}(i));
                visitation_profile = Bd(:,n);
                Bd(:,n) = visitation_profile(randperm(Kd));
            end
            Bnull = [Bnull;Bd];
        end
        
        % find Anull
        Anull = get_coocurences_in_bipartite_graph(Bnull);
        Anull(isnan(Anull)) = 0;
        
        
        if isempty(Anull) || sum(sum(Anull))==0
            continue
        end
        
        [P,g] = commDetNMF(A);
        Q(r,m) = get_modularity(g,A);
        C(r,m) = length(g);
        
        
        [Pnull,gnull] = commDetNMF(Anull);
        
        NMI(r,m) = get_partition_similarity_NMI(g,gnull);
        Q_NULL(r,m) = get_modularity(gnull,Anull);
        C_NULL(r,m) = length(gnull);
        
        
    end
end

COMM_STATS = struct('Q',Q,'Q_NULL',Q_NULL,...
    'NMI',NMI,...
    'C',C,'C_NULL',C_NULL);
end

function W = get_coocurences_in_bipartite_graph(B)

B = 1*logical(B);
W = B'*B;
W = W - diag(diag(W));
end