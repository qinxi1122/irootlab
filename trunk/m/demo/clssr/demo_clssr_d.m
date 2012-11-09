%>@file
%>@ingroup demo
%>@brief Demonstrates use of @ref clssr_d
%>
%>@sa clssr_d
%>
%>
%> @image html demo_clssr_d_result01.png

dslila = load_data_userdata_nc2nf2;

clssr = clssr_d();
clssr.flag_use_priors = 0;

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

%%
if 0
    clssr.type = 'linear';
    clssr = clssr.boot();
    clssr = clssr.train(dslila);

    figure;
    colors_markers;
    clssr.draw_domain(pars);
    title('Linear case');
end;
%%

clssr.type = 'quadratic';
clssr = clssr.boot();
clssr = clssr.train(dslila);

figure;
colors_markers;
clssr.draw_domain(pars);
title('Quadratic case');