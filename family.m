classdef family < handle
    
    properties
        ID;
        
        father;
        mother;
        
        year;
        nestbox;
        
        index;
    end
    
    methods
        function obj = family(ID,father,mother,year,nestbox,index)
            obj.ID = ID;
            obj.father = father;
            obj.mother = mother;
            obj.index = index;
            obj.nestbox = nestbox;
            
            if year>100
                obj.year = year-100;
            end
        end
    end
end