%>@ingroup misc
%> @file
%> @brief Extracts file name from figure handle and calls @c iroothelp()
function call_help(hFigure)
[~, prefix, ~, ~] = fileparts(get(hFigure, 'FileName'));
iroothelp(prefix);
