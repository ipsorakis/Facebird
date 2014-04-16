function [CCframes CCframes_null] = get_clustering_coefficient_timeline(OUTPUT_STRUCT,weighted_flag)

total_frames = length(OUTPUT_STRUCT);
CCframes = zeros(total_days,1);
CCframes_null = zeros(total_days,1);
%CCframes_null_std = zeros(total_days,1);

parfor frame=1:total_frames
    W = decompress_adjacency_matrix(OUTPUT_STRUCT(frame).Wframes);
    W_null = decompress_adjacency_matrix(OUTPUT_STRUCT(frame).Wframes_null_mean);
    
    active = sum(W)~=0;
    
    if sum(active)~=0
        W = W(active,active);
        Wnull = W(active,active);
        
        if ~weighted_flag
            W(W~=0)=1;
            Wnull(Wnull~=0) = 1;
        end
        
        CCframes(frame) = mean(get_clustering_coefficient(W));
        CCframes_null(frame) = mean(get_clustering_coefficient(W_null));
    else
        CCframes(frame) = 0;
        CCframes_null(frame) = 0;
    end
end


% total_days = size(Whist,3);
% CChist = zeros(total_days,1);
%
% parfor day=1:total_days
% %    try
%     Wday = Whist(:,:,day);
%     active = find(sum(Wday)~=0);
%     if ~isempty(active)
%         W = Wday(active,active);
%         if ~weighted_flag
%             W = 1*(W==1);
%         end
%
%         CChist(day) = mean(get_clustering_coefficient(W));
%     end
% %     catch ME
% %         ME.stack
% %     end
end


end