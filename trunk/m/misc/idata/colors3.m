%>@ingroup graphicsapi idata
%>@file
%>@brief Some color scheme, kindda obsolete
%>
%> if no output argument is specified, throws colors into the COLORS global
%
%> @param scheme is a number but currently there is only one scheme available
function varargout = colors3(scheme)

cc = scheme1();
colors = {};
for i = 1:length(cc)
    colors{end+1} = cc(i, :);
end;

if nargout == 0
    global COLORS;
    COLORS = colors;
else
    varargout = {colors};
end;


function cc = scheme1()
cc = [27, 158, 119; 217, 95, 2; 117, 112, 179; 0, 0, 0]/255;

