function [wijt xijt] = get_i_j_cooccurrences(output,Xframes,i,j,sign_test_flag)

if j<i
    [i j] = swap_values(i,j);
end

if ~exist('sign_test_flag','var')
    sign_test_flag = false;
end

T = length(output);
wijt = zeros(T,1);
xijt = zeros(T,1);

for t=1:T
    xi = Xframes(i,t);
    xj = Xframes(j,t);
    xijt(t) = min(xi,xj);
    
    if ~(xi==0 && xj==0)
        if ~sign_test_flag
            wijt(t) = output(t).Wframes_before_sign_test(i,j);
        else
            wijt(t) = output(t).Wframes(i,j);
        end
    else
        wijt(t) = nan;
    end
end

end