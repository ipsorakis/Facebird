function view_strength_distribution(Whist,day_range)

if ~exist('day_range','var')
    day_range = [1 ; size(Whist,3)];
end

for day=day_range(1):day_range(2)
    A = (Whist(:,:,day));
    s= sum(A);
    
    bar(histc(s,1:max(s)));
    pause;
end


end