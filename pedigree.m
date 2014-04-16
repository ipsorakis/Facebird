classdef pedigree < handle
    
    properties
        birds_table;
        birds_list;
        total_birds;
        
        families_table;
        families_list;
        total_families;
        
        B;
    end
    
    methods
        function obj = pedigree(pedigree_filename)
            % pedigree_filename: a MATLAB .mat file created from
            % pedigree_loader
            load(pedigree_filename);
            
            obj.birds_table = birds_table;
            obj.birds_list = birds_list;
            obj.total_birds = total_birds;
            
            obj.families_table = families_table;
            obj.families_list = families_list;
            obj.total_families = total_families;
            
            obj.B = B;
        end
        
        function [father mother] = get_parents_by_ringNo(obj,kid_ringNo)
            kid_index = get(obj.birds_table,kid_ringNo);
            
            family_index = find(obj.B(kid_index,:)==-1);
            if ~isempty(family_index)
                f = obj.families_list{family_index};
                
                father = f.father;
                mother = f.mother;
            else
                father=[];
                mother=[];
            end
        end
        
        function [father mother] = get_parents_by_index(obj,BIRDS_DATABASE,kid_external_index)
            kid_ringNo = BIRDS_DATABASE.get_bird_by_index(kid_external_index).ringNo;
            kid_index = get(obj.birds_table,kid_ringNo);
            
            family_index = find(obj.B(kid_index,:)==-1);
            if ~isempty(family_index)
                f = obj.families_list{family_index};
                
                father = f.father;
                mother = f.mother;
            else
                father=[];
                mother=[];
            end
        end
        
        function partnerships = get_partner_by_ringNo(obj,bird_ringNo,year)
            bird_index = get(obj.birds_table,bird_ringNo);
            
            families_indices = find(obj.B(bird_index,:)==1);
            partnerships=[];
            
            if ~isempty(families_indices)
                num_of_families = length(families_indices);
                
                if exist('year','var')
                    % year constraint
                    for i=1:num_of_families
                        f = obj.families_list{families_indices(i)};
                        if f.year==year
                            if strcmp(bird_ringNo,f.father)
                                partner = f.mother;
                            else
                                partner = f.father;
                            end
                            partnerships = partner;
                            return;
                        end
                    end
                else
                    % non-year constraint
                    partnerships = cell(num_of_families,2);
                    for i=1:num_of_families
                        f = obj.families_list{families_indices(i)};
                        partnerships{i,2} = f.year;
                        if strcmp(bird_ringNo,f.father)
                            partnerships{i,1} = f.mother;
                        else
                            partnerships{i,1} = f.father;
                        end
                    end
                end
            end
        end
        
        function partnerships = get_partner_by_index(obj,BIRDS_DATABASE,bird_external_index,year)
            bird_ringNo = BIRDS_DATABASE.get_bird_by_index(bird_external_index).ringNo;
            bird_index = get(obj.birds_table,bird_ringNo);
            
            families_indices = find(obj.B(bird_index,:)==1);
            partnerships=[];
            
            if ~isempty(families_indices)
                num_of_families = length(families_indices);
                
                if exist('year','var')
                    % year constraint
                    for i=1:num_of_families
                        f = obj.families_list{families_indices(i)};
                        if f.year==year
                            if strcmp(bird_ringNo,f.father)
                                partner = f.mother;
                            else
                                partner = f.father;
                            end
                            partnerships = partner;
                            return;
                        end
                    end
                else
                    % non-year constraint
                    partnerships = cell(num_of_families,2);
                    for i=1:num_of_families
                        f = obj.families_list{families_indices(i)};
                        partnerships{i,2} = f.year;
                        if strcmp(bird_ringNo,f.father)
                            partnerships{i,1} = f.mother;
                        else
                            partnerships{i,1} = f.father;
                        end
                    end
                end
            end
        end
        
        function siblings = get_siblings_by_ringNo(obj,bird_ringNo)
            bird_index = get(obj.birds_table,bird_ringNo);
            
            family_index = obj.B(bird_index,:)==-1;
            
            if sum(family_index)~=0
                kid_indices = find(obj.B(:,family_index)==-1)';
                num_kids = length(kid_indices);
                
                if num_kids~=0
                    siblings = cell(num_kids-1,1);
                    sibling_index=0;
                    
                    for i=kid_indices
                        if bird_index ~= i
                            sibling_index = sibling_index +1;
                            siblings{sibling_index} = obj.birds_list{i};
                        end
                    end
                else
                    siblings = [];
                end
            else
                siblings=[];
            end
        end
        
        function siblings = get_siblings_by_index(obj,BIRDS_DATABASE,bird_external_index)
            bird_ringNo = BIRDS_DATABASE.get_bird_by_index(bird_external_index).ringNo;
            bird_index = get(obj.birds_table,bird_ringNo);
            
            family_index = obj.B(bird_index,:)==-1;
            
            if sum(family_index)~=0
                kid_indices = find(obj.B(:,family_index)==-1)';
                num_kids = length(kid_indices);
                
                if num_kids~=0
                    siblings = cell(num_kids-1,1);
                    sibling_index=0;
                    
                    for i=kid_indices
                        if bird_index ~= i
                            sibling_index = sibling_index +1;
                            siblings{sibling_index} = obj.birds_list{i};
                        end
                    end
                else
                    siblings = [];
                end
            else
                siblings=[];
            end
        end
        
        function b = was_born_ringNo(obj,bird_ringNo,year)
            bird_index = get(obj.birds_table,bird_ringNo);
            family_index = find(obj.B(bird_index,:)==-1,1);
            f = obj.families_list{family_index};
            
            b = f.year == year;
        end
        
        function b = was_born_index(obj,BIRDS,x,year)
            bird = BIRDS.get_bird_by_index(x);
            bird_ringNo = bird.ringNo;
            
            b = was_born(obj,bird_ringNo,year);
        end
        
        function y = birthyear(obj,bird_ringNo)
            bird_index = get(obj.birds_table,bird_ringNo);
            family_index = find(obj.B(bird_index,:)==-1,1);
            f = obj.families_list{family_index};
            
            y = f.year;
        end
        
        function pair = is_pair_by_index(obj,BIRDS_DATABASE,x,y,year)            
            
            x_ringNo = BIRDS_DATABASE.get_bird_by_index(x).ringNo;
            y_ringNo = BIRDS_DATABASE.get_bird_by_index(y).ringNo;
            
            pair = is_pair_by_ringNo(obj,x_ringNo,y_ringNo,year);
        end
        
        function pair = is_pair_by_ringNo(obj,x_ringNo,y_ringNo,year)
            pair = false;            
            
            bird_index = get(obj.birds_table,x_ringNo);
            
            family_indices = find(obj.B(bird_index,:)==1);
            num_families = length(family_indices);
            
            if ~isempty(family_indices)
                for family_index=1:num_families
                    f = obj.families_list{family_indices(family_index)};
                    pair = ((strcmp(f.father,x_ringNo) && strcmp(f.mother,y_ringNo))...
                        || (strcmp(f.mother,x_ringNo) && strcmp(f.father,y_ringNo)))...
                        && f.year==year;
                    
                    if pair
                        return;
                    end
                end
            end
        end
        
        function children = get_children_of_ringNo(obj,bird_ringNo,year)
            bird_index = get(obj.birds_table,bird_ringNo);
            
            family_indices = find(obj.B(bird_index,:)==1);
            num_families = length(family_indices);
            
            if ~isempty(family_indices)
                if exist('year','var')
                    children = [];
                    for family_index=1:num_families
                        f = obj.families_list{family_indices(family_index)};
                        if f.year == year
                            kid_indices = find(obj.B(:,family_indices(family_index))==-1);
                            num_kids = length(kid_indices);
                            children = cell(num_kids,1);
                            for kid_index=1:num_kids;
                                children{kid_index} = obj.birds_list{kid_indices(kid_index)};
                            end
                            return;
                        end
                    end
                else
                    children = cell(num_families,2);
                    for family_index=1:num_families
                        f = obj.families_list{family_indices(family_index)};
                        
                        kid_indices = find(obj.B(:,family_indices(family_index))==-1);
                        num_kids = length(kid_indices);
                        kids_current_family = cell(num_kids,1);
                        for kid_index=1:num_kids;
                            kids_current_family{kid_index} = obj.birds_list{kid_indices(kid_index)};
                        end
                        
                        children{family_index,1} = kids_current_family;
                        children{family_index,2} = f.year;
                    end
                end
            end
            
        end
        
        function children = get_children_of_index(obj,BIRDS_DATABASE,bird_external_index,year)
            bird_ringNo = BIRDS_DATABASE.get_bird_by_index(bird_external_index).ringNo;
            
            children = get_children_of_ringNo(obj,bird_ringNo,year);
        end
        
        function children = get_number_of_children_of_ringNo(obj,bird_ringNo,year)
            bird_index = get(obj.birds_table,bird_ringNo);
            
            family_indices = find(obj.B(bird_index,:)==1);
            num_families = length(family_indices);
            
            if ~isempty(family_indices)
                if exist('year','var')
                    children = 0;
                    for family_index=1:num_families
                        f = obj.families_list{family_indices(family_index)};
                        if f.year == year
                            children = sum(obj.B(:,family_indices(family_index))==-1);
                            return;
                        end
                    end
                else
                    children = 0;
                    for family_index=1:num_families
                        children = children + sum(obj.B(:,family_indices(family_index))==-1);
                    end
                end
            else
                children = 0;
            end
        end
        
        function children = get_number_of_children_of_index(obj,BIRDS_DATABASE,bird_external_index,year)
            bird_ringNo = BIRDS_DATABASE.get_bird_by_index(bird_external_index).ringNo;            
            
            children = get_number_of_children_of_ringNo(obj,bird_ringNo,year);
        end
        
        function [children_number family_number avg_output std_output] = get_born_number(obj,year)
            families = false(obj.total_families,1);
            
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year==year
                    families(i)=1;
                end
            end
            
            c = sum(obj.B(:,families) == -1);
            
            children_number = sum(c);
            family_number = sum(families);
            avg_output = mean(c);
            std_output = std(c);
        end
        
        function a= get_average_born_number(obj,year)
            [c f] = get_born_number(obj,year);
            a = c/f;
        end
        
        function pairs = get_recorded_pairs(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        pair_index = pair_index + 1;
                        pairs(pair_index,1) = father.index;
                        pairs(pair_index,2) = mother.index;
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function pairs = get_recorded_new_pairs(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        all_copulations = obj.get_partner_by_ringNo(father.ringNo);
                        is_new_pair = true;
                        for j=1:size(all_copulations,1)
                            is_new_pair = is_new_pair && ...
                                ((strcmp(all_copulations{j,1},mother.ringNo) && all_copulations{j,2}>=year)...
                                || ~strcmp(all_copulations{j,1},mother.ringNo));
                        end
                        if is_new_pair
                            pair_index = pair_index + 1;
                            pairs(pair_index,1) = father.index;
                            pairs(pair_index,2) = mother.index;
                        end
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function pairs = get_recorded_new_pairs_first_copulation(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        all_copulations_father = obj.get_partner_by_ringNo(father.ringNo);
                        first_of_father = strcmp(all_copulations_father{1,1},mother.ringNo);
                        
                        all_copulations_mother = obj.get_partner_by_ringNo(mother.ringNo);
                        first_of_mother = strcmp(all_copulations_mother{1,1},father.ringNo);
                        
                        if first_of_father && first_of_mother
                            pair_index = pair_index + 1;
                            pairs(pair_index,1) = father.index;
                            pairs(pair_index,2) = mother.index;
                        end
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function pairs = get_recorded_old_faithful_pairs(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        all_copulations = obj.get_partner_by_ringNo(father.ringNo);
                        %is_old_faithful_pair = false;
                        is_previous_year_copulation = false;
                        is_next_year_copulation = false;
                        for j=1:size(all_copulations,1)
                            if all_copulations{j,2}==year-1
                                is_previous_year_copulation = strcmp(all_copulations{j,1},mother.ringNo);
                            elseif all_copulations{j,2}==year+1
                                is_next_year_copulation = strcmp(all_copulations{j,1},mother.ringNo);
                            end
                        end
                        is_old_faithful_pair = is_previous_year_copulation && is_next_year_copulation;
                        if is_old_faithful_pair
                            pair_index = pair_index + 1;
                            pairs(pair_index,1) = father.index;
                            pairs(pair_index,2) = mother.index;
                        end
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function pairs = get_recorded_old_pairs(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        all_copulations = obj.get_partner_by_ringNo(father.ringNo);
                        %is_old_faithful_pair = false;
                        is_previous_year_copulation = false;
                        for j=1:size(all_copulations,1)
                            if all_copulations{j,2}==year-1
                                is_previous_year_copulation = strcmp(all_copulations{j,1},mother.ringNo);
                            end
                        end
                        if is_previous_year_copulation
                            pair_index = pair_index + 1;
                            pairs(pair_index,1) = father.index;
                            pairs(pair_index,2) = mother.index;
                        end
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function pairs = get_recorded_broken_pairs(obj,BIRDS_DATABASE,year)
            
            total_pairs = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year-1
                    total_pairs = total_pairs + 1;
                end
            end
            
            pairs = zeros(total_pairs,2);
            pair_index = 0;
            for i=1:obj.total_families
                f = obj.families_list{i};
                if f.year == year-1
                    father = BIRDS_DATABASE.get_bird_by_ID(f.father);
                    mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
                    
                    if ~isempty(father) && ~isempty(mother)
                        all_copulations = obj.get_partner_by_ringNo(father.ringNo);
                        
                        %is_old_faithful_pair = false;
                        current_year_copulation = false;
                        for j=1:size(all_copulations,1)
                            if all_copulations{j,2}==year && strcmp(all_copulations{j,1},mother.ringNo)
                                current_year_copulation = true;
                            end
                        end
                        if ~current_year_copulation
                            pair_index = pair_index + 1;
                            pairs(pair_index,1) = father.index;
                            pairs(pair_index,2) = mother.index;
                        end
                    end
                end
            end
            
            pairs(sum(pairs,2)==0,:) = [];
        end
        
        function divorced_pairs = get_recorded_divorced_pairs(obj,BIRDS_DATABASE,year)
            
            old_pairs = obj.get_recorded_old_pairs(BIRDS_DATABASE,year-1);
            new_pairs = obj.get_recorded_new_pairs(BIRDS_DATABASE,year);
            
            divorced_pairs = [];
            
            for i=1:size(old_pairs,1)
               if ~isempty(new_pairs == old_pairs(i,1)) && ~isempty(new_pairs == old_pairs(i,2))
                  divorced_pairs(i,:) = [old_pairs(i,1) old_pairs(i,2)];
               end
            end
            
%             total_pairs = 0;
%             for i=1:obj.total_families
%                 f = obj.families_list{i};
%                 if f.year == year-1
%                     total_pairs = total_pairs + 1;
%                 end
%             end
%             
%             pairs = zeros(total_pairs,2);
%             pair_index = 0;
%             for i=1:obj.total_families
%                 f = obj.families_list{i};
%                 if f.year == year-1
%                     father = BIRDS_DATABASE.get_bird_by_ID(f.father);
%                     mother = BIRDS_DATABASE.get_bird_by_ID(f.mother);
%                     
%                     if ~isempty(father) && ~isempty(mother)
%                         all_copulations = obj.get_partner_by_ringNo(father.ringNo);
%                         
%                         %is_old_faithful_pair = false;
%                         current_year_copulation = false;
%                         for j=1:size(all_copulations,1)
%                             if all_copulations{j,2}==year && strcmp(all_copulations{j,1},mother.ringNo)
%                                 current_year_copulation = true;
%                             end
%                         end
%                         if ~current_year_copulation
%                             pair_index = pair_index + 1;
%                             pairs(pair_index,1) = father.index;
%                             pairs(pair_index,2) = mother.index;
%                         end
%                     end
%                 end
%             end
%             
%             pairs(sum(pairs,2)==0,:) = [];
        end
        
        function are_siblings = are_siblings_by_ringNo(obj,i_ringNo,j_ringNo)
            if isempty(i_ringNo) || isempty(j_ringNo)
                are_siblings = false;
                return;
            end
            
            %i_ringNo = BIRDS_DATABASE.get_bird_by_index(i_data_index);
            i_pedigree_index = get(obj.birds_table,i_ringNo);
            
            %j_ringNo = BIRDS_DATABASE.get_bird_by_index(j_data_index);
            j_pedigree_index = get(obj.birds_table,j_ringNo);
            
            % check if siblings
            b_i_child = 1*(obj.B(i_pedigree_index,:)==-1);
            b_j_child = 1*(obj.B(j_pedigree_index,:)==-1);
            
            are_siblings = (b_i_child*b_j_child') == 1;
        end
        
        function are_siblings = are_siblings_by_index(obj,BIRDS_DATABASE,i_external_index,j_external_index)
            i_ringNo = BIRDS_DATABASE.get_bird_by_index(i_external_index).ringNo;
            j_ringNo = BIRDS_DATABASE.get_bird_by_index(j_external_index).ringNo;
            
            are_siblings = are_siblings_by_ringNo(obj,i_ringNo,j_ringNo);
        end
        
        function [r relatedness_label] = get_relatedness_coefficient_by_ringNo(obj,i_ringNo,j_ringNo)
            % check if same
            if strcmp(i_ringNo,j_ringNo)
                r = 1;
                relatedness_label = 'same';
                return;
            end
            
            %i_ringNo = BIRDS_DATABASE.get_bird_by_index(i_data_index);
            i_pedigree_index = get(obj.birds_table,i_ringNo);
            
            %j_ringNo = BIRDS_DATABASE.get_bird_by_index(j_data_index);
            j_pedigree_index = get(obj.birds_table,j_ringNo);
            
            if isempty(i_pedigree_index) || isempty(j_pedigree_index)
                r = 0;
                relatedness_label = 'unknown';
                return;
            end
            
            
            % check if siblings
            b_i_child = 1*(obj.B(i_pedigree_index,:)==-1);
            b_j_child = 1*(obj.B(j_pedigree_index,:)==-1);
            
            are_siblings = (b_i_child*b_j_child') == 1;
            
            if are_siblings
                r = .5;
                relatedness_label = 'siblings';
                return
            end
            
            % check if parent_child
            b_i_parent = 1*(obj.B(i_pedigree_index,:)==1);
            b_j_parent = 1*(obj.B(j_pedigree_index,:)==1);
            
            are_parent_offspring = (b_i_child * b_j_parent' == 1) || (b_i_parent * b_j_child' == 1);
            
            if are_parent_offspring
                r = .5;
                relatedness_label = 'parent_offspring';
                return
            end
            
            % check if half-siblings
            [i_dad i_mom] = obj.get_parents(i_ringNo);
            [j_dad j_mom] = obj.get_parents(j_ringNo);
            
            are_half_siblings = strcmp(i_dad,j_dad) || strcmp(j_mom,i_mom);
            
            if are_half_siblings
                r = .25;
                relatedness_label = 'half_siblings';
                return
            end
            
            % check if cousins
            S = zeros(2);
            S(1,1) = obj.are_siblings(i_dad,j_dad);
            S(1,2) = obj.are_siblings(i_dad,j_mom);
            S(2,2) = obj.are_siblings(j_mom,j_mom);
            
            are_cousins = sum(sum(S)) == 1;
            
            if are_cousins
                r =  .125;
                relatedness_label = 'cousins';
                return
            end
            
            r = 0;
            relatedness_label = 'unknown';
        end
        
        function [r relatedness_label] = get_relatedness_coefficient_by_index(obj,BIRDS_DATABASE,i_external_index,j_external_index)
            i_ringNo = BIRDS_DATABASE.get_bird_by_index(i_external_index).ringNo;
            j_ringNo = BIRDS_DATABASE.get_bird_by_index(j_external_index).ringNo;
            
            [r relatedness_label] = get_relatedness_coefficient_by_ringNo(obj,i_ringNo,j_ringNo);
        end
    end
end