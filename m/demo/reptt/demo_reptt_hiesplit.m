%>@ingroup demo
%>@file
%>@brief Demonstrates use of the @ref reptt_hiesplit class
%>
%>@sa reptt_hiesplit
%>
%>@image html Screenshot-demo_reptt_hiesplit_result.png
%> @todo but I think this is obsolete
colors_markers();


%----- The dataset

ddemo = load_she5trays;

o = blmisc_split_classes();
o = o.setbatch({'hierarchy', 1});
blmisc_split_classes02 = o;
[blmisc_split_classes02, out] = blmisc_split_classes02.use(ddemo);
ddemo_classes01_01 = out(1);
ddemo_classes01_02 = out(2);
ddemo_classes01_03 = out(3);
ddemo_classes01_04 = out(4);
ddemo_classes01_05 = out(5);

%Rename irdata object
ddemo_test = ddemo_classes01_05; clear ddemo_classes01_05;

o = blmisc_merge_rows();
blmisc_merge_rows01 = o;
[blmisc_merge_rows01, out] = blmisc_merge_rows01.use([ddemo_classes01_01, ddemo_classes01_02, ddemo_classes01_03, ddemo_classes01_04]);
irdata_rows01 = out;

%Rename irdata object
ddemo_train = irdata_rows01; clear irdata_rows01;


%-------- A few objects needed

o = blmisc_classlabels_hierarchy();
o = o.setbatch({'hierarchy', 2});
blmisc_classlabels_hierarchy01 = o;
[blmisc_classlabels_hierarchy01, out] = blmisc_classlabels_hierarchy01.use(ddemo_test);
ddemo_test_hierarchy01 = out;


o = estlog_classxclass();
o.estlabels = ddemo_test_hierarchy01.classlabels; % Class labels for log are 'N', 'T'
o.testlabels = ddemo_test_hierarchy01.classlabels;
estlog_classxclass01 = o;

o = decider();
o = o.setbatch({'decisionthreshold', 0});
decider01 = o;



%-------- Classifier to be used

o = fcon_lda();
o = o.setbatch({'penalty', 0});
fcon_lda01 = o;

o = clssr_dist();
o = o.setbatch({'normtype', 'euclidean', ...
'flag_pr', 0});
clssr_dist01 = o;

o = block_cascade();
o = o.setbatch({'blocks', {fcon_lda01, clssr_dist01}});
block_cascade01 = o;


%-------- The star of the demo

% -- Code started at 29-Aug-2011 15:35:11
o = reptt_hiesplit();
o = o.setbatch({'data', ddemo_train, ...
'postpr_test', [], ...
'postpr_est', decider01, ...
'log_mold', {estlog_classxclass01}, ...
'block_mold', {block_cascade01}, ...
'data_test', ddemo_test, ...
'no_reps', 200, ...
'hie_split', 1, ...
'hie_classify', 2, ...
'randomseed', 0});
reptt_hiesplit01 = o;

out = reptt_hiesplit01.go();
reptt_hiesplit_hiesplit01 = out;
