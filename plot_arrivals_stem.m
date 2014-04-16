function x = plot_arrivals_stem(DATA,separate_locations_flag)

if nargin<2
    separate_locations_flag = false;
end


t0 = DATA(1,1);
tend = DATA(end,1);

timeline = t0:tend;

if separate_locations_flag
    
    loc_labels = unique(DATA(:,3));
    L = length(loc_labels);
    
    loc_indices = [];
    for l=1:L
        tmp = DATA(:,3)==loc_labels(l);
        loc_indices = [loc_indices tmp];
    end
    loc_indices = logical(loc_indices);
    
    subplot(L,1,1)
    for l=1:L
        subplot(L,1,l)
        x = hist(DATA(loc_indices(:,l),1),timeline);
        
        x(x==0)=nan;
        x(x>1)=1;
        
        stem(x,'Color',[0 0 0],'Marker','none');
    end
else
    
    x = hist(DATA(:,1),timeline);
    x(x==0)=nan;
    x(x>1)=1;
    
    stem(x,'Color',[0 0 0],'Marker','none');
end

end