function [month_indices month_indices_in_days number_of_months] = get_month_indices(DATA,day_indices)

if ~exist('day_indices','var')
    day_indices =get_day_indices(DATA);
end

month_indices = cell(1,1);
month_indices_in_days = cell(1,1);

Z = size(DATA,1);

D = length(day_indices);

M = zeros(D,1);

for d=1:D
    timestamp = DATA(day_indices{d}(1),1);
    full_date = convert_timestamp_to_date(timestamp);
    
    M(d) = full_date(5);
end


current_month = M(1);
number_of_months = 1;
while 1
    current_month_indices = M==current_month;
    start_current_month = find(current_month_indices,1,'first');
    end_current_month = find(current_month_indices,1,'last');
    
    month_indices{number_of_months} = [day_indices{start_current_month}(1) day_indices{end_current_month}(2)];
    month_indices_in_days{number_of_months} = [start_current_month end_current_month];        
    
    if end_current_month<D
        number_of_months = number_of_months + 1;
        current_month = M(end_current_month+1);
    else
        break;
    end
end

end