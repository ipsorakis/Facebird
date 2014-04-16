function [accuracy are_pairs] = are_groups_pairs(BIRDS,PEDIGREE,groups,year)
n = length(groups);
are_pairs = zeros(n,1);
iterator = 0;

for i=1:n
    if length(groups{i})==2
        iterator = iterator+1;
        x = groups{i}(1);
        y = groups{i}(2);
        are_pairs(iterator) = PEDIGREE.is_pair(BIRDS,x,y,year);
    end
end

are_pairs = are_pairs(i:iterator);
accuracy = sum(are_pairs)/iterator;
end