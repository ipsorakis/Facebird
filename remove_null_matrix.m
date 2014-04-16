function W = remove_null_matrix(Wobserved,Wnull)
    Wsize = size(Wnull);
    
if length(size(Wnull))==3
    z = Wsize(3);
else
    z=1;
end

N = Wsize(1);
W = zeros([N N z]);

for z_i=1:z
    Waux = Wobserved(:,:,z_i) - Wnull(:,:,z_i);
    
    %1. rescale
    %Wmin = min(min(Waux));
    %if Wmin<0
    %    Wmin = -1*Wmin;
    %    Waux = Waux + Wmin;
    %end     
    
    %..or..
    %2. make zero
    Waux(Waux<0) = 0;
    
    W(:,:,z_i) = Waux;
end

end