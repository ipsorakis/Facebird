function ASSORTATIVITIES = get_monthly_assortativities(output,Aframes_monthly,DATA,ACTIVE,month_indices_in_DATA,month_indices_in_days,GENDERS,randomisations)

months = 8;
days = length(output);

DEGREE = zeros(months,1);
DEGREE_NULL = zeros(months,randomisations);

STRENGTH = zeros(months,1);
STRENGTH_NULL = zeros(months,randomisations);

OCCURRENCES = zeros(months,1);
OCCURRENCES_NULL = zeros(months,randomisations);

DISPERSION = zeros(months,1);
DISPERSION_NULL = zeros(months,randomisations);

GENDER = zeros(months,1);
GENDER_NULL = zeros(months,randomisations);

Q = sparse(months,1);
Q_NULL = sparse(months,randomisations);

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
    Occ = Occ_m(active_m);
    
    GENDERS_m = GENDERS(active_m);
    
    dispersal_entropy_m = get_dispersal_entropy(DATAm,N);
    dispersal_entropy = dispersal_entropy_m(active_m);
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
    %B = Bm(:,active_m);
    Nm = size(A,1);
    %K = size(B,1);
    
    %% OBSERVED ASSORTATIVITIES
    DEGREE(m) = assortativity(A);
    STRENGTH(m) = get_assortativity_given_x(A,sum(A,2));
    OCCURRENCES(m) = get_assortativity_given_x(A,Occ);
    DISPERSION(m) = get_assortativity_given_x(A,dispersal_entropy);
    GENDER(m) = get_assortativity_given_x(A,GENDERS(active_m));
    
    %g = louvain(A);
    %Q(m) = get_modularity(g,A);
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
        % find assortativities
        DEGREE_NULL(m,r) = assortativity(Anull);
        STRENGTH_NULL(m,r) = get_assortativity_given_x(Anull,sum(Anull,2));
        OCCURRENCES_NULL(m,r) = get_assortativity_given_x(Anull,Occ);
        DISPERSION_NULL(m,r) = get_assortativity_given_x(Anull,dispersal_entropy);
        GENDER_NULL(m,r) = get_assortativity_given_x(Anull,GENDERS_m);
        
        %g = louvain(Anull);
        %Q_NULL(m,r) = get_modularity(g,Anull);
    end
end

ASSORTATIVITIES = struct('DEGREE',DEGREE,'DEGREE_NULL',DEGREE_NULL,...
    'STRENGTH',STRENGTH,'STRENGTH_NULL',STRENGTH_NULL,...
    'OCCURRENCES',OCCURRENCES,'OCCURRENCES_NULL',OCCURRENCES_NULL,...
    'DISPERSION',DISPERSION,'DISPERSION_NULL',DISPERSION_NULL,...
    'GENDER',GENDER,'GENDER_NULL',GENDER_NULL,'Q',Q,'Q_NULL',Q_NULL);
end

function W = get_coocurences_in_bipartite_graph(B)

B = 1*logical(B);
W = B'*B;
W = W - diag(diag(W));
end