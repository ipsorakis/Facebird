function s_out = remove_quotation_marks(s_in)
s_out = cell(length(s_in),1);

for i=1:length(s_in)
    elems = strsplit(s_in{i},'"');
    if length(elems)==1
        s_out{i} = elems{1};
    elseif length(elems)==3
        s_out{i} = elems{2};
    end
    
    
    % convert date to american format
    if i==2
       components = strsplit(s_out{i},'-');
       s_out{i} = strcat(components{2},'-',components{1},'-',components{3});
    end
end