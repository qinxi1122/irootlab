%>@brief Loads Ketan's brain cancer dataset
%>@file
%>@ingroup demo sampledata

function ds = load_data_ketan_brain_atr()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'ketan_brain_atr.mat');
ds = o.load();
