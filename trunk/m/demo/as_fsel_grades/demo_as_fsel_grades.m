%>@ingroup demo
%>@brief Demo for the @ref as_fsel_grades class
%>@file
%>
%> This file demonstrates how to use @ref as_fsel_grades class.

ds = load_she5trays();
ds = data_select_hierarchy(ds, 2);

o = clssr_d();
o = o.setbatch({'type', 'linear'});

clssr_d01 = o;

o = sgs_crossval();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 999, ...
'flag_loo', 0, ...
'no_reps', 10});

sgs_crossval01 = o;

o = fsg_clssr();
o = o.setbatch({'clssr', clssr_d01, ...
'estlog', [], ...
'postpr_est', [], ...
'postpr_test', [], ...
'sgs', sgs_crossval01});

fsg_clssr01 = o;

o = peakdetector();
o = o.setbatch({'flag_perc', 1, ...
'flag_abs', 1, ...
'minaltitude', 0, ...
'minheight', 0, ...
'mindist', 1, ...
'no_max', 0});

peakdetector01 = o;

o = as_fsel_grades_fsg();
o = o.setbatch({'data', ds, ...
'fsg', fsg_clssr01, ...
'type', 'none', ...
'nf_select', 10, ...
'threshold', -log10(0.05), ...
'peakdetector', peakdetector01, ...
'flag_optimize', 1});

as_fsel_grades_fsg01 = o;

as_fsel_grades_fsg_noopt = o;
as_fsel_grades_fsg_noopt.flag_optimize = 0;


out = as_fsel_grades_fsg01.go();

as_fsel_grades_fsg_fsg01 = out;

o = vis_as_fsel();
o = o.setbatch({'data_hint', ds01, 'flag_mark', 1});

figure;
o.use(as_fsel_grades_fsg_fsg01);
title('With final optimization');
xlabel('Wavenumber (cm^{-1})');
ylabel('Performance (%)');

out = as_fsel_grades_fsg_fsg01.extract_dataset();

data_out01 = out;

o = vis_alldata();
vis_alldata01 = o;

figure;
vis_alldata01.use(data_out01);


%%
as_fsel_grades_fsg_noopt = as_fsel_grades_fsg01;
as_fsel_grades_fsg_noopt.flag_optimize = 0;

out = as_fsel_grades_fsg_noopt.go();
as_fsel_grades_fsg_noopt01 = out;
o = vis_as_fsel();
o = o.setbatch({'data_hint', ds01, 'flag_mark', 1});

figure;
o.use(as_fsel_grades_fsg_noopt01);
title('All peaks detected');
xlabel('Wavenumber (cm^{-1})');
ylabel('Performance (%)');