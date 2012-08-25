%>@ingroup demo
%>@file
%>@brief OBSOLETE Demonstrates use of the @ref reptt_sgs class
%>
%> @sa reptt_sgs
colors_markers();

ddemo = load_she5trays;
ddemo = data_select_hierarchy(ddemo, 1);


% Classifiers to be used

o = clssr_cla();
o = o.setbatch({'type', 'linear'});
clssr_cla01 = o;

o = clssr_cla();
o = o.setbatch({'type', 'quadratic'});
clssr_cla02 = o;

o = clssr_dist();
o = o.setbatch({'normtype', 'euclidean', ...
'flag_pr', 0});
clssr_dist01 = o;




o = estlog_classxclass();
o.estlabels = ddemo.classlabels;
o.testlabels = ddemo.classlabels;
estlog_classxclass01 = o;

o = sgs_crossval();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'flag_loo', 0, ...
'no_reps', 10});
sgs_crossval01 = o;

o = vectorcomp_ttest();
vectorcomp_ttest01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;

o = reptt_sgs();
o = o.setbatch({'data', ddemo, ...
'postpr_test', [], ...
'postpr_est', decider01, ...
'log_mold', {estlog_classxclass01}, ...
'block_mold', {clssr_cla01, clssr_cla02, clssr_dist01}, ...
'sgs', sgs_crossval01, ...
'vectorcomp', vectorcomp_ttest01});
reptt_sgs01 = o;


out = reptt_sgs01.go();
reptt_sgs_sgs03 = out;


% Shows comparisons

out = reptt_sgs_sgs03.extract_comparison();
log_comparison_sgs01 = out{1, 1};

o = vis_html();
o.use(log_comparison_sgs01);



% Shows rates/confusion matrices from one of the classifiers

out = reptt_sgs_sgs03.extract_logs();
estlog_classxclass_sgs01 = out{1, 1};
estlog_classxclass_sgs02 = out{1, 2};
estlog_classxclass_sgs03 = out{1, 3};

%> Quadratic classifier (second log)
o = report_ttlog();
o = o.setbatch({'flag_individual', 1});
o.use(estlog_classxclass_sgs02);


% Shows 1D scatter plot where different classifiers are represented by different classes - NOW THIS IS COOL!
out = reptt_sgs_sgs03.extract_datasets();
irdata_sgs01 = out{1, 1};

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 1});
figure;
o.use(irdata_sgs01);

