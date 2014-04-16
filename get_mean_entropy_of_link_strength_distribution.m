function H = get_mean_entropy_of_link_strength_distribution(Wsum)
Wsum = decompress_adjacency_matrix(Wsum);

N = size(Wsum,1);

H = 0;
number_of_active=0;

for n=1:N
    connectivity_profile = Wsum(:,n);
    if sum(connectivity_profile)~=0
        number_of_active = number_of_active+1;
        
        d = connectivity_profile/sum(connectivity_profile);
        
        d(d==0)=[];
        
        Hn = get_entropy(d');
        H = H + Hn;
        
    end
end

H = H / number_of_active;
end