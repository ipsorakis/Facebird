for i=1:273,weights(i)=gmm.post(i).Dir_alpha; end;
weights=weights./sum(weights);

xscale=linspace(DATA_1day(1,1),DATA_1day(2,1),1000)';

p=zeros(size(xscale),273);
for i=1:273
    gpost=gmm.post(i);
    state(i).mu=gpost.Norm_Mu;
    state(i).prec=gpost.Wish_alpha/gpost.Wish_B;
    p(:,i)=weights(i).*normpdf(xscale,state(i).mu,(state(i).prec)^-.5);
end

plot(xscale,p)