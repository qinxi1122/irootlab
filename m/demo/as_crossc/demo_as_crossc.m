%>@ingroup demo
%>@file
%>@brief Demonstrates @ref as_crossc
%>
%> @image html demo_as_crossc02.png
%> <center>Cross-calculated scores plot</center>
%>
%> @image html demo_as_crossc03.png
%> <center>In-sample-calculated scores plot</center>
%>
%> @image html demo_as_crossc01.png
%> <center>Loadings vectors (1st factor) for each block in the cross-calculation process</center>
%>
%> @sa as_crossc

colors_markers();

dataset = load_data_she5trays();
o = blmisc_classlabels_hierarchy();
o = o.setbatch({'hierarchy', 1});
blmisc_classlabels_hierarchy01 = o;
[blmisc_classlabels_hierarchy01, out] = blmisc_classlabels_hierarchy01.use(dataset);
dataset = out;

o = pre_meanc();
pre_meanc01 = o;

o = fcon_lda();
o = o.setbatch({'penalty', 0});
% -- Finished  at 25-Sep-2011 20:26:35

fcon_lda01 = o;
% -- Finished  at 25-Sep-2011 20:26:35


% -- @ 25-Sep-2011 20:26:50
o = block_cascade();
o = o.setbatch({'blocks', {pre_meanc01, fcon_lda01}});
% -- Finished  at 25-Sep-2011 20:26:50

block_cascade01 = o;
% -- Finished  at 25-Sep-2011 20:26:50


% -- @ 25-Sep-2011 20:27:16
o = as_crossc();
o = o.setbatch({'mold', block_cascade01, ...
'sgs', [], ...
'data', dataset});
% -- Finished  at 25-Sep-2011 20:27:16

as_crossc01 = o;
% -- Finished  at 25-Sep-2011 20:27:16



% -- @ 25-Sep-2011 20:32:28
o = vis_scatter2d();
o = o.setbatch({'idx_fea', [1,2], ...
'confidences', [], ...
'flag_text', 0});
% -- Finished  at 25-Sep-2011 20:32:28

vis_scatter2d01 = o;
% -- Finished  at 25-Sep-2011 20:32:28


% -- @ 25-Sep-2011 21:33:31
out = as_crossc01.go();
% -- Finished  at 25-Sep-2011 21:33:34

as_crossc_crossc01 = out;
% -- Finished  at 25-Sep-2011 21:33:34



% -- @ 25-Sep-2011 22:38:17
o = vis_crossloadings();
o = o.setbatch({'flag_abs', 0, ...
'flag_trace_minalt', 0, ...
'data_hint', [dataset], ...
'peakdetector', [], ...
'idx_fea', 1});
% -- Finished  at 25-Sep-2011 22:38:17

figure;
o.use(as_crossc_crossc01);

% -- @ 25-Sep-2011 22:38:17
o = vis_crossloadings();
o = o.setbatch({'flag_abs', 0, ...
'flag_trace_minalt', 0, ...
'data_hint', [dataset], ...
'peakdetector', [], ...
'idx_fea', 2});
% -- Finished  at 25-Sep-2011 22:38:17

figure;
o.use(as_crossc_crossc01);


% -- @ 25-Sep-2011 23:11:10
out = as_crossc_crossc01.extract_dataset();
% -- Finished  at 25-Sep-2011 23:11:11

irdata_crossc01 = out;
% -- Finished  at 25-Sep-2011 23:11:11


% -- @ 25-Sep-2011 23:11:27
o = vis_scatter2d();
o = o.setbatch({'idx_fea', [1,2], ...
'confidences', [], ...
'flag_text', 0});
% -- Finished  at 25-Sep-2011 23:11:27

figure;
o.use(irdata_crossc01);
% -- Finished  at 25-Sep-2011 23:11:29


% -- @ 25-Sep-2011 23:19:57
pre_meanc01 = pre_meanc01.train(dataset);
% -- Finished  at 25-Sep-2011 23:19:57


% -- @ 25-Sep-2011 23:19:57
[pre_meanc01, out] = pre_meanc01.use(dataset);
% -- Finished  at 25-Sep-2011 23:19:57

lindo_meanc01 = out;
% -- Finished  at 25-Sep-2011 23:19:57


% -- @ 25-Sep-2011 23:20:01
fcon_lda01 = fcon_lda01.train(lindo_meanc01);
% -- Finished  at 25-Sep-2011 23:20:01


% -- @ 25-Sep-2011 23:20:02
[fcon_lda01, out] = fcon_lda01.use(lindo_meanc01);
% -- Finished  at 25-Sep-2011 23:20:02

lindo_meanc01_lda01 = out;
% -- Finished  at 25-Sep-2011 23:20:02


% -- @ 25-Sep-2011 23:20:04
figure;
vis_scatter2d01.use(lindo_meanc01_lda01);
% -- Finished  at 25-Sep-2011 23:20:05

