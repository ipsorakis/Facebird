function [prog prog_null_mean prog_null_std] = get_progression_output_struct(OUTPUT_STRUCT,adjacency_used,x,y)

frames = length(OUTPUT_STRUCT);

prog = zeros(frames,1);
if strcmp(adjacency_used,'W')    
    prog_null_mean = zeros(frames,1);
    prog_null_std = zeros(frames,1);
else
    prog_null_mean = nan;
    prog_null_std = nan;
end

for t=1:frames
    if strcmp(adjacency_used,'W')
        W = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes);
        Wnull_mean = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_mean);
        Wnull_std = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_std);
    elseif strcmp(adjacency_used,'Pexp')
        W = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Pframes_exp);
    elseif strcmp(adjacency_used,'Pmode')
        W = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Pframes_mode);
    end
    
    if isempty(W)
        prog(t) = 0;
        if strcmp(adjacency_used,'W')
            prog_null_mean(t) = 0;
            prog_null_std(t) = 0;
        end
    else                
        prog(t) = W(x,y);        
        if strcmp(adjacency_used,'W')            
            prog_null_mean(t) = Wnull_mean(x,y);
            prog_null_std(t) = Wnull_std(x,y);
        end
    end
end

end