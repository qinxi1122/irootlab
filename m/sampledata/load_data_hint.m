%>@brief Loads the hint dataset: this dataset containg one spectrum only: 1800-900 cm^-1
%>@file
%>@ingroup demo sampledata
%>
%> This dataset containg one spectrum only 1800-900 cm^-1

function ds = load_hintdataset()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'hintdataset.mat');
ds = o.load();
