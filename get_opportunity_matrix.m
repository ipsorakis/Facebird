function Opportunity_matrix = get_opportunity_matrix(X,opportunity_function)

N = length(X);
Opportunity_matrix = zeros(N);

for i=1:N-1
    for j=i+1:N
        Opportunity_matrix(i,j) = opportunity_function(X(i),X(j));
    end
end
Opportunity_matrix = Opportunity_matrix + Opportunity_matrix';

end