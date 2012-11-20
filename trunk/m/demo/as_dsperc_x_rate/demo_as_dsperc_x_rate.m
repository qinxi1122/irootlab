%>@brief Demonstrates use of the as_dsperc_x_rate - (dataset %) x (classification rate %) curve
%>@ingroup demo
%>@file
%>
%> @image html Screenshot-demo_as_dsperc_x_rate.png
%> <center>Image obtained through the as_dsperc_x_rate::draw_curve() method.</center>
%>
%> @sa as_dsperc_x_rate
fig_assert();

ddemo = load_data_she5trays;
ddemo = data_select_hierarchy(ddemo, 2);

% Applied some feature reduction to eliminate the problem with singular pooled covariance matrix in classify()
o = fcon_pca();
o = o.setbatch({'no_factors', 20, ...
'flag_rotate_factors', 0});
fcon_pca01 = o;
fcon_pca01 = fcon_pca01.train(ddemo);
ddemo = fcon_pca01.use(ddemo);



% Classifiers to be used

o = clssr_d();
o = o.setbatch({'type', 'linear'});
o.title = 'LDC';
clssr_d01 = o;

o = clssr_d();
o = o.setbatch({'type', 'quadratic'});
o.title = 'QDC';
clssr_d02 = o;


o = estlog_classxclass();
o.title = 'accuracy';
o.estlabels = ddemo.classlabels;
o.testlabels = ddemo.classlabels;
estlog_classxclass01 = o;

o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 1, ...
'randomseed', 0, ...
'type', 'simple', ...
'bites', [0.9 0.1], ...
'bites_fixed', [90 10], ...
'no_reps', 50});
sgs01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;

o = reptt_blockcube();
o = o.setbatch({'postpr_test', [], ...
'postpr_est', decider01, ...
'log_mold', {estlog_classxclass01}, ...
'block_mold', {clssr_d01, clssr_d02}, ...
'sgs', sgs01});
cube = o;



o = as_dsperc_x_rate();
o.evaluator = cube;
o.percs_train = .1:.05:.90;
o.perc_test = .1;
lc = o;

%%

lo = lc.use(ddemo);

%%

o = vis_log_celldata();
o.idx = [1, 2];
figure;
o.use(lo);
title(sprintf('Number of spectra in dataset: %d', ddemo.no));
maximize_window([], 1.618);
save_as_png([], 'irr_dsperc_x_rate');
