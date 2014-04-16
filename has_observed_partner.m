function h = has_observed_partner(n,BIRDS_DATABASE,PEDIGREE)

N = length(n);

h = false(N,1);

for i=1:N
    current_year_partner = PEDIGREE.get_partner_by_index(BIRDS_DATABASE,n(i),BIRDS_DATABASE.timestamp+1);    
    h(i) = h(i) || (~isempty(current_year_partner) && ~isempty(BIRDS_DATABASE.get_bird_by_ID(current_year_partner)));
    
    last_year_partner = PEDIGREE.get_partner_by_index(BIRDS_DATABASE,n(i),BIRDS_DATABASE.timestamp);    
    h(i) = h(i) || (~isempty(last_year_partner) && ~isempty(BIRDS_DATABASE.get_bird_by_ID(last_year_partner)));    
end
end