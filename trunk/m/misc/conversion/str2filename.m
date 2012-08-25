%>@ingroup conversion string
%>@file
%>@brief Eliminates invalid characters so that string becomes suitable to be a filename
%
%> @param s
%> @return filename
function filename = str2filename(s)
len = size(s, 2);
for i = 1:len
    ch = s(i);
    if ~(ch >= 'a' & ch <= 'z' | ch >= 'A' & ch <= 'Z' | ch == ' ' | ch == '_' | ch >= '0' & ch <= '9' | ch == '-')
        s(i) = '_';
    end;
end;

filename = s;

