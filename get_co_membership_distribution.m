function  output = get_co_membership_distribution(BIRDS_DATABASE,PEDIGREE,C,plot_out,IM)

%N = size(C,1);
C = decompress_adjacency_matrix(C);

year = BIRDS_DATABASE.timestamp+1;

new_pairs = PEDIGREE.get_recorded_new_pairs(BIRDS_DATABASE,year);
old_pairs = PEDIGREE.get_recorded_old_pairs(BIRDS_DATABASE,year);
divorced_pairs = PEDIGREE.get_recorded_divorced_pairs(BIRDS_DATABASE,year);

%%
if exist('IM','var')
    for i=1:size(new_pairs,1)
       new_pairs(i,1) = IM.get_relative_index(new_pairs(i,1));
       new_pairs(i,2) = IM.get_relative_index(new_pairs(i,2));
    end
    
    for i=1:size(old_pairs,1)
        old_pairs(i,1) = IM.get_relative_index(old_pairs(i,1));
        old_pairs(i,2) = IM.get_relative_index(old_pairs(i,2));
    end
end

%% FIND VALUES
Cvalues = get_triu_vector(C);

%
new_pair_values = zeros(size(new_pairs,1),1);
for x=1:length(new_pair_values)
    new_pair_values(x) = C(new_pairs(x,1),new_pairs(x,2));
end

%
old_pair_values = zeros(size(old_pairs,1),1);
for x=1:length(old_pair_values)
    old_pair_values(x) = C(old_pairs(x,1),old_pairs(x,2));
end

%
divorced_pair_values = zeros(size(divorced_pairs,1),1);
for x=1:length(divorced_pair_values)
    divorced_pair_values(x) = C(divorced_pairs(x,1),divorced_pairs(x,2));
end

%
random_pair_values = C;
for i=1:size(old_pairs,1)
   random_pair_values(old_pairs(i,1),old_pairs(i,2)) = nan;
end

for i=1:size(new_pairs,1)
    random_pair_values(new_pairs(i,1),new_pairs(i,2)) = nan;
end

for i=1:size(divorced_pairs,1)
    random_pair_values(divorced_pairs(i,1),divorced_pairs(i,2)) = nan;
end

random_pair_values = get_triu_vector(random_pair_values);
random_pair_values(isnan(random_pair_values)) = [];

%%
C_value_range = 0:max(Cvalues);
Chist = histc(Cvalues,C_value_range);

new_pair_histogram = histc(new_pair_values,C_value_range);
old_pair_histogram = histc(old_pair_values,C_value_range);
divorced_pair_histogram = histc(divorced_pair_values,C_value_range);
random_pair_histogram = histc(random_pair_values,C_value_range);


Chist_norm = Chist / sum(Chist);
new_pair_histogram_norm = new_pair_histogram/sum(new_pair_histogram);
old_pair_histogram_norm = old_pair_histogram/sum(old_pair_histogram);
divorced_pair_histogram_norm = divorced_pair_histogram/sum(divorced_pair_histogram);
random_pair_histogram_norm = random_pair_histogram/sum(random_pair_histogram);


% distributions
P = [Chist random_pair_histogram new_pair_histogram old_pair_histogram divorced_pair_histogram];
Pnorm = [Chist_norm random_pair_histogram_norm new_pair_histogram_norm old_pair_histogram_norm divorced_pair_histogram_norm];

% cummulative distributions
F = [get_cummulative_distribution_from_vector(Chist)...
    get_cummulative_distribution_from_vector(random_pair_histogram)...
    get_cummulative_distribution_from_vector(new_pair_histogram)...
    get_cummulative_distribution_from_vector(old_pair_histogram)...
    get_cummulative_distribution_from_vector(divorced_pair_histogram)];

Fnorm = [get_cummulative_distribution_from_vector(Chist_norm)...
    get_cummulative_distribution_from_vector(random_pair_histogram_norm)...
    get_cummulative_distribution_from_vector(new_pair_histogram_norm)...
    get_cummulative_distribution_from_vector(old_pair_histogram_norm)...
    get_cummulative_distribution_from_vector(divorced_pair_histogram_norm)];

%%
if exist('plot_out','var') && plot_out == true
    figure(1)
    bar(C_value_range,Pnorm(:,[1 3 4 5]))
    %colormap lines;
    legend('P(c_{ij} | \{i,j\}= random pair)','P(c_{ij} | \{i,j\}= new pair)','P(c_{ij} | \{i,j\}= old pair)','P(c_{ij} | \{i,j\}= divorced pair)');
    
    figure(2)
    stem(C_value_range,Fnorm(:,[1 3 4]))
    %colormap lines;
    legend('F(c_{ij} | \{i,j\}= random pair)','F(c_{ij} | \{i,j\}= new pair)','F(c_{ij} | \{i,j\}= old pair)');
end

%%
output = struct('P',P,'Pnorm',Pnorm,...
    'F',F,'Fnorm',Fnorm,...
    'C_value_range',C_value_range,...
    'random_pair_histogram',random_pair_histogram,'new_pair_histogram',new_pair_histogram,'old_pair_histogram',old_pair_histogram,'divorced_pair_histogram',divorced_pair_histogram,...
    'random_pair_histogram_norm',random_pair_histogram_norm,'new_pair_histogram_norm',new_pair_histogram_norm,'old_pair_histogram_norm',old_pair_histogram_norm,'divorced_pair_histogram_norm',divorced_pair_histogram_norm,...    
    'Cvalues',Cvalues,'random_pair_values',random_pair_values,'new_pair_values',new_pair_values,'old_pair_values',old_pair_values,'divorced_pair_values',divorced_pair_values);

%P Pnorm C_value_range new_pair_histogram old_pair_histogram new_pair_histogram_norm old_pair_histogram_norm

end