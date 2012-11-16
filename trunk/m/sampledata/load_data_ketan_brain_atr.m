%>@file
%>@ingroup demo
%>@brief Loads the hint dataset
%>
%> This dataset containg one spectrum only 1800-900 cm^-1

function ds = load_data_ketan_brain_atr()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'ketan_brain_atr.mat');
ds = o.load();
