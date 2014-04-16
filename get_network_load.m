function NL = get_network_load(A)

if isempty(A)
    NL = nan;
    return
end

if ~islogical(A)
    A = 1*logical(A);
end

N = size(A,1);

M = sum(sum(A))/2;
slots = (N^2 - N)/2;

NL = M/slots;

end


%function [network_load N_active active_nodes] = get_network_load(Wframes)
% 
% N = size(Wframes,1);
% days = size(Wframes,3);
% 
% if days~=1    
%     network_load = zeros(days,1);
%     active_nodes = false(N,days);
%     N_active = zeros(days);
%     
%     for i=1:days
%         W = logical(Wframes(:,:,i));
%         active_nodes(:,i) = sum(W)~=0;        
%         N_active(i) = sum(active_nodes(:,i));
%         
%         if N_active(i)~=0
%             network_load(i) = sum(sum(W(active_nodes(:,i),active_nodes(:,i)))) / (N_active(i)^2 - N_active(i));
%         else
%             network_load(i) = 0;
%         end
%     end
%     
%     N_active = N_active / N;
% else
%     W = logical(Wframes);
%     network_load = sum(sum(W))/ (N^2 - N);
% end




%
% plot(network_load);
%
% if only_active
%     str_title = 'only for active';
% else
%     str_title = 'for all individuals';
% end
% title(strcat('Network load for year:',num2str(year),'-',num2str(year+1),', ',str_title));
%
% xlabel('timeline');
% ylabel('network load');
%
% insert_months_graph;
%
% end
%
% if ~exist('only_active','var')
%     only_active = 1;
% end
%
% frame = size(Whist,3);
% N = size(Whist,1);
%
% network_load = zeros(frame,1);
%
% for i=1:frame
%     Atmp = 1*(Whist(:,:,i)~=0);
%
%     if only_active
%         active = sum(Atmp)~=0;
%         M = sum(sum(Atmp(active,active)));
%         n = sum(active);
%     else
%         M = sum(sum(Atmp));
%         n=N;
%     end
%
%     network_load(i) = .5 * M / (n*(n-1));
% end
%
% plot(network_load);
%
% if only_active
%     str_title = 'only for active';
% else
%     str_title = 'for all individuals';
% end
% title(strcat('Network load for year:',num2str(year),'-',num2str(year+1),', ',str_title));
%
% xlabel('timeline');
% ylabel('network load');
%
% insert_months_graph;