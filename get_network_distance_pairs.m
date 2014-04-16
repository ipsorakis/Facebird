function pathlengths = get_network_distance_pairs(pairs,OUTPUT,Cframes)

frames = length(OUTPUT);
num_pairs = size(pairs,1);

pathlengths = zeros(frames*num_pairs,1);

iterator = 0;
for frame_index=1:frames
    frame_index
    
    A = 1*logical(decompress_adjacency_matrix(OUTPUT(frame_index).Wframes));
    C = 1*logical(decompress_adjacency_matrix(Cframes{frame_index}));
        
    if isempty(A) || isempty(C)
        continue;
    end
    
    for pair_index = 1:num_pairs
        x = pairs(pair_index,1);
        y = pairs(pair_index,2);
        
        if C(x,y)
            iterator = iterator+1;
            
            pathlengths(iterator) = length(find_shortest_path(A,x,y))-1;
        end
    end    
end

if iterator ~= length(pathlengths)
    pathlengths(iterator+1:end) = [];
end
end