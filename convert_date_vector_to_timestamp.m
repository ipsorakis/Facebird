% Converts a date vector to the number of minutes/hours/etc starting from
% 1/1/2007
function T = convert_date_vector_to_timestamp(date_vector,time_interval)

T = get_timestamp_seconds(date_vector);

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
function secs = get_timestamp_seconds(date_vector)
secs = (date_vector(1)) +...
    60*(date_vector(2)) +...
    3600*(date_vector(3)) + ...
    24*3600*((date_vector(4))-1)+...
    24*3600*get_days_given_month_year((date_vector(5))-1,(date_vector(6)))+...
    24*3600*get_days_given_year((date_vector(6))-1);
end

function mins = get_timestamp_minutes(date_vector)
mins = (date_vector(2)) +...
    60*(date_vector(3)) + ...
    24*60*((date_vector(4))-1)+...
    24*60*get_days_given_month_year((date_vector(5))-1,(date_vector(6)))+...
    24*60*get_days_given_year((date_vector(6))-1);
end

function hours = get_timestamp_hours(date_vector)
hours = (date_vector(3)) + ...
    24*((date_vector(4))-1)+...
    24*get_days_given_month_year((date_vector(5))-1,(date_vector(6)))+...
    24*get_days_given_year((date_vector(6))-1);
end

function days = get_timestamp_day(date_vector)
days = (date_vector(4))+...
    get_days_given_month_year((date_vector(5))-1,(date_vector(6)))+...
    get_days_given_year((date_vector(6))-1);
end