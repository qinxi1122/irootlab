%>@ingroup ioio sheware
%>@file
%>@brief Makes sure we are connected to a database
function assert_connected_to_cells()
db_assert();
flag_error = 0;
try
    a = mym('status');
catch ME %#ok<NASGU>
    % Tolerates one error, but only one
    flag_error = 1;
end;

if flag_error || a ~= 0;
    connect_to_cells();
else
    a = mym('select database()');
    if isempty(a) || isempty(a.('database()'))
        % It is connected to server, but database is not selected
        mym('close');
        connect_to_cells();
    else
        b = a.('database()');
        if isempty(b{1})
            mym('close');
            connect_to_cells();
        end;
    end;
end;

