%% CLUSTER STUFF
% taskID = str2num(getenv('SGE_TASK_ID'));
% addpath(genpath('/scratch/psorakii/birds'));
% 
% inputfile = strcat('temporal_DATA200',num2str(taskID),'_10_minutes');
% load(inputfile);
% if ~exist('taskID','var')
%     taskID = 1;
% end
% outputfolder = '/scratch/psorakii/birds/facebird/datafiles/';
% outputfile = strcat(outputfolder,'WL_',inputfile);

%% INITIALIZATIONS
communities = cell(frame,1);
Qmonitor = zeros(frame,1);

WL = zeros(N,N,frame);

if ~exist('CommDetMethod','var')
    CommDetMethod = 2;
end

%% MAIN ENGINE
for t=1:frame
    t
    %% define W and find active
    W = Whist(:,:,t);
    active_birds = sum(W)~=0;
    %% run CommDet
    try
        if sum(active_birds)>1
            if CommDetMethod == 1
                % do NMF
                MAX_COMMUNITIES = ceil(sum(active_birds)/5);
                if MAX_COMMUNITIES<10
                    MAX_COMMUNITIES=10;
                end
                groups_r = cm_nmf(W(active_birds,active_birds),MAX_COMMUNITIES,0);
                Qmonitor(t) = get_modularity(groups_r,W(active_birds,active_birds));
            elseif CommDetMethod == 2
                % do EO
                [dump1 Qt best_iteration groups_r] = extremal_optimization(W(active_birds,active_birds),-1,1,0);
                Qmonitor(t)=Qt(best_iteration);
                %elseif
            end
            
            groups = recover_original_indices(groups_r,active_birds);
        else
            groups = num2cell((1:N)');
        end
    catch ME
        ME.stack;
        save(strcat(output_folder,'FAIL_',inputfile));
    end
    communities{t} = groups;
    
    %% build loyalty matrix
    for i=1:size(groups)
        WL(groups{i},groups{i},t) = WL(groups{i},groups{i},t) + 1;
    end
    WL(:,:,t) = WL(:,:,t) - diag(diag(WL(:,:,t)));
end

%% FINALIZE AND SAVE
keep communities Qmonitor WL outputfile;
save(outputfile);