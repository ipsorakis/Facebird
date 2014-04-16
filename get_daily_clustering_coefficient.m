function CC = get_daily_clustering_coefficient(output,ACTIVE)

T = length(output);

CC = zeros(T,1);

for t=1:T
   At = decompress_adjacency_matrix(output(t).Wframes);
   
   A = sparse(At(ACTIVE{t},ACTIVE{t}));
   
   CC(t) = mean(clustering_coefficients(A));
end

end