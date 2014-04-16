function pedigree_loader(pedigree_filename,outputfile)
%% CONSTANTS
CHILD = 1;
FATHER = 2;
MOTHER = 3;
ORIGIN_PNUM = 4;
RAISED_PNUM = 5;
YEAR = 6;
RECRUITED = 7;
NESTBOX = 8;

%% FILE LOADER
fid = fopen(pedigree_filename);
raw_data = textscan(fid,'%s');
fclose(fid);
N = length(raw_data{1});


%% initialize containers
birds_table = hashtable;
birds_list = {};
total_birds = 0;

families_table = hashtable;
families_list = {};
total_families = 0;
artificial_count = 0;

%% first run - populate containers
for i=2:N
    record = strsplit(raw_data{1}{i},',');
    
    if length(record)==9
        for j=[ CHILD  FATHER  MOTHER]
            if isempty(get( birds_table,record{j}))
                total_birds =  total_birds+1;
                birds_table = put( birds_table,record{j}, total_birds);
                birds_list{total_birds} = record{j};
            end
        end
        
        if strcmp(record{ORIGIN_PNUM},'')
            try
                prev_record = strsplit(raw_data{1}{i-1},',');
            catch ME
                ME.stack
            end
            
            if strcmp(record{FATHER},prev_record{FATHER}) && strcmp(record{MOTHER},prev_record{MOTHER})
                record{ORIGIN_PNUM} = strcat('artificial_',num2str(artificial_count));
            else
                artificial_count = artificial_count +1;
                record{ORIGIN_PNUM} = strcat('artificial_',num2str(artificial_count));
            end
            
            new_record = record(1);
            for l=2:9
                new_record = strcat(new_record,',',record{l});
            end
            raw_data{1}{i} = char(new_record);
        end
        
        if isempty(get(families_table,record{ORIGIN_PNUM}))
            total_families =  total_families +1;
            f = family(record{ORIGIN_PNUM},record{FATHER},record{MOTHER},...
                str2double(record{YEAR}),record{NESTBOX},total_families);
            
            families_table = put(families_table,record{ORIGIN_PNUM},f);
            families_list{total_families} = f;
        end
    end
end

%% second run - build incidence matrix
try
    B = zeros( total_birds, total_families);
catch ME
    B = sparse(zeros( total_birds, total_families));
end

for i=2:N
    if length(record)==9
        record = strsplit(raw_data{1}{i},',');
        
        kid = get( birds_table,record{ CHILD});
        father = get( birds_table,record{FATHER});
        mother = get( birds_table,record{MOTHER});
        
        f = get( families_table,record{ORIGIN_PNUM});
        family_index = f.index;
        
        B(kid,family_index) = -1;
        B(father,family_index) = 1;
        B(mother,family_index) = 1;
    end
end

%% SAVE AND CLOSE
clear i j f kid father mother family_index record;
save(outputfile);
end