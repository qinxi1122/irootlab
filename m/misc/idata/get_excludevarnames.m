%>@ingroup code idata
%>@file
%>@brief Returns a list of variables not to be brought from the workspace
%
function vars = get_excludevarnames()
vars = {'u', 'ans', 'out', 'TEMP'};