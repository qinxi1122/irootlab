%>@ingroup string
%>@file
%>@brief Removes double quotes from both ends of the string.

function s = strip_quotes(s)
if s(1) == 34
    s = s(2:end);
end;
if s(end) == 34
    s = s(1:end-1);
end;
