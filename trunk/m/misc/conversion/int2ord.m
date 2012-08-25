%> @ingroup conversion string
%> @file
%> @brief Converts integer to ordinal number string
%>
%> @param idx Integer number
function out = int2ord(idx)


if idx == 1
    s = 'st';
elseif idx == 2
    s = 'nd';
elseif idx == 3
    s = 'rd';
else
    s = 'th';
end;

out = sprintf('%d%s', idx, s);