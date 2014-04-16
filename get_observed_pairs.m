function [Pindices Pids] = get_observed_pairs(BIRDS_DATABASE,PEDIGREE,year)

Pindices = zeros(BIRDS_DATABASE.birds_number,1);
Pids = cell(BIRDS_DATABASE.birds_number,1);

for i=1:BIRDS_DATABASE.birds_number
   current_bird = BIRDS_DATABASE.get_bird_by_index(i);
   birdID = current_bird.ringNo;
   
   partnerID = PEDIGREE.get_partner(birdID,year);   
   
   Pids{i} = partnerID;
   
   if ~isempty(partnerID) && ~isempty(BIRDS_DATABASE.get_bird_by_ID(partnerID))
       partner = BIRDS_DATABASE.get_bird_by_ID(partnerID);       
       Pindices(i) = partner.index;
   end
end

end