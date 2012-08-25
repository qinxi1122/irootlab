%>@ingroup demos
%>@file
%>@brief Demonstrates use of the @ref rater class
%>
%>@image html demo_rater_result03.png
colors_markers();

ddemo = load_she5trays;
ddemo = data_select_hierarchy(ddemo, 1); % Selects B/C/E/F/G classes only

o = rater();
o = o.setbatch({'clssr', [], ...
'decider', [], ...
'sgs', [], ...
'ttlog', [], ...
'data', ddemo});
rater01 = o;

log_raterout = rater01.go();


o = report_estlog();
o = o.setbatch({'flag_individual', 1});
htmllog = o.use(log_raterout);

htmllog.open_in_browser();

% % Confusion balls
% out = log_raterout.extract_confusion();
% confusion_classxclass01 = out;
% 
% o = vis_balls();
% figure;
% o.use(confusion_classxclass01);


% The next plots show the distributions of the classification rates along the diagonal of the confusion matrix
ds_rows = log_raterout.extract_datasets();

o = vis_scatter1d();
o = o.setbatch({'type_distr', 1, ...
'idx_fea', NaN});
visobj = o;


for i = 1:numel(ds_rows)
    ds_row = ds_rows(i);

    figure;
    visobj.idx_fea = i+1;
    visobj.use(ds_row);
    legend off;
end;