% X,Y: TxD
function [R C] = get_arrival_correlation(X,Y)

D = size(X,2);
T = size(X,1);

Xmean = mean(X);
Ymean = mean(Y);

Xaux = X - repmat(Xmean,T,1);
Yaux = (Y - repmat(Ymean,T,1))';

C = Xaux*Yaux;

sigmas = diag(diag(C).^-.5);

R = sigmas*C*sigmas;

end