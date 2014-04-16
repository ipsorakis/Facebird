function everythingOK = ...
    populate_from_GT_data(input_filename,output_filename,read_type,read_limit)
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

raw_observations = size(raw_data{1},1);
observations = raw_observations-1;

DATA = cell(1,1);
observation_timestamps_seconds = zeros(observations,1);
observation_timestamps_minutes = zeros(observations,1);
observation_timestamps_hours = zeros(observations,1);
observation_timestamps_day = zeros(observations,1);

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
    
elseif strcmp(read_type,'yymm') || strcmp(read_type,'year')
    monitor_quantity = read_limit;
    found=false;
elseif strcmp(read_type,'year')
    monitor_quantity = read_limit;
    found=false;
end

iterator=0;
disp('Scanning input file...')
tic
for i=2:raw_observations
    %% READ A SINGLE RECORD FROM THE RAW DATA
    record = strsplit(raw_data{1}{i},',');
    
    %% MONITOR CHANGES
    if strcmp(read_type,'first')
        current_monitor_value = str2double(record{monitor_quantity});
        if current_monitor_value~=previous_monitor_value
            times_changed=times_changed+1;
        end
        
        if times_changed>max_times_change
            break;
        end
        previous_monitor_value = current_monitor_value;
        iterator = iterator+1;
    else%if strcmp(read_type,'yymm') || strcmp(read_type,'year')
        if strcmp(read_type,'yymm')
            time_reference = record{bird.YEARMONTH};
            if strcmp(time_reference,read_limit) && found==false
                found=true;
                iterator = iterator+1;
                disp('Populating data...')
            elseif (~strcmp(time_reference,read_limit) && found==false)
                continue;
            elseif (~strcmp(time_reference,read_limit) && found==true)
                break;
            else
                iterator = iterator+1;
            end
        elseif strcmp(read_type,'year')
            year_currently_reading = str2double(record{bird.YEAR});
            month_currently_reading = str2double(record{bird.MONTH});
            % READ FROM AUGUST OF GIVEN YEAR
            if year_currently_reading==monitor_quantity && month_currently_reading == 8 && ~found
                found=true;
                iterator = iterator+1;
                disp('Populating data...')
            % UNTIL SPRING
            elseif year_currently_reading==monitor_quantity+1 && month_currently_reading > 4 && found
                break;
                
            elseif ~found
                continue;
            else
                iterator = iterator+1;
            end
        end
    end
    
    %% CALCULATE TIMESTAMPS AND SAVE RECORD
    
    record{bird.TIMESTAMP_SECONDS} = get_timestamp_seconds(record);
    observation_timestamps_seconds(iterator) = (record{bird.TIMESTAMP_SECONDS});
    
    record{bird.TIMESTAMP_MINUTES} = get_timestamp_minutes(record);
    observation_timestamps_minutes(iterator) = (record{bird.TIMESTAMP_MINUTES});
    
    record{bird.TIMESTAMP_HOURS} = get_timestamp_hours(record);
    observation_timestamps_hours(iterator) = (record{bird.TIMESTAMP_HOURS});
    
    record{bird.TIMESTAMP_DAY} = get_timestamp_day(record);
    observation_timestamps_day(iterator) = (record{bird.TIMESTAMP_DAY});
    
    DATA{iterator} = record;
end

%observation_timestamps_seconds = observation_timestamps_seconds(1:iterator);
%observation_timestamps_minutes = observation_timestamps_minutes(1:iterator);
%observation_timestamps_hours = observation_timestamps_hours(1:iterator);
%observation_timestamps_day = observation_timestamps_day(1:iterator);

%% FINALIZE AND SAVE
toc
keep DATA iterator output_filename
save(output_filename);
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

leap = [30 29 31 30 31 30 31 31 30 31 30 31];
nonleap = [30 28 31 30 31 30 31 31 30 31 30 31];

if year == 8
    days = sum(leap(1:month));
else
    days = sum(nonleap(1:month));
end

end

%% GET NUMBER OF DAYS STARTING FROM JANUARY-2007 GIVEN A YEAR
function days = get_days_given_year(year)
years = [6 7 8 9];
year_days = [0 364 365 364];

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
