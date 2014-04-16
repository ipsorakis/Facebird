function C = build_copulation_network(BIRDS_DATABASE,PEDIGREE)

N = BIRDS_DATABASE.birds_number;
year = BIRDS_DATABASE.timestamp+1;

C = zeros(N);

for i=1:N-1
    for j=i+1:N
        C = PEDIGREE.is_pair(BIRDS_DATABASE,i,j,year);
    end
end

C = C + C';


end