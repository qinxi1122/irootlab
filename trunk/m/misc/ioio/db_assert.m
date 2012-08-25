%>@ingroup globals ioio reinforcement setupgroup sheware
%>@file
%>@brief Makes sure the DB global exists
function db_assert()
global DB;
if isempty(DB)
    DB.host = 'bioph.lancs.ac.uk';
    DB.user = 'cells_user';
    DB.pass = 'meogrrk';
    DB.name = 'cells';
end;
