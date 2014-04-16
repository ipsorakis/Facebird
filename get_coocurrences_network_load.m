function L = get_coocurrences_network_load(W,X)

O = get_opportunity_matrix(X);

e = sum(sum(get_triu_vector(W)));
e_total = sum(sum(get_triu_vector(O)));

L = e/e_total;

end