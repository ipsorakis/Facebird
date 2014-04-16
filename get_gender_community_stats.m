function entropy = get_gender_community_stats(CommHist,BIRDS_DATABASE,plot_out)

if ~exist('plot_out','var')
    plot_out = 0;
end

frames = length(CommHist);

bar_data = zeros(frames,3);
entropy = zeros(frames,1);
%1: male 2: female 3: unknown

for t=1:frames
    g = CommHist{t};
    
    [entropy(t) bar_data(t,:)] = get_gender_stats(g,BIRDS_DATABASE);
end

if plot_out
    %bar(bar_data,'stack');
    %legend('M','F','U');
    
    plot(entropy)
end
end

function [mean_entropy single_bar] = get_gender_stats(g,BIRDS_DATABASE)

single_bar = zeros(1,3);
mean_entropy = 0;

K = length(g);

total_male_ratio = 0;
total_female_ratio = 0;
total_unknown_ratio = 0;

non_single_comm_count = 0;
for k=1:K
    males = 0;
    females = 0;
    unknowns = 0;
    
    members = g{k};
    C = length(members);
    % don't count if single member groups
    if C~=1
        for c=1:C
            abird = BIRDS_DATABASE.get_bird_by_index(members(c));
            if strcmp(abird.gender,'M')
                males = males + 1;
            elseif strcmp(abird.gender,'F')
                females = females + 1;
            else
                unknowns = unknowns + 1;
            end
        end
        
        male_ratio = males / C;
        female_ratio = females / C;
        unknowns_ratio = unknowns / C;
        
        mean_entropy = mean_entropy + get_entropy([males/(males+females) females/(males+females)]);
        
        total_male_ratio = total_male_ratio + male_ratio;
        total_female_ratio = total_female_ratio + female_ratio;
        total_unknown_ratio = total_unknown_ratio + unknowns_ratio;
        
        non_single_comm_count = non_single_comm_count + 1;
    end
    
end

mean_entropy = mean_entropy/non_single_comm_count;

single_bar(1) = total_male_ratio/non_single_comm_count;
single_bar(2) = total_female_ratio/non_single_comm_count;
single_bar(3) = total_unknown_ratio/non_single_comm_count;
end