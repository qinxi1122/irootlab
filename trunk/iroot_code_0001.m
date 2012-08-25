% Log filename: /home/j/Documents/phd/evel/m/iroot_development/iroot/trunk/iroot_code_0001.m
%Dataset load
o = dataio_mat();
o.filename = '/home/j/Documents/phd/data/matlab/ketan/brain/normal_vs_glioblastoma_vs_LG-AA.mat';
ds01 = o.load();% -- Code started at 13-Aug-2012 16:11:54
o = pre_norm_meanc();
pre_norm_meanc01 = o;[pre_norm_meanc01, out] = pre_norm_meanc01.use(ds01);ds01_meanc01 = out;
% -- Code started at 13-Aug-2012 16:12:10
o = fcon_lda();
o.penalty = 0;
o.max_loadings = [];
fcon_lda01 = o;fcon_lda01 = fcon_lda01.train(ds01_meanc01);[fcon_lda01, out] = fcon_lda01.use(ds01_meanc01);ds01_meanc01_lda01 = out;
% -- Code started at 13-Aug-2012 16:12:28
o = as_crossc();
o.mold = fcon_lda01;
o.sgs = [];
o.data = ds01_meanc01;
as_crossc01 = o;
% -- Code started at 13-Aug-2012 16:12:31
out = as_crossc01.go();log_as_crossc_crossc01 = out;
% -- Code started at 13-Aug-2012 16:12:54
o = vis_crossloadings();
o.flag_abs = 0;
o.flag_trace_minalt = 0;
o.flag_envelope = 0;
o.data_hint = [];
o.peakdetector = [];
o.flag_bmtable = 0;
o.idx_fea = 1;
figure;o.use(log_as_crossc_crossc01);
% -- Code started at 13-Aug-2012 16:13:38
out = log_as_crossc_crossc01.extract_dataset();irdata_crossc01 = out;
% -- Code started at 13-Aug-2012 16:13:50
o = vis_scatter2d();
o.idx_fea = [1,2];
o.confidences = [];
o.textmode = 0;
vis_scatter2d01 = o;figure;vis_scatter2d01.use(irdata_crossc01);
% -- Code started at 13-Aug-2012 16:14:33
figure;vis_scatter2d01.use(ds01_meanc01_lda01);
% -- Code started at 13-Aug-2012 16:15:53
o = vis_scatter2d();
o.idx_fea = [1,2];
o.confidences = [];
o.textmode = 2;
vis_scatter2d02 = o;figure;vis_scatter2d02.use(irdata_crossc01);
%Dataset load
o = dataio_mat();
o.filename = '/home/j/Documents/phd/data/matlab/ketan/brain/atr.mat';
ds02 = o.load();% -- Code started at 13-Aug-2012 16:38:36
[pre_norm_meanc01, out] = pre_norm_meanc01.use(ds02);ds02_meanc01 = out;
% -- Code started at 13-Aug-2012 16:38:57
o = rater();
o.clssr = [];
o.decider = [];
o.sgs = [];
o.ttlog = [];
o.data = ds02_meanc01;
rater01 = o;
% -- Code started at 13-Aug-2012 16:39:00
out = rater01.go();estlog_classxclass_rater01 = out;
% -- Code started at 13-Aug-2012 16:39:18
o = report_estlog();
o.flag_individual = 0;
o.flag_balls = 1;
[o, out] = o.use(estlog_classxclass_rater01);log_html_estlog01 = out;out.open_in_browser();
% -- Code started at 13-Aug-2012 16:39:56
o = blmisc_classlabels_hierarchy();
o.hierarchy = 1;
blmisc_classlabels_hierarchy01 = o;[blmisc_classlabels_hierarchy01, out] = blmisc_classlabels_hierarchy01.use(ds02_meanc01);ds02_meanc01_hierarchy01 = out;
% -- Code started at 13-Aug-2012 16:40:16
o = rater();
o.clssr = [];
o.decider = [];
o.sgs = [];
o.ttlog = [];
o.data = ds02_meanc01_hierarchy01;
rater02 = o;
% -- Code started at 13-Aug-2012 16:40:18
out = rater02.go();estlog_classxclass_rater02 = out;
% -- Code started at 13-Aug-2012 16:40:31
o = report_estlog();
o.flag_individual = 0;
o.flag_balls = 1;
[o, out] = o.use(estlog_classxclass_rater02);log_html_estlog02 = out;out.open_in_browser();
%Dataset load
o = dataio_mat();
o.filename = '/home/j/Documents/phd/data/matlab/ketan/brain/atr.mat';
ds03 = o.load();% -- Code started at 13-Aug-2012 19:37:44
o = vis_means();
vis_means01 = o;figure;vis_means01.use(ds03);
