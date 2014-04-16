function Bframes = get_monthly_Bframes(output,month_indices)

months = 8;
Bframes = cell(8,1);
T = length(output);

N = size(output(1).Wframes,1);

for m=1:months
    start_month = month_indices{m}(1);
    end_month = month_indices{m}(2);
    
    B = [];
    for t=start_month:end_month
        Bt = full(output(t).Bframes);
        B=[B;Bt];
    end
    
    Bframes{m} = sparse(B);
end

end