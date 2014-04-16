function DA = get_monthly_dispersal_assortativity(Aframes,D)

months = length(Aframes);
DA = zeros(months,1);

for m=1:months
    A = decompress_adjacency_matrix(Aframes{m});
    
    active = sum(A)~=0;
    
    A=A(active,active);
    
    DA(m) = get_assortativity_given_x(A,D(active));
end

end