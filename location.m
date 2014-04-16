classdef location < handle
    
    properties
        ID;
        
        database_index;
        index;
        
        x;
        y;
        
        group;
    end
    
    properties(Constant,Hidden)
        INDEXcol  =2;
        Xcol = 3;
        Ycol = 4;
        GROUPcol = 5;
        IDcol = 6;
    end
    
    methods
        function obj = location(record_string)
            record = strsplit(record_string,',');
            if length(record)>1
                obj.ID = record{location.IDcol};
                obj.database_index = str2double(record{location.INDEXcol});
                obj.x = str2double(record{location.Xcol});
                obj.y = str2double(record{location.Ycol});
                obj.group = str2double(record{location.GROUPcol});
                obj.index = -1;
            else
                obj.ID = record;
            end
        end
    end
end