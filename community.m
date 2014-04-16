classdef community < handle
    
    properties
        ID;
        index;
        prev_index;
        first_index;
        
        members;
        prev_members;
        
        member_loyalty;
        prev_member_loyalty;
        
        lifetime;
        
        first_appearance;
        last_appearance;
        
        deaths;
        
        absorbed_communities;
        
        total_birds;
        
        location;
    end
    
    properties(Constant)
        %%%%
    end
    
    methods
        function obj = community(id,first_index,members,first_appearance,N)
            obj.ID = id;
            
            obj.first_index = first_index;
            obj.index = first_index;
            obj.prev_index = [];
            
            obj.members = members;
            obj.prev_members = [];
            
            obj.first_appearance = first_appearance;
            
            obj.total_birds = N;
            obj.member_loyalty = zeros(1,N);            
            
            obj.update_loyalty;
            
            
        end
        
        function s = get_size(obj)
           s = length(obj.members); 
        end
        
        function update_index(obj,new_index)
            obj.prev_index = obj.index;
            obj.index = new_index;
        end
        
        function update_members(obj,new_members)
           obj.prev_members = obj.members;
           obj.members = new_members;
           obj.update_loyalty;
        end
        
        function update_loyalty(obj)
            obj.member_loyalty(obj.members)=obj.member_loyalty(obj.members)+1;
            obj.member_loyalty(setdiff(1:obj.total_birds,obj.members)) = 0;
        end
        
        function [i y OK] = get_member_flow(obj)
            % all current
            n = length(obj.members);
            
            % ones remained from previous iteration
            np = length(intersect(obj.members,obj.prev_members));
            
            % newly arrived
            nn = length(setdiff(obj.members,obj.prev_members));
            
            % left
            nl = length(setdiff(obj.prev_members,obj.members));
            
            y = [np nn nl];
            
            OK = np+nn+nl == n;
            
            i = obj.first_index;
        end
    end
    
    methods(Static)
        %
    end
end