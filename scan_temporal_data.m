CHILDREN = zeros(N,1);
for i=1:N
bird = BIRDS_DATABASE.get_bird_by_index(i);
children = PEDIGREE.get_number_of_children(bird.ringNo,8)
CHILDREN(i) = children;
end