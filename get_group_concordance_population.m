function C = get_group_concordance_population(prev_groups,groups,param)
if ~exist('param','var')
    param='r';
end

p = length(prev_groups);
g = length(groups);
C = zeros(p,g);

for i=1:p
    for j=1:g
        C(i,j) = length(intersect(prev_groups{i},groups{j}));
        if strcmp(param,'r')
            C(i,j)=C(i,j)/length(prev_groups{i});
        end
    end
end
end