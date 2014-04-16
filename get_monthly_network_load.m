function [NL, PARTICIPATION] = get_monthly_network_load(output,month_indices,ACTIVE)

DAYS = length(output);
MONTHS = length(month_indices);
N = size(output(1).Wframes,1);

NL = zeros(MONTHS,1);
PARTICIPATION = zeros(MONTHS,1);

for month=1:MONTHS
    day_start = month_indices{month}(1);
    day_end = month_indices{month}(2);
    
    A = zeros(N);
    actives = [];
    for day=day_start:day_end
        A = A + decompress_adjacency_matrix(output(day).Wframes_null_mean);
        %A = A + decompress_adjacency_matrix(output(day).Wframes);
        actives = union(actives,ACTIVE{day});
    end
    
    PARTICIPATION(month) = length(actives)/N;
    NL(month) = get_network_load(A(actives,actives));
    
end
end