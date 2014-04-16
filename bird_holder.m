classdef bird_holder < handle
    
    properties
        birds_hashtable;
        birds_list;
        birds_number;
        
        timestamp;
    end
    
    methods
        function obj = bird_holder(t)
            obj.birds_hashtable = hashtable;
            obj.birds_list = cell(0);
            obj.birds_number = 0;
            
            if ~isnumeric(t)
                obj.timestamp = str2double(t);
            else
                obj.timestamp = t;
            end
        end
        %% SINGLE BIRD TRANSACTIONS
        function add_bird(obj,a_bird)
            if ~exists(obj,a_bird.ringNo)
                obj.birds_number = obj.birds_number + 1;
                a_bird.index = obj.birds_number;
                
                obj.birds_hashtable = put(obj.birds_hashtable,a_bird.ringNo,a_bird);
                obj.birds_list{obj.birds_number} = a_bird.ringNo;
            end
        end
        
        function e = exists(obj,ID)
           e = ~isempty(get(obj.birds_hashtable,ID));
        end
        
        function b = get_bird_by_ID(obj,ID)
            b = get(obj.birds_hashtable,ID);
        end
        
        function b = get_bird_by_index(obj,index)
            b = get(obj.birds_hashtable,obj.birds_list{index});
        end
    end
end