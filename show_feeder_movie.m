total_days = size(W_feeder,3);
for day=1:total_days
    day    
    display_feeder_network(W_feeder(:,:,day),X_feeder_number_of_visitors(:,day),LOCATIONS)
    title(strcat('day:',num2str(day)));
    pause(.15);
    %FRAMES(day)=getframe;
end