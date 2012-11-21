%>@ingroup ioio sheware
%>@file
%>@brief Connects to database specified in the DB global
function connect_to_cells()
db_assert();
global DB;
mym('open', DB.host, DB.user, DB.pass);
mym('use', DB.name);
if mym('status') == 0
    irverbose(sprintf('Connected to DB: "%s"', DB.name), 3);
else
    irerror('Cannot connect to DB.');
end
