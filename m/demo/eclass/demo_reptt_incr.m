%> @file
%> @ingroup demo
%> @brief Demonstrates the reptt_incr class with classifier eClass
%>
%> This example shows how an incremental classifier can vary its performance depending on the order the training data is fed into the classifier.
%>
%> @image html demo_reptt_incr.png

if 1
    ds01 = load_she5trays();
    ds01 = data_select_hierarchy(ds01, 2); % Only N/T
else
    ds01 = load_uci_wine();
end;

% 90% for training, 10% separate test set
o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 0, ...
'randomseed', 1234, ...
'type', 'simple', ...
'bites', [.9 .1], ...
'bites_fixed', [90 10], ...
'no_reps', 10});
sgs00 = o;

pieces = ds01.split_map(sgs00.get_obsidxs(ds01));


o = frbm();
o = o.setbatch({'scale', 0.8, ...
'epsilon', exp(-1), ...
'flag_consider_Pmin', 1, ...
'flag_perclass', 1, ...
'flag_clone_rule_radii', 1, ...
'flag_iospace', 1, ...
's_f_get_firing', 'frbm_firing_exp_default', ...
's_f_update_rules', 'frbm_update_rules_kg1', ...
'flag_rls_global', 0, ...
'rho', 0.5, ...
'ts_order', 0, ...
'flag_wta', 0, ...
'flag_class2mo', 1});

frbm01 = o;
frbm01.flag_rtrecord = 1;
frbm01.record_every = 3;
frbm01.title = 'eClass0 1 rule per class';

o = frbm();
o = o.setbatch({'scale', 0.8, ...
'epsilon', exp(-1), ...
'flag_consider_Pmin', 1, ...
'flag_perclass', 0, ...
'flag_clone_rule_radii', 1, ...
'flag_iospace', 1, ...
's_f_get_firing', 'frbm_firing_exp_default', ...
's_f_update_rules', 'frbm_update_rules_kg1', ...
'flag_rls_global', 0, ...
'rho', 0.5, ...
'ts_order', 1, ...
'flag_wta', 0, ...
'flag_class2mo', 1});

frbm02 = o;
frbm02.flag_rtrecord = 1;
frbm02.record_every = 3;
frbm02.title = 'eClass1 1 rule only';

% -- @ 28-Aug-2011 23:35:03
o = sgs_randsub();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 0, ...
'randomseed', 4321, ...
'type', 'simple', ...
'bites', 1, ...
'bites_fixed', [90 10], ...
'no_reps', 2});
sgs01 = o;

o = estlog_classxclass();
o.estlabels = ds01.classlabels;
% -- @ 24-Jan-2012 19:20:43

o.testlabels = ds01.classlabels;
estlog_classxclass01 = o;


o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;




oi = reptt_incr();
oi.block_mold = {frbm01, frbm02};
oi.log_mold = {estlog_classxclass01};
oi.postpr_est = decider01;
oi.sgs = sgs01;
oi.flag_parallel = 1;
oi.data = pieces;


oi = oi.go();
oi = oi.clean();


out = oi.extract_datasets();

irdata_incr01 = out{1, 1};

o = vis_alldata();

vis_alldata01 = o;

figure;
vis_alldata01.use(irdata_incr01);



o = vis_means();

vis_means01 = o;

figure;
vis_means01.use(irdata_incr01);
