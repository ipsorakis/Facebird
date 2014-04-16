function path = get_pair_shortest_path(Wframes,x,y)

T = size(Wframes,3);
%N = size(Wframes,1);

path = zeros(T,1);

for t=1:T
    if sum(Wframes(x,:,t))~=0
        d = weighted_shortest_paths(Wframes(:,:,t),x);
        path(t) = d(y);
    else
        path(t) = inf;
    end
end

end