%>@ingroup demo
%>@file
%>@brief Grid search to SVM's best c and gamma
%>
%> Uses userdata_nc2nf2 dataset
%>
%> @image html svm_c_gamma_result01.png
%> @image html svm_c_gamma_result02.png


%IRoot started @ 03-Jun-2010 21:15:26


%Dataset load
ds01 = load_userdata_nc2nf2;

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
gs01.no_iterations = 2;
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


