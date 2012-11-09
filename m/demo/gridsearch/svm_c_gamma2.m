Why do I need a "2"?

%>@ingroup demo
%>@file
%>@brief Grid search to SVM's best c and gamma
%>
%> Uses she5trays dataset
%>
%>@verbatim
% bests =
% 
%    43.8832   13.2740
%>@endverbatim
%>
%> @image html svm_c_gamma2_1.png
%> <center>Iteration 1</center>
%>
%> @image html svm_c_gamma2_2.png
%> <center>Iteration 1</center>
%>

%Dataset load
ds01 = load_data_she5trays;
o = blmisc_classlabels_hierarchy();
o = o.setbatch({'hierarchy', 2});
blmisc_classlabels_hierarchy01 = o;
[blmisc_classlabels_hierarchy01, out] = blmisc_classlabels_hierarchy01.use(ds01);
ds01 = out;

ps = pre_std();
ps = ps.boot();
ps = ps.train(ds01);

ds01 = ps.use(ds01);



%Creates classifier
clssr_svm01 = clssr_svm();

%SGS creation
o = sgs_crossval();
o.no_reps = 2;
o.randomseed = 0;
o.flag_perclass = 1;
sgs03 = o;

ra = rater();
ra.data = ds01;
ra.sgs = sgs03;

gs01 = gridsearch();
gs01.no_iterations = 1;
gs01.obj = clssr_svm01;
gs01 = gs01.add_param('c', 1e-2, 1e2, 15, 0); % (ParameterName, InitialValue, FinalValue, NumberOfPoints, flag_linear)
gs01 = gs01.add_param('gamma', 1e-2, 1e2, 15, 0);
gs01.f_get_rate = @(cl) ra.get_rate_with_clssr(cl);

%%

gs01 = gs01.go();

out = gs01.result;

%%

for i = 1:gs01.no_iterations

    [xx, yy] = meshgrid(out(i).tickss{1}, out(i).tickss{2});

    figure;
    mesh(xx, yy, out(i).rates');
    set(gca, 'xscale', 'log', 'yscale', 'log', 'Xlim', out(i).tickss{1}([1, end]), 'Ylim', out(i).tickss{2}([1, end]));
    xlabel('C');
    ylabel('gamma');
    zlabel('Classification rate');
    hold on;
    
    bests = [out(i).tickss{1}(out(i).idx_best(1)), out(i).tickss{2}(out(i).idx_best(2))]
    plot3(bests(1), bests(2), out(i).rate_best, 'pk', 'LineWidth', 3, 'MarkerSize', 15);
    title(sprintf('2D grid search demo using SVM - iteration %d', i));
%     format_frank();
end;


