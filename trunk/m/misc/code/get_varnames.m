%>@ingroup code
%> @file
%> @brief Variable names in workspace matching class
%>
%> Returns a cell of string containing the names of the variables in the workspace that match @c classname
function vars = get_varnames(classname)
if ~iscell(classname)
    classname = {classname};
end;
vars0 = evalin('base', 'who');
n = numel(vars0);

flag_progress = n > 100;

if flag_progress
    ipro = progress2_open('GET_VARNAMES', [], 0, n);
end;

vars = {};
for i = 1:n
    if ~ismember({'o', 'ans', 'out'}, vars0{i}) %> operational names such as 'o' are excluded from list
        var = evalin('base', [vars0{i}, ';']);
        if sum(arrayfun(@(cn) isa(var, cn{1}), classname)) > 0
            vars{end+1} = vars0{i};
        end;
    end;
    
    if flag_progress
        ipro = progress2_change(ipro, [], [], i);
    end;
end;

if flag_progress
    progress2_close(ipro);
end;