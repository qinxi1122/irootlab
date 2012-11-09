%>@ingroup demo
%>@file
%>@brief Demonstrates use of the @ref reptt_bag class
%>
%> @sa reptt_bag
%>
%>@image html Screenshot-demo_reptt_bag_result.png
colors_markers();

ddemo = load_data_she5trays;
ddemo = data_select_hierarchy(ddemo, 1);


% Classifiers to be used



% -- @ 29-Aug-2011 01:02:05
o = fcon_lda();
o = o.setbatch({'penalty', 0});
fcon_lda01 = o;

% -- @ 29-Aug-2011 01:02:21
o = clssr_dist();
o = o.setbatch({'normtype', 'euclidean', ...
'flag_pr', 0});
clssr_dist01 = o;

% -- @ 29-Aug-2011 01:02:49
o = block_cascade();
o = o.setbatch({'blocks', {fcon_lda01, clssr_dist01}});
block_cascade01 = o;


% -- @ 28-Aug-2011 23:35:03
o = sgs_randsub();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'type', 'simple', ...
'bites', 0.5, ...
'bites_fixed', [90 10], ...
'no_reps', 1});
sgs_randsub01 = o;

% -- @ 28-Aug-2011 23:36:35
o = aggr_bag();
o = o.setbatch({'block_mold', block_cascade01, ...
'sgs', sgs_randsub01});
aggr_bag01 = o;





o = estlog_classxclass();
o.estlabels = ddemo.classlabels;
o.testlabels = ddemo.classlabels;
estlog_classxclass01 = o;

o = sgs_crossval();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'flag_loo', 0, ...
'no_reps', 5});
sgs_crossval01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;

o = reptt_bag();
o = o.setbatch({'data', ddemo, ...
'postpr_test', [], ...
'postpr_est', decider01, ...
'log_mold', {estlog_classxclass01}, ...
'block_mold', {aggr_bag01}, ...
'sgs', sgs_crossval01, ...
'no_bagreps', 30 ...
});
reptt_bag01 = o;


out = reptt_bag01.go();
reptt_bag01_bag01 = out;




% Visualizes results

out = reptt_bag01_bag01.extract_curves();
irdata_bag01 = out{1, 1};

% -- @ 29-Aug-2011 12:23:39
o = vis_alldata();
figure;
o.use(irdata_bag01);

