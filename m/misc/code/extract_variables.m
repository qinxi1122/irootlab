%>@ingroup code
%>@file
%>@brief Creates variables in the base workspace from an array or cell
%>
%> @params 
function extract_variables(in, suffix, prefix)

if ~iscell(in)
    in = num2cell(in);
end;

global OUT;
OUT = in;

if ~exist('suffix', 'var')
    suffixx = '';
else
    suffixx = ['_', suffix];
end;
if ~exist('prefix', 'var')
    prefixx = '';
else
    prefixx = [prefix, '_'];
end;

% if ~iscell(in)
%     in = {in};
% end;

[ni, nj] = size(in);
for i = 1:ni
    for j = 1:nj
        inij = in{i, j};
        sij = sprintf('{%d, %d}', i, j);
        inname = find_varname([prefixx, class(inij), suffixx]);
        scode = sprintf('global OUT; %s = OUT%s;\n', inname, sij);
        evalin('base', scode);
    end;
end;
