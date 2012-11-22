%>@brief Loads sample data raman_sample.mat
%>@file
%>@ingroup demo sampledata

function ds = load_data_raman_sample()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'raman_sample.mat');
ds = o.load();
