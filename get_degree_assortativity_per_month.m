function DAG = get_degree_assortativity_per_month(Aframes,ACTIVE)

months = length(Aframes);

DAG = zeros(months,1);

for m=1:months
   A = decompress_adjacency_matrix(Aframes{m});
   
   A = A(ACTIVE{m},ACTIVE{m});
   
   DAG(m) = assortativity(A);
   
end

end