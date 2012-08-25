%>@ingroup ioio misc
%>@file
%>@brief Loads all MAT files in current directory (that contain a "r" variable inside) into the workspace
%
%> @param patt_match If specified, directories will have to match this pattern
%> @param patt_exclude If specified, directories will have NOT TO match this pattern
function load_all_items(patt_match, patt_exclude)
global TEMP;
if nargin < 1
    patt_match = [];
end;
if nargin < 2
    patt_exclude = [];
end;
names = getfiles('*.mat', patt_match, patt_exclude);
n = numel(names);

for i = 1:n
    name = names{i};
    
    try
        clear('r');
        load(name);
        if exist('r', 'var')
            if isprop(r, 'item') || isfield(r, 'item')
                TEMP = r.item;
                [a, b, c] = fileparts(name); %#ok<*NASGU,*ASGLU>
                s = ['global TEMP; ', good_varname(b), ' = TEMP;'];
                evalin('base', s);
                irverbose(s, 1);
            end;
        end;

    catch ME
        irverbose(sprintf('Failed reading file "%s": %s', name, ME.message), 1);
    end;
end;

evalin('base', 'global TEMP; clear TEMP;');