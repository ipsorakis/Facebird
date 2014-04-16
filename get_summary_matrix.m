function Wsum = get_summary_matrix(OUTPUT_STRUCT,adjacency_used)

if nargin<2
    adjacency_used = 'W';
end

total_frames = length(OUTPUT_STRUCT);
N = size(OUTPUT_STRUCT(1).Wframes,1);

Wsum = zeros(N);

parfor t=1:total_frames
    if strcmp(adjacency_used,'W')
        Wt = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes);
    elseif strcmp(adjacency_used,'Wnull')
        Wt = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_mean);
    end
    
    Wt(isnan(Wt))=0;
    Wsum = Wsum + Wt;
end

Wsum = compress_adjacency_matrix(Wsum);
end