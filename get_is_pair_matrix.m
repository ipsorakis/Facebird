function P = get_is_pair_matrix(group,BIRDS_DATABASE,PEDIGREE)

N = length(group);
P = false(N);

flagged = false(N,1);

for i=1:N-1
    for j=i+1:N
        
        if ~flagged(i) && ~flagged(j)
            x = group(i);
            y = group(j);
            
            P(i,j) = P(i,j) || PEDIGREE.is_pair_by_index(BIRDS_DATABASE,x,y,BIRDS_DATABASE.timestamp+1) ...
                || PEDIGREE.is_pair_by_index(BIRDS_DATABASE,x,y,BIRDS_DATABASE.timestamp);
            
            if P(i,j)
               flagged(i) = true;
               flagged(j) = true;
            end
        end
        
    end
end

P = P+P';
end