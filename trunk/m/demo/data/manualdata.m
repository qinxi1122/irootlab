%> @brief Shows how to assemble a dataset (class irdata) from existing MATLAB matrices
%> @ingroup demo
%> @file
%>
%> This example uses random X and classes, but can serve as a basis.

ds = irdata();
ds.X = rand(250, 100);               % dataset will have no=1000 and nf=100

ds.classes = floor(rand(250, 1)*10); % assigns classes randomly from (possible values: 0 to 10)

ds.fea_x = linspace(4000, 400, 100);  % Informs that the features are wavenumbers within the mid-IR region (in decreasing order)
ds.xname = 'Wavenumbers';
ds.xunit = 'cm^{-1}';
ds.yname = 'Absorbance';
ds.yunit = 'arbitrary units';

ds = ds.assert_fix();                 % Checks for matching dimensions; auto-creates the class labels

figure;
data_draw(ds);
