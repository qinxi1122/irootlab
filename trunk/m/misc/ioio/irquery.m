%>@ingroup ioio
%>@file
%>@brief Wraps over mYm to recover from the "MySQL server has gone away" error
function r = irquery(varargin)
try
    r = mym(varargin{:});
catch ME
    if strfind(ME.message, 'gone away') || strfind(ME.message, 'ost connection')
        assert_connected_to_cells();
        r = mym(varargin{:}); % tries again
    else
        rethrow(ME);
    end;
end;
