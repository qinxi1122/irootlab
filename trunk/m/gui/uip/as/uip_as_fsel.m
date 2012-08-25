%> @ingroup guigroup
%> @file
%> @brief Properties for a @ref as_fsel
%>
%> Actually, just asks for a dataset
%
%> @cond
function result = uip_as_fsel(o, data0)
result.flag_ok = 0;
while 1
    if result.flag_ok
        break;
    end;
    
    r = ask_dataset([], [], 0);
    if ~r.flag_ok
        break;
    end;
    result.params = r.params;
    result.flag_ok = 1;
end;
%>@endcond