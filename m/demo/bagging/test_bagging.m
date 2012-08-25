%>@file
%>@ingroup demo
%>@brief Bagging test - 2D example
%>
%> Uses a 2D artificial data to show the classification boundaries of component classifiers and of the overall
%> classifier.
%>
%> @image html test_bagging_result01.png
%> <center>Figure 1 - classification domains of 6 component classifiers, each one trained on 10% of the data points
%> randomly picked.</center>
%>
%> @image html test_bagging_result02.png
%> <center>Figure 1 - classification domain of classifier resulting from bagging the 6 classifiers represented in Figure 1.</center>

colors_markers();


%Dataset load
ds01 = load_userdata_nc2nf2;

ofsgt1 = fsgt_infgain();

o = clssr_tree();
o.pruningtype = 3;
o.chi2threshold = 0;
o.fsgt = ofsgt1;
clssr_tree01 = o;


%Creates classifier
clssr_svm01 = clssr_svm();
clssr_svm01.c = 2;
clssr_svm01.gamma = 1.2;

o = sgs_randsub();
o.bites = .05;
o.type = 'balanced';
o.no_reps = 6;
o.randomseed = 0;
o.flag_perclass = 1;
sgs03 = o;

esag01 = esag_linear1();

o = aggr_bag();
o.block_mold = clssr_svm01;
o.sgs = sgs03;
o.esag = esag01;
clssr = o;

clssr = clssr.boot();
clssr = clssr.train(ds01);




pars.x_range = [1, 6];
pars.y_range = [3, 8];
pars.x_no = 200;
pars.y_no = 200;
pars.ds_train = ds01;
pars.ds_test = [];
pars.flag_last_point = 1;
pars.flag_link_points = 0;
% pars.filename = find_filename('video_evolving', '', 'gif');
pars.flag_regions = 1;

figure;
colors_markers;

for i = 1:6
    subplot(2, 3, i);
    clssr.blocks(i).block.draw_domain(pars);
end;

figure;
clssr.draw_domain(pars);

% disp(clssr.get_treedescription());
