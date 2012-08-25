%> @ingroup conversion string
%> @file
%> @brief Converts cell to string.
%> The generated string will produce the same cell (i.e., c again) if eval()'uated.
%>
%> Works only if the elements from c are strings. Originally designed to be used by datatool.
%
%>@param c
%>@return \em s
function s = cell2str(c)
s = '{';
for i = 1:length(c)
    if i > 1; s = [s ', ']; end;
    if isstr(c{i})
        s = [s '''' c{i} ''''];
    else
        s = [s mat2str(c{i})];
    end;
end;
s = [s '}'];
