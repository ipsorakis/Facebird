function OA = get_monthly_occurrence_assortativity(Aframes,Occ)

months = length(Aframes);
OA = zeros(months,1);

for m=1:months
    A = decompress_adjacency_matrix(Aframes{m});
    
    active = sum(A)~=0;
    
    A=A(active,active);
    
    OA(m) = get_assortativity_given_x(A,Occ(active));
end

end