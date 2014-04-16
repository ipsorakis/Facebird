function [DH, avgDH] = get_dispersal_entropy(DATA,N)

if nargin<2
    N = length(unique(DATA(:,2)));
end

TOTAL_LOCS = 67;

DH = zeros(N,1);

for i=1:N
    LOCS_i = DATA(DATA(:,2)==i,3);
    
    if ~isempty(LOCS_i)
        histogram = histc(LOCS_i,1:TOTAL_LOCS);
        
        distribution = histogram/sum(histogram);
        
        if ~isrow(distribution)
            distribution = distribution';
        end
        
        DH(i) = get_entropy(distribution);
    else
        DH(i) = nan;
    end    
end

avgDH = mean(DH(~isnan(DH)));

end