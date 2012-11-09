%>@ingroup demos
%>@file
%>@brief Demonstrates use of the @ref rater class
%>
%>@image html demo_rater_result03.png
colors_markers();

ddemo = load_data_she5trays;
ddemo = data_select_hierarchy(ddemo, 1);

o = rater();
o = o.setbatch({'clssr', [], ...
'decider', [], ...
'sgs', [], ...
'ttlog', [], ...
'data', ddemo});
rater01 = o;

out = rater01.go();
rater_rater01 = out;

out = rater_rater01.extract_ttlog();
estlog_classxclass_rater01 = out;

o = vis_ttlog_html();
o = o.setbatch({'flag_individual', 1});
o.use(estlog_classxclass_rater01);


out = estlog_classxclass_rater01.extract_datasets();
irdata_classxclass01_01 = out(1);
irdata_classxclass01_02 = out(2);
irdata_classxclass01_03 = out(3);
irdata_classxclass01_04 = out(4);
irdata_classxclass01_05 = out(5);

% The next plots show the distributions of the classification rates of the diagonal of the confusion matrix

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 1});
vis_scatter1d01 = o;
figure;
vis_scatter1d01.use(irdata_classxclass01_01);

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 2});
vis_scatter1d02 = o;
figure;
vis_scatter1d02.use(irdata_classxclass01_02);

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 3});
vis_scatter1d03 = o;
figure;
vis_scatter1d03.use(irdata_classxclass01_03);

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 4});
vis_scatter1d04 = o;
figure;
vis_scatter1d04.use(irdata_classxclass01_04);

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', 5});
vis_scatter1d05 = o;
figure;
vis_scatter1d05.use(irdata_classxclass01_05);

% Confusion balls
out = estlog_classxclass_rater01.extract_confusion();
confusion_classxclass01 = out;

o = vis_balls();
figure;
o.use(confusion_classxclass01);
