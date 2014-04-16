classdef community_holder < handle
    
    properties
        % unique communities
        communities;
        
        % number of communities spawned
        spawned_communities;
        
        % current community partition
        communities_current_step
        
        % community partitions across time steps
        timeline;
        
        % total individuals
        N;
        % timeline of active individuals
        active_individuals;
        
        % W history
        WH;
        
        % W weighted
        WW; %corruption_param?
        
        % mutual loyalty matrix
        WL;
        
        % community membership matrices
        P;
    end
    
    properties(Constant)
        %
    end
    
    methods
        %% CONSTRUCTOR
        function obj = community_holder(N)
            obj.timeline = cell(0);
            obj.active_individuals = cell(0);
            obj.communities = hashtable;
            
            obj.N = N;
            obj.WH = zeros(0,0,0);
            obj.WW = zeros(N);
            obj.WL = zeros(N);
            obj.P = cell(0);
        end
        
        %% COMMUNITIES PROCESSING
        function add_communities_current_step(obj,C)
            num = length(C);
            cID = cell(size(C));
            
            for i=1:num
                c = C{i};
                
                if isempty(get(obj.communities,c.ID))
                    register_new_community(obj,c);
                end
                
                cID{i} = c.ID;
            end
            
            step = length(obj.timeline)+1;
            obj.timeline{step} = cID;
        end
        
        function add_active_individuals(obj,new_active)
            step = length(obj.active_individuals)+1;
            obj.active_individuals{step} = new_active;
        end
        
        function add_P(obj,Pnew)
            step = length(obj.P)+1;
            obj.P{step} = Pnew;
        end
        
        function C = get_communities_given_t(obj,t)
            IDs = obj.timeline{t};
            C = cell(size(IDs));
            num = length(IDs);
            
            for i=1:num
                C{i} = get(obj.communities,IDs{i});
            end
        end
        
        %% INTERACTION MATRICES PROCESSING
        function update_W_history(obj,W)
            step = size(obj.WH,3)+1;
            obj.WH(:,:,step) = W;
            
            update_W_weighted(obj);
        end
        
        function update_W_weighted(obj)
            if size(obj.WH,3)~=1
                obj.WW = get_weighted_W(obj.WH);
            else
                obj.WW = obj.WH(:,:,1);
            end
        end
        
        function update_loyalties(obj,groups)
            n = length(groups);
            for i=1:n
                obj.WL(groups{i},groups{i}) = obj.WL(groups{i},groups{i}) + 1;
            end
            obj.WL = obj.WL - diag(diag(obj.WL));
        end
        %% SINGLE COMMUNITY PROCESSING
        function register_new_community(obj,c)
            obj.communities = put(obj.communities,c.ID,c);
            obj.spawned_communities = obj.spawned_communities + 1;
        end
        
        function c = get_community_by_time(obj,t,i)
            ID = obj.timeline{t}{i};
            c = get(obj.communities,ID);
        end
        
        function c = get_community_by_ID(obj,ID)
            c = get(obj.communities,ID);
        end
        
        function update_community(obj,c,t,i)
            obj.communities = put(obj.communities,c.ID,c);
            obj.timeline{t}{i} = c.ID;
        end
        
        function kill_community(obj,t,i,death_time)
            if ~exist('death_time','var')
                death_time = t;
            end
            
            cID = obj.timeline{t}{i};
            c = get(obj.communities,cID);
            c.last_appearance = death_time;
            %obj.communities = put(obj.communities,cID,c);
        end
        
        %% VARIOUS STATISTICS
        function s = get_spawned_communities(obj)
            s = obj.spawned_communities;
        end
        
        function L = get_loyalties(obj,t)
            if ~exist('t','var')
                t = length(obj.timeline);
            end
            
            L = zeros(1,obj.N);
            C = obj.timeline{t};
            n = length(C);
            for i=1:n
                c = get(obj.communities,C{i});
                L = L + c.member_loyalty;
            end
        end
        
        function S = get_mean_community_size(obj,do_for_all_time_steps)
            if ~exist('do_for_all_time_steps','var')
                do_for_all_time_steps=false;
            end
            
            S = 0;
            T = length(obj.timeline);
            num_elems = 0;
            
            if do_for_all_time_steps
                t_depth = 1;
            else
                t_depth = T;
            end
            
            for t=T:-1:t_depth
                for i=1:length(obj.timeline{t})
                    c = get(obj.communities,obj.timeline{t}{i});
                    S = S + c.get_size;
                end
                num_elems = num_elems + length(obj.timeline{t});
            end
            
            S = S / num_elems;
        end
        
        function S = get_mean_community_lifetime(obj,t)
            if ~exist('t','var')
                t = length(obj.timeline);
            end
            
            IDs = dump(obj.communities);
            n = length(IDs);
            
            S = 0;
            
            for i=1:n
                c = get(obj.communities,IDs{i});
                t1 = c.first_appearance;
                if isempty(c.last_appearance)
                    t2 = t;
                else
                    t2 = c.last_appearance;
                end
                S = S + (t2-t1);
            end
            
            S = S/n;
        end
    end
    
    methods(Static)
        function Ww = try_W_weighted(W,Whist)
            if ~isempty(Whist)
                step = size(Whist,3);
                Whist(:,:,step+1) = W;
                Ww = get_weighted_W(Whist);
            else
                Ww = W;
            end
        end
    end
end