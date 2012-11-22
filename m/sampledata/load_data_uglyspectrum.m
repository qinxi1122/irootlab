%>@brief Loads sample data uglyspectrum.mat
%>@file
%>@ingroup demo sampledata

function ds = load_data_uglyspectrum()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'uglyspectrum.mat');
ds = o.load();
