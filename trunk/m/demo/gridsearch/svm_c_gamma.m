%>@ingroup demo
%>@file
%>@brief Grid search to SVM's best c and gamma
%>
%> @image html svm_c_gamma_result01.png
%> @image html svm_c_gamma_result02.png


%Dataset load
% ds01 = load_data_she5trays();
% u = cascade_stdhie();
% u.blocks{2}.hierarchy = 2;
% cascade_stdhie01 = u;
% cascade_stdhie01 = cascade_stdhie01.boot();
% [cascade_stdhie01, out] = cascade_stdhie01.use(ds01);
% ds01_stdhie01 = out;
ds01 = load_data_uci_wine();

pre_std01 = pre_norm_std();

ds01 = pre_std01.use(ds01);

%Creates classifier
clssr_svm01 = clssr_svm();
clssr_svm01.c = 1e-1;
clssr_svm01.gamma = 1e-3;

u = sgs_crossval();
u.flag_group = 1;
u.flag_perclass = 0;
u.randomseed = 0;
u.flag_loo = 0;
u.no_reps = 10;
sgs_crossval01 = u;

u = gridsearch();
u.sgs = sgs_crossval01;
u.clssr = clssr_svm01;
u.chooser = [];
u.postpr_test = [];
u.postpr_est = [];
u.log_mold = {};
u.no_iterations = 3;
u.maxtries = 3;
u.paramspecs = {'c', 10.^(-9:2:2), 1; 'gamma', 10.^(-7:1), 1};
gridsearch01 = u;

%%

% Calculation

log_gridsearch01 = gridsearch01.use(ds01);

%%

% Visualization

u = vis_sovalues_drawimage();
u.dimspec = {[0 0], [1 2]};
u.valuesfieldname = 'rates';
u.clim = [];
u.flag_logtake = 0;
vis_sovalues_drawimage01 = u;

out = log_gridsearch01.extract_sovaluess();

figure;
no = numel(out);
for i = 1:no
    subplot(1, no, i);
    vis_sovalues_drawimage01.use(out{i});
    title(out{i}.title);
end;
maximize_window([], no);
save_as_png([], 'svm_c_gamma');