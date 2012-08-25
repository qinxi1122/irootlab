%> @ingroup globals setupgroup
%> @file
%> @brief Asserts the @c PATH global is present and initialized.
%>
%> The @c PATH global is a structuer with the following fields
%> @arg @c data Default path to datasets (datatool will point to this directory at the file load box)
function path_assert()
global PATH;
if isempty(PATH)
    PATH.data_load = '.';
    PATH.data_save = '.';
    PATH.data_spectra = '.';
    
    % default documentation path
%     path = get_rootdir();
%     PATH.doc = fullfile(path, 'doc');
    PATH.doc = 'http://bioph.lancs.ac.uk/irootdoc';
end;
