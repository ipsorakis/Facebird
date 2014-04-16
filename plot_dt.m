function [dt dID] = plot_dt(DATA)

dt = diff(DATA(:,1));
dID = diff(DATA(:,2));

T = length(dt);

Z = size(DATA,1);

figure
hold on
for t=1:T
   if dID(t)~=0
       stem(t,dt(t),'b');
   else
       stem(t,dt(t),'r');
   end
end

hold off
end