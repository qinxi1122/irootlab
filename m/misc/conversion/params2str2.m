%>@ingroup conversion string
%>@file
%>@brief Converts a parameters cell into a string
%>
%> This one makes no distinction between even and odd elements in @c params.
%> @sa param2str.m
%
%> @param params
%> @return s
function s = params2str2(params)

s = '{';
for i = 1:length(params)
    if i > 1; s = [s ', ']; end;
    s = [s params{i}];
end;
s = [s '}'];
