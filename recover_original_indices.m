function g = recover_original_indices(groups,active)
n = length(groups);
original = find(active);
g = cell(n,1);

for i=1:n
    g{i} = original(groups{i});
end
end