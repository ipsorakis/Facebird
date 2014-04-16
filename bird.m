classdef bird < handle
    
    properties
        ringNo
        tags
        gender
        natalbox
        natalyear
        breedbox
        breedyear
        index
        
        %first_appearance_timestamp;
        first_appearance_date;
        first_appearance_location;
        
        %last_appearance_timestamp;
        last_appearance_date;
        last_appearance_location;
    end
    
    properties(Constant,Hidden)
        TIMESTAMP_SECONDS=1;
        TIMESTAMP_MINUTES=2;
        TIMESTAMP_HOURS=3;
        TIMESTAMP_DAY=4;
        
        SECONDS=5;
        MINUTES=6;
        HOURS=7;
        DAY=8;
        MONTH=9;
        YEARMONTH=10;
        YEAR=11;
        JULIANYEAR=12;
        TAG=13;
        LOCATION=14;
        ROTATION=15;
        ROTATIONDATE=16;
        STUDYDAY=17;
        RINGNO=18;
        GENDER=19;
        
        NATAL07=20;
        BREED07=21;
        NATAL08=22;
        BREED08=23;
        NATAL09=24;
        BREED09=25;
        
        SPECIES=26;
        WINTER=27;
    end
    
    methods
        function obj = bird(varargin)
            if length(varargin) == 1
                record = varargin{1};
                obj.ringNo = record{bird.RINGNO};
                obj.tags = record{bird.TAG};
                obj.gender = record{bird.GENDER};
                
                if ~strcmp(record{bird.NATAL07},'')
                    obj.natalbox = record{bird.NATAL07};
                    obj.natalyear = 2007;
                elseif ~strcmp(record{bird.NATAL08},'')
                    obj.natalbox = record{bird.NATAL08};
                    obj.natalyear = 2008;
                elseif ~strcmp(record{bird.NATAL09},'')
                    obj.natalbox = record{bird.NATAL09};
                    obj.natalyear = 2009;
                end
                
                if ~strcmp(record{bird.BREED07},'')
                    obj.breedbox = record{bird.BREED07};
                    obj.breedyear = 2007;
                elseif ~strcmp(record{bird.BREED08},'')
                    obj.breedbox = record{bird.BREED08};
                    obj.breedyear = 2008;
                elseif ~strcmp(record{bird.BREED09},'')
                    obj.breedbox = record{bird.BREED09};
                    obj.breedyear = 2009;
                end                                
            else
                % ringNo, tags, first_appearance_date,
                % last_appearance_date, first_appearance_location, last_appearance_location
                
                obj.ringNo = varargin{1};
                obj.tags = varargin{2};
                obj.first_appearance_date = varargin{3};
                obj.last_appearance_date = varargin{4};
                obj.first_appearance_location = varargin{5};
                obj.last_appearance_location = varargin{6};                
            end
            obj.index=-1;
        end
    end
end