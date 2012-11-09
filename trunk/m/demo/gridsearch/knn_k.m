Rewrite this using reptt_blockcube to show the concept

%>@ingroup demo
%>@file
%>@brief Grid search to obtain best k-NN's k
%>
%> Uses UCI's Wine dataset.
%>
%> @image html knn_k_result.png


%Dataset load
ds01 = load_data_uci_wine;

%Creates classifier
clssr_knn01 = clssr_knn();
clssr_knn01 = clssr_knn01.setbatch({'k', 1});


% -- @ 29-Aug-2011 23:53:39
o = sgs_crossval();
o = o.setbatch({'flag_group', 0, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'flag_loo', 0, ...
'no_reps', 50});
sgs_crossval02 = o;


ra = rater();
ra.data = ds01;
ra.sgs = sgs_crossval02;



gs01 = gridsearch();
gs01.no_iterations = 1;
gs01.obj = clssr_knn01;
gs01 = gs01.add_param('k', 1, 5, 5, 1); % (ParameterName, InitialValue, FinalValue, NumberOfPoints, flag_linear)
gs01.f_get_rate = @(cl) ra.get_rate_with_clssr(cl);




%%

gs01 = gs01.go();

out = gs01.result;


%%



figure;
plot(out.tickss{1}, out.rates);
hold on;
plot(out.tickss{1}(out.idx_best), out.rates(out.idx_best), 'ro');
xlabel('k-NN''s ''k''');
ylabel('Classification rate');
legend({'Rates', 'Best'});
title('1D grid search demo using k-NN');
format_frank();