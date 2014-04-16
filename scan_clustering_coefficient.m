function C = scan_clustering_coefficient(Whist,year)
frame = size(Whist,3);
N = size(Whist,1);

C = zeros(frame,1);

for t=1:frame
    A = 1*(Whist(:,:,t)~=0);
    active = sum(A)~=0;
    
    [c C(t)] = get_clustering_coefficient(A(active,active));
end

plot(C);
title(strcat('Clustering coefficient for year:',num2str(year),'-',num2str(year+1)));
insert_months_graph;