%>@file
%>@ingroup demo
%>@brief Loads sample data uglyspectrum.mat

function ds = load_uglyspectrum()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'uglyspectrum.mat');
ds = o.load();
