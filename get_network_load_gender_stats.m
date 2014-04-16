function G = get_network_load_gender_stats(DATA,month_indices_in_DATA,BIRDS_DATABASE)

N = BIRDS_DATABASE.birds_number;

months = length(month_indices_in_DATA);

G = zeros(3,months);

for m=1:months
    month_start = month_indices_in_DATA{m}(1);
    month_end = month_indices_in_DATA{m}(2);
    
    DATA_month = DATA(month_start:month_end,:);
    
    actives = unique(DATA_month(:,2));
    Nm = length(actives);
    
    for n=1:Nm
       i = actives(n);
       
       abird = BIRDS_DATABASE.get_bird_by_index(i);
       %abird.gender
       if abird.gender == 'M'
          G(3,m) =  G(3,m) + 1;
       elseif abird.gender == 'F'
          G(2,m) = G(2,m) + 1;
       else
           G(1,m) = G(1,m) + 1;
       end       
    end
    
    % consistency test
    Nm == sum(G(:,m))
    
    %G(:,m) = G(:,m)./sum(G(:,m));
end

end