% Converts a data record to the number of minutes/hours/etc starting from
% 1/1/2007
function T = convert_record_to_timestamp(record,time_interval)
%% PRE-PROCESS
if ischar(record{bird.SECONDS})
    record{bird.SECONDS} = str2double(record{bird.SECONDS});
end

if ischar(record{bird.MINUTES})
    record{bird.MINUTES} = str2double(record{bird.MINUTES});
end
if ischar(record{bird.HOURS})
    record{bird.HOURS} = str2double(record{bird.HOURS});
end
if ischar(record{bird.DAY})
    record{bird.DAY} = str2double(record{bird.DAY});
end
if ischar(record{bird.MONTH})
    record{bird.MONTH} = str2double(record{bird.MONTH});
end
if ischar(record{bird.YEAR})
    record{bird.YEAR} = str2double(record{bird.YEAR});
end
%%

T = get_timestamp_seconds(record);

if exist('time_interval','var')
    T = ceil(T/time_interval);
end

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
secs = (record{bird.SECONDS}) +...
    60*(record{bird.MINUTES}) +...
    3600*(record{bird.HOURS}) + ...
    24*3600*((record{bird.DAY})-1)+...
    24*3600*get_days_given_month_year((record{bird.MONTH})-1,(record{bird.YEAR}))+...
    24*3600*get_days_given_year((record{bird.YEAR})-1);
end

function mins = get_timestamp_minutes(record)
mins = (record{bird.MINUTES}) +...
    60*(record{bird.HOURS}) + ...
    24*60*((record{bird.DAY})-1)+...
    24*60*get_days_given_month_year((record{bird.MONTH})-1,(record{bird.YEAR}))+...
    24*60*get_days_given_year((record{bird.YEAR})-1);
end

function hours = get_timestamp_hours(record)
hours = (record{bird.HOURS}) + ...
    24*((record{bird.DAY})-1)+...
    24*get_days_given_month_year((record{bird.MONTH})-1,(record{bird.YEAR}))+...
    24*get_days_given_year((record{bird.YEAR})-1);
end

function days = get_timestamp_day(record)
days = (record{bird.DAY})+...
    get_days_given_month_year((record{bird.MONTH})-1,(record{bird.YEAR}))+...
    get_days_given_year((record{bird.YEAR})-1);
end