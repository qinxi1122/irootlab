%>@ingroup interactive
%>@file
%>@brief OBSOLETE Creates objects for feahist

NO_REPS = input('Enter number of Random Subsampling repetitions: ');
NF_SELECT = input('Enter number of variables for Forward Feature Selection: ');
DSNAME = input('Dataset name: ', 's');

% -- Code started at 28-Sep-2011 21:40:29
o = clssr_cla();
o = o.setbatch({'type', 'linear'});
% -- Finished  at 28-Sep-2011 21:40:29

clssr_cla01 = o;
% -- Finished  at 28-Sep-2011 21:40:29


% -- Code started at 28-Sep-2011 21:43:40
o = sgs_randsub();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'type', 'simple', ...
'bites', [0.8 0.2], ...
'bites_fixed', [90 10], ...
'no_reps', NO_REPS});
% -- Finished  at 28-Sep-2011 21:43:40

sgs_randsub01 = o;
% -- Finished  at 28-Sep-2011 21:43:40


% -- Code started at 28-Sep-2011 21:44:16
o = fsg_clssr();
o = o.setbatch({'clssr', clssr_cla01, ...
'estlog', [], ...
'postpr_est', [], ...
'postpr_test', [], ...
'sgs', []});
% -- Finished  at 28-Sep-2011 21:44:16

fsg_clssr01 = o;
% -- Finished  at 28-Sep-2011 21:44:16


% -- Code started at 28-Sep-2011 21:45:51
o = as_fsel_fb();
o = o.setbatch({'data', [], ...
'nf_select', NF_SELECT, ...
'fsg', fsg_clssr01});
% -- Finished  at 28-Sep-2011 21:45:51

as_fsel_fb01 = o;
% -- Finished  at 28-Sep-2011 21:45:51


% -- Code started at 28-Sep-2011 21:46:38
o = as_fsel_hist();
o = o.setbatch({'data', eval(DSNAME), ...
'type', 'nf', ...
'nf_select', 10, ...
'threshold', -log10(0.05), ...
'peakdetector', [], ...
'as_fsel', as_fsel_fb01, ...
'fext', [], ...
'sgs', sgs_randsub01});
% -- Finished  at 28-Sep-2011 21:46:38

feahist_calculator = o;
% -- Finished  at 28-Sep-2011 21:46:38

