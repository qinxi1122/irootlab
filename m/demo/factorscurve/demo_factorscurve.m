%> Calculates a curve (number of factors)X(Classification rate)

ds = load_data_she5trays();
ds = data_select_hierarchy(ds, 2); % N/T

cl = clssr_d();
fe = fcon_pca();
fe.title = 'PCA';

fc = factorscurve();
fc.clssr = cl;
fc.fcon_mold = fe;
fc.flag_parallel = 1; % <------------------------Note that it will try to use the MATLAB Parallel Computing Toolbox
fc.no_factors_max = ds.nf;
out = fc.use(ds); % Output is a dataset

vi = vis_hachures();
figure;
vi.use(out);

