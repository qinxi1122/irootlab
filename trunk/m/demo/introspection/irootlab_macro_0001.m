% Log filename: /home/j/Documents/phd/evel/m/irootlab-development/irootlab/trunk/m/demo/introspection/irootlab_macro_0001.m
%Creating some default objects...
clssr_default = def_clssr();
peakdetector_default = def_peakdetector();
sgs_default = def_sgs();
subsetsprocessor_default = def_subsetsprocessor();
biocomparer_default = def_biocomparer();
fsg_clssr_default = fsg_clssr();
fsg_clssr_default.clssr = clssr_default;
fsg_clssr_default.sgs = sgs_default;
% -- @ 07-Nov-2012 18:01:48
o = fsel();
o.v_type = 'rx';
o.flag_complement = 0;
o.v = [1800, 900];
fsel01 = o;
[fsel01, out] = fsel01.use(ds);
ds_fsel01 = out;

% -- @ 07-Nov-2012 18:02:01
o = fsel();
o.v_type = 'rx';
o.flag_complement = 0;
o.v = [1800, 900];
fsel02 = o;
[fsel02, out] = fsel02.use(ds);
ds_fsel02 = out;

% -- @ 07-Nov-2012 18:02:35
o = fsel();
o.v_type = 'rx';
o.flag_complement = 0;
o.v = [1800, 900];
fsel03 = o;
[fsel03, out] = fsel03.use(ds);
ds_fsel03 = out;

% -- @ 07-Nov-2012 18:49:44
o = pre_bc_asls();
o.p = 0.001;
o.lambda = 100000;
o.no_iterations = 10;
pre_bc_asls01 = o;
[pre_bc_asls01, out] = pre_bc_asls01.use(ds);
ds_asls01 = out;

% -- @ 07-Nov-2012 18:49:51
o = vis_means();
vis_means01 = o;
figure;
vis_means01.use(ds_asls01);

% -- @ 07-Nov-2012 18:51:20
o = vis_means();
vis_means02 = o;
figure;
vis_means02.use(ds_asls01);

% -- @ 07-Nov-2012 18:55:39
o = blmisc_split_classes();
o.hierarchy = [];
blmisc_split_classes01 = o;
[blmisc_split_classes01, out] = blmisc_split_classes01.use(ds);
ds_classes01_01 = out(1);
ds_classes01_02 = out(2);
ds_classes01_03 = out(3);
ds_classes01_04 = out(4);
ds_classes01_05 = out(5);
ds_classes01_06 = out(6);
ds_classes01_07 = out(7);
ds_classes01_08 = out(8);
ds_classes01_09 = out(9);
ds_classes01_10 = out(10);

% -- @ 07-Nov-2012 18:55:54
o = blmisc_merge_rows();
blmisc_merge_rows01 = o;
[blmisc_merge_rows01, out] = blmisc_merge_rows01.use([ds_classes01_01, ds_classes01_02, ds_classes01_03, ds_classes01_04, ds_classes01_05, ds_classes01_06, ds_classes01_07, ds_classes01_08]);
irdata_rows01 = out;

