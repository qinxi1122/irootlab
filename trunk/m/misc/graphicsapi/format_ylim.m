%>@ingroup graphicsapi
%>@file
%>@brief Assigns y-limits based on [ymin, ymax] pair
%
%> @param vv [ymin, ymax] pair
function format_ylim(yy)

d = diff(yy);
if d < 0
    irerror('Y-limits need be non-decreasing!');
end;
if d == 0
    y = yy(1);
    ylim([y-1, y+1]);
else
    edge = d*0.01;
    ylim(yy+[-edge, edge]);
end;