function PL = get_mean_predictive_likelihood(W,P)
N = size(W,1);

active_birds = sum(W,2)~=0;
PL = mean(log(max(P(active_birds,:),[],2)));
end