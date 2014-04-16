function date_vector = convert_timestamp_to_date(timestamp,time_interval)

if ~exist('time_interval','var')
    time_interval = 1;
end

timestamp = timestamp*time_interval;
current_year = get_year_given_seconds(timestamp);

days_passed_since_beginning_of_2007 = floor(floor(timestamp/3600)/24);
days_passed_since_beggining_of_current_year = days_passed_since_beginning_of_2007 - get_days_given_year(current_year-1);

[current_month current_day]  = get_month_day_given_days_year(days_passed_since_beggining_of_current_year+1,current_year);

temp_record = cell(1,27);
temp_record{bird.SECONDS} = 0;
temp_record{bird.MINUTES} = 0;
temp_record{bird.HOURS} = 0;
temp_record{bird.DAY} = current_day;
temp_record{bird.MONTH} = current_month;
temp_record{bird.YEAR} = current_year;

seconds_passed_from_beggining_of_2007_to_current_day = get_timestamp_seconds(temp_record);

seconds_counting_from_beginning_of_current_day = timestamp - seconds_passed_from_beggining_of_2007_to_current_day;

current_hour = floor(seconds_counting_from_beginning_of_current_day/3600);

current_minutes = floor(seconds_counting_from_beginning_of_current_day/60) - current_hour*60;

current_seconds = seconds_counting_from_beginning_of_current_day - current_hour*3600 - current_minutes*60;

date_vector = [current_seconds current_minutes current_hour current_day current_month current_year];

% if strcmp(time_interval_type,'SECONDS')
%     current_year = get_year_given_seconds(timestamp);
%
%     days_passed_since_beginning_of_2007 = floor(floor(timestamp/3600)/24);
%     days_passed_since_beggining_of_current_year = days_passed_since_beginning_of_2007 - get_days_given_year(current_year-1);
%
%     [current_month current_day]  = get_month_day_given_days_year(days_passed_since_beggining_of_current_year+1,current_year);
%
%     %months_passed_since_beggining_of_current_year = current_month - 1;
%     %days_passed_since_beggining_of_current_month = current_day-1;
%
%     %date_vector(5) = current_month;
%     %date_vector(4) = current_day;
%
%     temp_record = cell(1,27);
%     temp_record{bird.SECONDS} = 0;
%     temp_record{bird.MINUTES} = 0;
%     temp_record{bird.HOURS} = 0;
%     temp_record{bird.DAY} = current_day;
%     temp_record{bird.MONTH} = current_month;
%     temp_record{bird.YEAR} = current_year;
%
%     seconds_passed_from_beggining_of_2007_to_current_day = get_timestamp_seconds(temp_record);
%
%     seconds_counting_from_beginning_of_current_day = timestamp - seconds_passed_from_beggining_of_2007_to_current_day;
%
%     current_hour = floor(seconds_counting_from_beginning_of_current_day/3600);
%
%     current_minutes = floor(seconds_counting_from_beginning_of_current_day/60) - current_hour*60;
%
%     current_seconds = seconds_counting_from_beginning_of_current_day - current_hour*3600 - current_minutes*60;
%
%     date_vector = [current_seconds current_minutes current_hour current_day current_month current_year];
%
% elseif strcmp(time_interval_type,'MINUTES')
%     current_year = get_year_given_minutes(timestamp);
%
%     days_passed_since_beginning_of_2007 = floor(floor(timestamp/60)/24);
%     days_passed_since_beggining_of_current_year = days_passed_since_beginning_of_2007 - get_days_given_year(current_year-1);
%
%     [current_month current_day]  = get_month_day_given_days_year(days_passed_since_beggining_of_current_year+1,current_year);
%
%     %months_passed_since_beggining_of_current_year = current_month - 1;
%     %days_passed_since_beggining_of_current_month = current_day-1;
%
%     %date_vector(5) = current_month;
%     %date_vector(4) = current_day;
%
%     temp_record = cell(1,27);
%     temp_record{bird.SECONDS} = 0;
%     temp_record{bird.MINUTES} = 0;
%     temp_record{bird.HOURS} = 0;
%     temp_record{bird.DAY} = current_day;
%     temp_record{bird.MONTH} = current_month;
%     temp_record{bird.YEAR} = current_year;
%
%     minutes_passed_from_beggining_of_2007_to_current_day = get_timestamp_minutes(temp_record);
%
%     minutes_counting_from_beginning_of_current_day = timestamp - minutes_passed_from_beggining_of_2007_to_current_day;
%
%     current_hour = floor(minutes_counting_from_beginning_of_current_day/60);
%
%     current_minutes = minutes_counting_from_beginning_of_current_day - current_hour*60;
%
%     current_seconds = 0;
%
%     date_vector = [current_seconds current_minutes current_hour current_day current_month current_year];
%
%
%
% elseif strcmp(time_interval_type,'HOURS')
%     %
%     errors('sorry, only works for SECONDS and MINUTES for now..')
% elseif strcmp(time_interval_type,'DAYS') || strcmp(time_interval_type,'DAY')
%     %
%     errors('sorry, only works for SECONDS and MINUTES for now..')
% else
%     date_vector = nan;
% end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [month day] = get_month_day_given_days_year(days,year)
if year == 8
    days_per_month = [31 29 31 30 31 30 31 31 30 31 30 31];
else
    days_per_month = [31 28 31 30 31 30 31 31 30 31 30 31];
end

for i=1:12
    tmp = days - sum(days_per_month(1:i));
    if tmp<=0
        month = i;
        break;
    end
end

if month ~= 1
    day = days - sum(days_per_month(1:i-1));
else
    day = days;
end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function year = get_year_given_seconds(seconds)
years = [7 8 9 10 11];
days_per_year = [365 366 365 365 365];
seconds_per_year = days_per_year * 24 * 3600;

for i=1:length(years)
    if seconds - sum(seconds_per_year(1:i)) <= 0
        year = years(i);
        break;
    end
end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function year = get_year_given_minutes(minutes)
years = [7 8 9 10 11];
days_per_year = [365 366 365 365 365];
minutes_per_year = days_per_year * 24 * 60;

for i=1:length(years)
    if minutes - sum(minutes_per_year(1:i)) <= 0
        year = years(i);
        break;
    end
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
secs =  (record{bird.SECONDS}) +...
    60* (record{bird.MINUTES}) +...
    3600* (record{bird.HOURS}) + ...
    24*3600*( (record{bird.DAY})-1)+...
    24*3600*get_days_given_month_year( (record{bird.MONTH})-1, (record{bird.YEAR}))+...
    24*3600*get_days_given_year( (record{bird.YEAR})-1);
end

function mins = get_timestamp_minutes(record)
mins =  (record{bird.MINUTES}) +...
    60* (record{bird.HOURS}) + ...
    24*60*( (record{bird.DAY})-1)+...
    24*60*get_days_given_month_year( (record{bird.MONTH})-1, (record{bird.YEAR}))+...
    24*60*get_days_given_year( (record{bird.YEAR})-1);
end

function hours = get_timestamp_hours(record)
hours =  (record{bird.HOURS}) + ...
    24*( (record{bird.DAY})-1)+...
    24*get_days_given_month_year( (record{bird.MONTH})-1, (record{bird.YEAR}))+...
    24*get_days_given_year( (record{bird.YEAR})-1);
end

function days = get_timestamp_day(record)
days =  (record{bird.DAY})+...
    get_days_given_month_year( (record{bird.MONTH})-1, (record{bird.YEAR}))+...
    get_days_given_year( (record{bird.YEAR})-1);
end