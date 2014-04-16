function view_degree_distribution(Whist,day_range)

if ~exist('day_range','var')
    day_range = [1 ; size(Whist,3)];
end

for day=day_range(1):day_range(2)
    A = logical(Whist(:,:,day));
    k = sum(A);
    
    bar(histc(k,1:max(k)));
    pause;
end


end