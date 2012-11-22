%>@brief Loads sample data userdata_nc2nf2.txt
%>@file
%>@ingroup demo sampledata

function ds = load_data_uci_wine()

o = dataio_txt_basic();
o.filename = fullfile(get_rootdir(), 'sampledata', 'uci_wine.txt');
ds = o.load();
