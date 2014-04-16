function Bf = flatten_event_cell_array(B,convert_to_binary)

if nargin<2
    convert_to_binary = false;
end

total_days = length(B);
Bf = cell(total_days,1);

for t=1:total_days
   Bt = B{t};
   total_locations = length(Bt);
   Blocal = [];
   for l=1:total_locations
       Blocal = [Blocal;Bt{l}];
   end
   
   if convert_to_binary
       Blocal = 1*logical(Blocal);
   end
   Bf{t} = Blocal;
end

end