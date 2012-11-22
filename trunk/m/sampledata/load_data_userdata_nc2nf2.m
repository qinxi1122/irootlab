%>@brief Loads sample data userdata_nc2nf2.txt
%>@file
%>@ingroup demo sampledata

function ds = load_data_userdata_nc2nf2()

o = dataio_txt_pir();
o.filename = fullfile(get_rootdir(), 'sampledata', 'userdata_nc2nf2.txt');
ds = o.load();
