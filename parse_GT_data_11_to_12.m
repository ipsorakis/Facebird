function [DATA, INDIVIDUALS_DATABASE, LOCATIONS, min_timestamp] = parse_GT_data_11_to_12(input_filename)

fid = fopen(input_filename);

% get column headers
tline = fgetl(fid);

% INITIALISE
DATA = zeros(1,3);
INDIVIDUALS_DATABASE = bird_holder('11_to_12');
LOCATIONS = containers.Map();

%individual_counter = 0;
location_counter = 0;

min_timestamp = inf;

lines_counted = 0;
% read first line
tline = fgetl(fid);
tic
while ischar(tline)
                
    line_elems = remove_quotation_marks(strsplit(tline,','));
    data_row = zeros(1,3);
    
    %CSV COL# 1:LINENUM, 2:DD-MM-YYYY, 3:HH:MM:SS, 4:TAG, 5:LOC
    %DATA COL# 1: SECS 2: IND_ID 3: LOC_ID 4: DATENUM
    
    %% TIMESTAMPS
    datestamp = line_elems{2};
    if sum(regexp(datestamp,'\d\d-\d\d-\d\d\d\d'))==0
        tline = fgetl(fid);
        continue        
    end
    
    datestamp = datestr(datestamp,'dd-mm-yyyy');
    ddmmyyyy = strsplit(datestamp,'-');
    
    %%%%%%% DEFINE BASE_DATUM %%%% if lines_counted==0,base_datenum=datenum(datestamp);end
    %base_datenum = datenum(datestr('09-01-2011','mm-dd-yyyy'));
    
    % adding day component
    %data_row(1) = (datenum(datestamp) - base_datenum + 1)*100000;
    
    hhmmss = line_elems{3};
    if sum(regexp(hhmmss,'\d\d:\d\d:\d\d'))==0
        tline = fgetl(fid);
        continue
    end
    hhmmss = strsplit(hhmmss,':');
    %timestamp = str2double(hhmmss{1})*60*60 + str2double(hhmmss{2})*60 + str2double(hhmmss{3});    
    timestamp = date2unixsecs(...
        str2double(ddmmyyyy{3}),str2double(ddmmyyyy{2}),str2double(ddmmyyyy{1}),...
        str2double(hhmmss{1}),str2double(hhmmss{2}),str2double(hhmmss{3}));
    
    % adding time component
    data_row(1) = timestamp;
    
    if timestamp<min_timestamp
        min_timestamp = timestamp;
    end
    
    %% PROCESS IND ID
    tag = line_elems{4};
    % check if individual exists
    if ~INDIVIDUALS_DATABASE.exists(tag)       
       new_ind = bird(tag,tag,data_row(1),line_elems{5},data_row(1),line_elems{5});
       INDIVIDUALS_DATABASE.add_bird(new_ind);
       
       data_row(2) = new_ind.index;
    else
        an_ind = INDIVIDUALS_DATABASE.get_bird_by_ID(tag);
        an_ind.last_appearance_date = data_row(1);
        an_ind.last_appearance_location = line_elems{5};
        
        data_row(2) = an_ind.index;
    end
    
    %% PROCESS LOC ID
    loc = line_elems{5};
    if ~LOCATIONS.isKey(loc)
        location_counter = location_counter + 1;
        LOCATIONS(loc) = location_counter;
    end
    data_row(3) = location_counter;
    %% MOVE NEXT
    lines_counted = lines_counted + 1;
    DATA(lines_counted,:) = data_row;
    tline = fgetl(fid);
    
    % display progress
    if mod(lines_counted,100)==0
        toc
        fprintf('iteration %d > total inds: %d, total locs: %d\n',lines_counted,INDIVIDUALS_DATABASE.birds_number,location_counter);
        tic
    end
    
    % test terminator *I'll be back*
    % if lines_counted == 500,break,end
end
toc

DATA(:,1) = DATA(:,1) - min_timestamp;

fclose(fid);

end