%> Creates a .m file that creates instantializes the classes in the "jobs" directory.
%>
%> This is to force the MATLAB compiler to compile all these classes
function make_classcreator()


files = {'goer', 'sodesigner'};
dirs = {};
for i = 1:numel(files)
    a = which(files{i}); % Gets full path to a random file that is inside the "jobs" directory
    [path1, dummy] = fileparts(a);
    dirs{end+1} = path1;
end;

h = fopen('classcreator.m', 'w');
fwrite(h, ['function classcreator(x)', 10, 'if nargin < 1; x = 0; end', 10, 10, 'if x', 10]);


for k = 1:numel(dirs)
    d = dir(fullfile(dirs{k}, '*.m'));
        
    for j = 1:numel(d)
        [pa, fi, ex] = fileparts(d(j).name); %#ok<*NASGU>
        
        if ~strcmp(fi, 'classcreator')
            fwrite(h, ['  o = ', fi, '();', 10]);
        end;
    end;
end;

more = {'iroot'};


for k = 1:numel(more)
    fwrite(h, ['  o = ', more{k}, '();', 10]);
end;


fwrite(h, ['end', 10]);
fclose(h);


