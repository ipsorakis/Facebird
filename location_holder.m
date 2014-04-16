classdef location_holder < handle
    
    properties
        loc_table;
        loc_index;
        
        number_of_active_locations;
        active_locations;
        
        locations_in_database;
    end
    
    methods
        function obj = location_holder(location_filename)
            fid = fopen(location_filename);
            DATA = textscan(fid,'%s');
            fclose(fid);
            
            lines = size(DATA{1},1);
            obj.locations_in_database = lines-1;
            
            obj.loc_table = hashtable;
            obj.loc_index = cell(obj.locations_in_database,1);
            obj.active_locations = false(obj.locations_in_database,1);
            obj.number_of_active_locations = 0;
            
            for i=2:lines
                loc = location(DATA{1}{i});
                obj.loc_table = put(obj.loc_table,loc.ID,loc);
            end
        end
        
        function add_unregistered_location(obj,locID)
            loc = location(strcat(',-1,-1,-1,-1,',locID));
            obj.loc_table = put(obj.loc_table,loc.ID,loc);
        end
        
        function e = exists(obj,locID)
            e = ~isempty(get(obj.loc_table,locID));
        end
        
        function d = get_distance(obj,ID1,ID2)
            loc1 = get(obj.loc_table,ID1);
            loc2 = get(obj.loc_table,ID2);
            d = obj.eucledian_distance(loc1.x,loc2.y);
        end
        
        function loc = get_location_by_ID(obj,ID)
            loc = get(obj.loc_table,ID);
        end
        
        function loc = get_location_by_index(obj,index)
            loc = get(obj.loc_table,obj.loc_index{index});
        end
        
        function index = get_location_index(obj,locID)
            loc = get(obj.loc_table,locID);
            index = loc.index;
        end
        
        function hasindex = has_index(obj,locID)
            loc = get(obj.loc_table,locID);
            hasindex = loc.index ~= -1;
        end
        
        function update_location_index(obj,locID,index)
            loc = get(obj.loc_table,locID);
            loc.index = index;
            
            obj.loc_index{index} = loc.ID;
            obj.active_locations(index) = true;
            obj.number_of_active_locations = obj.number_of_active_locations + 1;
        end
        
        function is_active = is_active(obj,locID)
            loc = get(obj.loc_table,locID);
            if loc.index == -1
                is_active = false;
            else
                is_active = obj.active_locations(loc.index);                        
            end
        end
        
        function active = get_active_locations(obj)
           active = cell(obj.number_of_active_locations,1);
           
           iterator = 0;
           for i=1:obj.locations_in_database
               if obj.active_locations(i)
                  iterator = iterator+1;
                  active{iterator} = get(obj.loc_table,obj.loc_index{i});
               end
           end
        end
        
        function show_active_locations(obj,LOCATIONS_XY)
           try
               load(LOCATIONS_XY);
               % location_IDs, locations_XY;
           catch ME
               ME.stack;
               error('Could not find coordinates file');
           end
           
           try
               imshow('wytham_map.jpg');
           catch ME
               ME.stack;
               error('Could not find wytham_map.jpg');
           end
           
           hold on;
           for i=1:length(location_IDs)
              current_location_ID = location_IDs{i};
              if obj.is_active(current_location_ID)
                  %location = get(obj.loc_table,current_location_ID);
                   circle([locations_XY(i,1) locations_XY(i,2)],100,1000,'-');
              end
           end
           hold off;
        end
    end
    
    methods(Static)
        function d = eucledian_distance(X,Y)
            d = sqrt(sum((X-Y).^2));
        end
    end
end