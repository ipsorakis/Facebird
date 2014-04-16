function everythingOK = ...
    parse_GT_data_7_to_9(input_filename,output_filename,read_type,read_limit,location_constraint)
everythingOK=true;

if ~exist('output_filename','var')
    output_filename = strsplit(input_filename,'.');
    output_filename = output_filename{1};
end

if exist('read_type','var') && ~exist('read_limit','var')
    error('please specify read limit')
end     
%% OPEN CSV FILE AND INITIALIZE
disp('reading file....')
fid = fopen(input_filename);
raw_data = textscan(fid,'%s');
fclose(fid);
disp('file accessed successfully.')

input_file_lines = size(raw_data{1},1);
%observations = input_file_lines-1;

%DATA = cell(1,1);
%observation_timestamps_seconds = zeros(observations,1);
%observation_timestamps_minutes = zeros(observations,1);
%observation_timestamps_hours = zeros(observations,1);
%observation_timestamps_day = zeros(observations,1);

%column1 = timestamp(secs), column2 = birdID, column3 = locationID
DATA = zeros(1,3);

BIRDS_DATABASE = bird_holder(read_limit);
LOCATIONS = location_holder('logger_locations.csv');
loc_index=1;

%% READ LIMITS
if strcmp(read_type,'first')
    if find(read_limit)==1
        monitor_quantity = bird.DAY;
    else
        monitor_quantity = bird.MONTH;
    end
    max_times_change = read_limit(read_limit~=0);
    previous_monitor_value=-1;
    times_changed=0;
    
elseif strcmp(read_type,'yymm') %|| strcmp(read_type,'year')
    monitor_quantity = read_limit;
    found=false;
elseif strcmp(read_type,'year')
    monitor_quantity = str2double(read_limit);
    found=false;
end


iterator=0;
disp('Scanning input file...')
tic
% start from 2 as we exclude the column headers
for i=2:input_file_lines
    %% READ A SINGLE RECORD FROM THE RAW DATA
    record = strsplit(raw_data{1}{i},',');
    
    %% CHECK IF RECORD IS WITHIN TIME CONSTRAINTS
    if strcmp(read_type,'first')
        current_monitor_value = str2double(record{monitor_quantity});
        if current_monitor_value~=previous_monitor_value
            times_changed=times_changed+1;
        end
        
        if times_changed>max_times_change
            break;
        end
        previous_monitor_value = current_monitor_value;
        %iterator = iterator+1;
    else%if strcmp(read_type,'yymm') || strcmp(read_type,'year')
        if strcmp(read_type,'yymm')
            time_reference = record{bird.YEARMONTH};
            if strcmp(time_reference,read_limit) && found==false
                found=true;
                %iterator = iterator+1;
                disp('Populating data...')
            elseif (~strcmp(time_reference,read_limit) && found==false)
                continue;
            elseif (~strcmp(time_reference,read_limit) && found==true)
                break;
                %             else
                %                 iterator = iterator+1;
            end
        elseif strcmp(read_type,'year')
            year_currently_reading = str2double(record{bird.YEAR});
            month_currently_reading = str2double(record{bird.MONTH});
            % READ FROM AUGUST OF GIVEN YEAR
            if year_currently_reading==monitor_quantity && month_currently_reading == 8 && ~found
                found=true;
                %iterator = iterator+1;
                disp('Populating data...')
                % UNTIL SPRING
            elseif year_currently_reading==monitor_quantity+1 && month_currently_reading > 4 && found
                break;
                
            elseif ~found
                continue;
                %             else
                %                 iterator = iterator+1;
            end
        end
    end
    
    %% CHECK IF RECORD IS WITHIN LOCATION CONSTRAINT
    if exist('location_constraint','var') && ~strcmp(location_constraint,record{bird.LOCATION})
        continue
    end
    %
    
    %% IF ALL CONDITIONS MET, ITERATE
    iterator = iterator + 1;
    
    if iterator == 1
        first_record = record;
    end
    
    last_record = record;
    
    %% CALCULATE TIMESTAMPS AND SAVE RECORD
    
    current_timestamp = get_timestamp_seconds(record);
    
%     record{bird.TIMESTAMP_SECONDS} = get_timestamp_seconds(record);
%     observation_timestamps_seconds(iterator) = (record{bird.TIMESTAMP_SECONDS});
%     
%     record{bird.TIMESTAMP_MINUTES} = get_timestamp_minutes(record);
%     observation_timestamps_minutes(iterator) = (record{bird.TIMESTAMP_MINUTES});
%     
%     record{bird.TIMESTAMP_HOURS} = get_timestamp_hours(record);
%     observation_timestamps_hours(iterator) = (record{bird.TIMESTAMP_HOURS});
%     
%     record{bird.TIMESTAMP_DAY} = get_timestamp_day(record);
%     observation_timestamps_day(iterator) = (record{bird.TIMESTAMP_DAY});
    
%    DATA{iterator} = record;
    %% POPULATE BIRD DATABASES
    if ~BIRDS_DATABASE.exists(record{bird.RINGNO})
        new_bird = bird(record);
        
        new_bird.first_appearance_date = ...
            [str2double(record{bird.YEAR}),...
            str2double(record{bird.MONTH}),...
            str2double(record{bird.DAY}),...
            str2double(record{bird.HOURS}),...
            str2double(record{bird.MINUTES}),...
            str2double(record{bird.SECONDS})];
        
        new_bird.first_appearance_location = record{bird.LOCATION};
        
        BIRDS_DATABASE.add_bird(new_bird);
        
    else
        current_bird = BIRDS_DATABASE.get_bird_by_ID(record{bird.RINGNO});
        
        current_bird.last_appearance_date = ...
            [str2double(record{bird.YEAR}),...
            str2double(record{bird.MONTH}),...
            str2double(record{bird.DAY}),...
            str2double(record{bird.HOURS}),...
            str2double(record{bird.MINUTES}),...
            str2double(record{bird.SECONDS})];
        
        current_bird.last_appearance_location = record{bird.LOCATION};
        
    end
    current_bird = BIRDS_DATABASE.get_bird_by_ID(record{bird.RINGNO});
    
    current_bird_index = current_bird.index;
    %% POPULATE LOCATION DATABASE INDICES
    if LOCATIONS.exists(record{bird.LOCATION}) && ~LOCATIONS.has_index(record{bird.LOCATION})
        LOCATIONS.update_location_index(record{bird.LOCATION},loc_index);
        loc_index=loc_index+1;
    elseif ~LOCATIONS.exists(record{bird.LOCATION})
        LOCATIONS.add_unregistered_location(record{bird.LOCATION});
        LOCATIONS.update_location_index(record{bird.LOCATION},loc_index);
        loc_index=loc_index+1;
    end
    current_location = LOCATIONS.get_location_by_ID(record{bird.LOCATION});
    
    current_location_index = current_location.index;
    
    %% UPDATE VISITATION DATA
    DATA(iterator,:) = [current_timestamp current_bird_index current_location_index];
end

%remove duplicate rows
DATA = unique(DATA,'rows');

% observation_timestamps_seconds = observation_timestamps_seconds(1:iterator);
% 
% total_birds = BIRDS_DATABASE.birds_number;
% total_locations = LOCATIONS.number_of_active_locations;
% 
% sanity_check1 = strsplit(raw_data{1}{i-1},',');
% sanity_check2 = record;
% final_iteration = i;
% 
% observation_timestamps = observation_timestamps_seconds;
%clear observation_timestamps_seconds observation_timestamps_day observation_timestamps_hours observation_timestamps_minutes;

%% BUILD OCCURENCES
% disp('building occurences table...');
% 
% if ~exist('time_window','var')
%     time_window = 60;
% end
% 
% %
% unique_timestamps = unique(observation_timestamps);
% 
% time_slots = ceil(observation_timestamps/time_window);
% unique_time_slots = unique(time_slots);
% 
% Occs = ...
%     get_bird_occurences...
%     (DATA,BIRDS_DATABASE,LOCATIONS,...
%     unique_time_slots,...
%     -1,-1,...
%     time_window);

%% FINALIZE AND SAVE
toc
%clear raw_data current_bird everythingOK fid found i input_filename iterator loc_index monitor_quantity...
%    month_currently_reading new_bird read_limit read_type record year_currently_reading;

keep output_filename BIRDS_DATABASE LOCATIONS DATA first_record last_record
save(output_filename);

%keep output_filename;
%[Whist Xhist day_indices] = build_temporal_network(output_filename,1,1,1);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET NUMBER OF DAYS STARTING FROM JANUARY-2007 GIVEN A MONTH,YEAR
function days = get_days_given_month_year(month,year)
if month == 0
    days = 0;
    return;
end

leap = [31 29 31 30 31 30 31 31 30 31 30 31];
nonleap = [31 28 31 30 31 30 31 31 30 31 30 31];

if year == 8
    days = sum(leap(1:month));
else
    days = sum(nonleap(1:month));
end

end

%% GET NUMBER OF DAYS STARTING FROM JANUARY-2007 GIVEN A YEAR
function days = get_days_given_year(year)
years = [6 7 8 9 10 11 12];
year_days = [0 365 366 365 365 365 366];

year_index = find(years==year,1);
days = sum(year_days(1:year_index));
end
%% TIME FUNCTIONS
function secs = get_timestamp_seconds(record)
secs = str2double(record{bird.SECONDS}) +...
    60*str2double(record{bird.MINUTES}) +...
    3600*str2double(record{bird.HOURS}) + ...
    24*3600*(str2double(record{bird.DAY})-1)+...
    24*3600*get_days_given_month_year(str2double(record{bird.MONTH})-1,str2double(record{bird.YEAR}))+...
    24*3600*get_days_given_year(str2double(record{bird.YEAR})-1);
end

function mins = get_timestamp_minutes(record)
mins = str2double(record{bird.MINUTES}) +...
    60*str2double(record{bird.HOURS}) + ...
    24*60*(str2double(record{bird.DAY})-1)+...
    24*60*get_days_given_month_year(str2double(record{bird.MONTH})-1,str2double(record{bird.YEAR}))+...
    24*60*get_days_given_year(str2double(record{bird.YEAR})-1);
end

function hours = get_timestamp_hours(record)
hours = str2double(record{bird.HOURS}) + ...
    24*(str2double(record{bird.DAY})-1)+...
    24*get_days_given_month_year(str2double(record{bird.MONTH})-1,str2double(record{bird.YEAR}))+...
    24*get_days_given_year(str2double(record{bird.YEAR})-1);
end

function days = get_timestamp_day(record)
days = str2double(record{bird.DAY})+...
    get_days_given_month_year(str2double(record{bird.MONTH})-1,str2double(record{bird.YEAR}))+...
    get_days_given_year(str2double(record{bird.YEAR})-1);
end