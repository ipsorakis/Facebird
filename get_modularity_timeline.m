function Qhist = get_modularity_timeline(Whist,COMMUNITIES)

total_days = length(COMMUNITIES);
Qhist = zeros(total_days,1);

for day=1:total_days
%    try
    active = find(sum(Whist(:,:,day))~=0);
    if ~isempty(active)
        IM = index_manager(active);
        W = Whist(:,:,day);
        g = COMMUNITIES{day};
        
        for c=1:length(g)
            g{c} = IM.get_relative_index(g{c});
        end
        
        Qhist(day) = get_modularity(g,W(active,active));
    end
%     catch ME
%         ME.stack
%     end
end

end