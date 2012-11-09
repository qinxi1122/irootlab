%>@file
%>@ingroup demo
%>@brief Demonstrates use of @ref clssr_knn
%>
%>@sa clssr_d
%>
%>
%> @image html demo_clssr_knn_result01.png

dslila = load_data_userdata_nc2nf2;

clssr = clssr_knn();

% est = clssr.use(dslila);
% de = decider();
% est = de.use(est);

pars.x_range = [1, 6];
pars.y_range = [3, 8];
pars.x_no = 200;
pars.y_no = 200;
pars.ds_train = dslila;
pars.ds_test = [];
pars.flag_last_point = 1;
pars.flag_link_points = 0;
pars.flag_regions = 1;

K = [1, 10];
no_k = numel(K);
for i = 1:no_k
    clssr.k = K(i);
    clssr = clssr.boot();
    clssr = clssr.train(dslila);

    figure;
    colors_markers;
    clssr.draw_domain(pars);
    title(sprintf('k = %d', K(i)));
end;

