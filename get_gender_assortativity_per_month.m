function GAS = get_gender_assortativity_per_month(Aframes,GENDERS)
birds_with_known_gender = GENDERS~=-1;
months = length(Aframes);

GAS = zeros(months,1);

for m=1:months
   A = decompress_adjacency_matrix(Aframes{m});
   
   active_birds = sum(A)~=0;
   
   appearing_bird_set = and(active_birds',birds_with_known_gender);
   
   A = A(appearing_bird_set,appearing_bird_set);
   
   GAS(m) = get_assortativity_given_x(A,GENDERS(appearing_bird_set));
   
end

end