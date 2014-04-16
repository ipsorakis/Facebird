function GA = get_monthly_gender_assortativity(Aframes,G)

months = length(Aframes);
GA = zeros(months,1);

for m=1:months
    A = decompress_adjacency_matrix(Aframes{m});
    
    active = and(transpose(sum(A)~=0),G~=-1);   
    
    A=A(active,active);
    
    GA(m) = get_assortativity_given_x(A,G(active));
end

end