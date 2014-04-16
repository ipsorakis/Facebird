function Aframes = get_monthly_adjacency_matrices(output,month_indices_in_days)

months = length(month_indices_in_days);
T = length(output);
N = size(output(1).Wframes,1);
Aframes = cell(months,1);

for m=1:months
   start_month = month_indices_in_days{m}(1); 
   end_month = month_indices_in_days{m}(2);
   
   A = zeros(N);
   for t=start_month:end_month
      A = A + decompress_adjacency_matrix(output(t).Wframes); 
   end
   
   Aframes{m} = compress_adjacency_matrix(A);
end

end