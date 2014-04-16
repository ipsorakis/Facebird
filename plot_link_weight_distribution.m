function plot_link_weight_distribution(W_ALL,i,j,day,observed)
no_sims = length(W_ALL);
sims = zeros(no_sims,1);

for s=1:no_sims
    Waux = W_ALL{s};
    sims(s) = Waux(i,j,day);
end

hist(sims);

if exist('observed','var')
    observed
    length(find(sims>=observed))/length(sims)
    vline(observed,'--r');
end
end