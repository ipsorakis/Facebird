function [W_significant network_load components] = prune_insignificant_links(W_observed,W_ALL,X_hist,alpha)
Wsize = size(W_observed);

days = Wsize(3);
N = Wsize(1);
simulations = length(W_ALL);

W_significant = zeros(Wsize);
network_load = zeros(days,1);
components = zeros(days,1);

for day=1:days
    
    %% LINK-SPECIFIC OPERATIONS
    for i=1:N-1
        for j=i+1:N
            sims = zeros(simulations);
            for s=1:simulations
                Waux = W_ALL{s};
                sims(s) = Waux(i,j,day);
            end            
            p = length(find(sims>=W_observed(i,j,day)))/length(sims);
            if p<=alpha
                W_significant(i,j,day) = W_observed(i,j,day);
                W_significant(j,i,day) = W_observed(i,j,day);
            end
        end
    end
    
    %% GLOBAL OPERATIONS
    active_birds = X_hist(:,day)~=0;
    N_active = sum(active_birds);
    
    network_load(day) = sum(sum(W_significant(active_birds,active_birds,day))) / (N_active*(N_active-1));
    components(day) = number_of_components_network(W_significant(active_birds,active_birds,day));
end

end