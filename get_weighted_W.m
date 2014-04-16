function newW = get_weighted_W(W_history,param)
if ~exist('param','var')
    param = .1;
end

frames = size(W_history,3);
ts = frames-1:-1:0;
N = size(W_history,1);

E = zeros(size(W_history));
for i=1:length(ts)
    E(:,:,i) = repmat(ts(i),N,N);
end
E = exp(-param*E);

try
    newW = sum(W_history.* E,3);
catch ME
    newW = zeros(N,N);
    for i=1:frames
        newW = newW + W_history(:,:,i).*E(:,:,i);
    end
end
end