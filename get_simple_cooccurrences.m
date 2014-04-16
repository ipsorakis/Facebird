function [A, Bcon, As] = get_simple_cooccurrences(output,ACTIVE,sign_test)

if nargin<3
    sign_test = false;
end

T = length(output);

N = size(output(1).Wframes);

A = cell(T,1);
Bcon = cell(T,1);

if sign_test
    As = cell(T,1);
else
    As = nan;
end

for t=1:T
    t
    active = ACTIVE{t};
    
    B = full(cat(1,output(t).Bframes{:}));
    
    B_rel = B(:,active);
    
    Aloc_rel = get_coocurences_in_bipartite_graph(B_rel);
    
    
    if sign_test
        Asloc_rel = do_significance_test_of_adjancency_given_indidence_matrix(Aloc_rel,B_rel,.05,1000);
    end
    
    Bcon{t} = sparse(B);
    
    Aloc = zeros(N);
    Aloc(active,active) = Aloc_rel;
    A{t} = compress_adjacency_matrix(Aloc);
    
    if sign_test
        Asloc = zeros(N);
        Asloc(active,active) = Asloc_rel;
        As{t} = compress_adjacency_matrix(Asloc);
    end
end

end