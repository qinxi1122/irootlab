%> @brief Shows how to assemble a dataset from existing MATLAB matrices (Fisher Iris data example)
%> @ingroup demo
%> @file
%>
%> Loads the "Fisher Iris" dataset that comes with the Statistics Toolbox

load fisheriris; % Gives the "meas" and "species" variables

ds = irdata();
ds.X = meas;
ds.classlabels = unique(species);
for i = 1:numel(ds.classlabels)
    ds.classes(strcmp(species, ds.classlabels{i}), 1) = i-1;
end;

ds.fea_names = {'sepal length', 'sepal width', 'petal length', 'petal width'};
ds.xname = 'Characteristics';
ds.yunit = '';
ds.yname = 'Measure';
ds.yunit = '?';
ds = ds.assert_fix(); % Checks for matching dimensions; auto-creates the class labels

figure;
u = vis_scatter2d();
u.idx_fea = 1:4;
u.confidences = [];
u.textmode = 0;
vis_scatter2d01 = u;
figure;
vis_scatter2d01.use(ds);
maximize_window();
save_as_png([], 'irr_fisheriris_scatter2d');