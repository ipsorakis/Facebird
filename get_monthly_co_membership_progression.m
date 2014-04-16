function [KS_p_random_vs_new KS_p_random_vs_old KS_p_old_vs_divorced KS_k_random_vs_new KS_k_random_vs_old KS_k_old_vs_divorced]...
    = get_monthly_co_membership_progression(Cframes_daily,month_indices_in_days,BIRDS_DATABASE,PEDIGREE)


total_months = length(month_indices_in_days);

KS_p_random_vs_new = zeros(total_months,1);
KS_p_random_vs_old = zeros(total_months,1);
KS_p_old_vs_divorced = zeros(total_months,1);

N = BIRDS_DATABASE.birds_number;


parfor month_index = 1:total_months
    
    C = zeros(N);
    day_range = month_indices_in_days{month_index};
    
    for d = day_range(1):day_range(2)
        Ccur = decompress_adjacency_matrix(Cframes_daily{d});        
        if ~isempty(Ccur)
            C = C + Ccur;
        end
    end
    
    co_membership_distributions = get_co_membership_distribution(BIRDS_DATABASE,PEDIGREE,C,0);
    
    %[junk1 pn kn] = kstest2(co_membership_distributions.Pnorm(:,1),co_membership_distributions.Pnorm(:,2));
    [junk1 pn kn] = kstest2(co_membership_distributions.random_pair_values,co_membership_distributions.new_pair_values);
    n1 = length(co_membership_distributions.random_pair_values);
    n2 = length(co_membership_distributions.new_pair_values);    
    KS_p_random_vs_new(month_index) = pn;
    KS_k_random_vs_new(month_index) = n1*n2/(n1+n2);
    
    [junk1 po ko] = kstest2(co_membership_distributions.random_pair_values,co_membership_distributions.old_pair_values);
    n3 = length(co_membership_distributions.old_pair_values);
    KS_p_random_vs_old(month_index) = po;
    KS_k_random_vs_old(month_index) = n1*n3/(n1+n3);
    
    [junk1 pd kd] = kstest2(co_membership_distributions.old_pair_values,co_membership_distributions.divorced_pair_values);
    n4 = length(co_membership_distributions.divorced_pair_values);
    KS_p_old_vs_divorced(month_index) = pd;
    KS_k_old_vs_divorced(month_index) = n2*n4/(n2+n4);
end

end