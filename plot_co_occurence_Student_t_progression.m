function [t_new t_old] = plot_co_occurence_Student_t_progression(OUTPUT_STRUCT,Xframes,new_pairs_global,old_pairs_global)

frames = length(OUTPUT_STRUCT);

t_new = zeros(frames,1);
t_old = zeros(frames,1);

parfor t=1:frames
    new_pairs = new_pairs_global;
    old_pairs = old_pairs_global;
    Xframes_t = Xframes(:,t);
    
    W = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes);
    Wnull_mean = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_mean);
    Wnull_std = decompress_adjacency_matrix(OUTPUT_STRUCT(t).Wframes_null_std);
    
    if isempty(W)
        t_new(t) = nan;
        t_old(t) = nan;
        continue;
    end
    
    %% NEW PAIR
    iterator = 0;
    for i=1:size(new_pairs,1)
        x = new_pairs(i,1);
        y = new_pairs(i,2);
        
        if Xframes_t(x)==0 && Xframes_t(y)==0
            continue
        end
        
        Student_t_xy = get_Student_t_value(W(x,y),Wnull_mean(x,y),Wnull_std(x,y));
        if isnan(Student_t_xy)
            continue
        end
        
        iterator = iterator+1;
        t_new(t) = t_new(t) + Student_t_xy;
    end
    t_new(t) = t_new(t)/iterator;
    %% OLD PAIR
    iterator = 0;
    for i=1:size(old_pairs,1)
        x = old_pairs(i,1);
        y = old_pairs(i,2);
        
        if Xframes_t(x)==0 && Xframes_t(y)==0
            continue
        end
        
        Student_t_xy = get_Student_t_value(W(x,y),Wnull_mean(x,y),Wnull_std(x,y));
        if isnan(Student_t_xy)
            continue
        end
        
        iterator = iterator+1;
        t_old(t) = t_old(t) + Student_t_xy;
    end
    t_old(t) = t_old(t)/iterator;
end

% if strcmp(adjacency_used,'W')
%     hold on
%     plot(prog,color);
%     errorbar(prog_null_mean,prog_null_std,'r');
%     hold off
%     title(strcat('DAILY appearances of birds i:',num2str(x),' and j:',num2str(y)));
%     legend('co-occurences','null co-occurences');
% else
%     plot(prog,color);
% end
end

function S = get_Student_t_value(X,Xbar,sigma)

nominator = X-Xbar;

if nominator==0 && sigma==0
    S = nan;
elseif nominator~=0 && sigma==0
    sigma = eps;
    S = nominator/sigma;
else
    S = nominator/sigma;
end
end