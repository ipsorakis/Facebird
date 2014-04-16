function [PDR participating] = get_partner_dedication_ratio(Aframes,pairs)

months = length(Aframes);

num_pairs = size(pairs,1);

num_birds = 2*num_pairs;

participating = zeros(months,1);

PDR = zeros(months,1);

N = size(Aframes{1},1);
A = zeros(N);

%montly_occurrences = zeros(months,N);

for t=1:months
    A = A + decompress_adjacency_matrix(Aframes{t});
end

s = sum(A);

for t=1:months
    Am = decompress_adjacency_matrix(Aframes{t});
    
    pairs_month = num_pairs;
    for n=1:num_pairs
        i = pairs(n,1);
        j = pairs(n,2);
        
        ay_ij = A(i,j);
        am_ij = Am(i,j);
        
        if ay_ij ~=0
            PDR(t) = PDR(t) + am_ij/ay_ij;
        else
            pairs_month = pairs_month-1;
        end
    end
    
    if pairs_month~=0
        PDR(t) = PDR(t)/pairs_month;
    end
end

%     N = num_birds;
%
%    for n=1:num_pairs
%       i = pairs(n,1);
%       j = pairs(n,2);
%
%       a_ip = A(i,j);
%
%       s_i = sum(A(:,i));
%       s_j = sum(A(:,j));
%
%       if s_i ~=0
%         PDR(t) = PDR(t) + a_ip/s_i;
%       else
%           N=N-1;
%       end
%
%       if s_j~=0
%         PDR(t) = PDR(t) + a_ip/s_j;
%       else
%           N=N-1;
%       end
%    end
%
%    PDR(t) = PDR(t)/N;
%    participating(t) = N;
