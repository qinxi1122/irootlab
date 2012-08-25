%> Adds directory to path with recursion into all subdirectories
function addtopath(directory)

dirs = getdirs(directory, {directory});

for i = 1:length(dirs)
    ss = dirs{i};
    disp(['Adding directory ' ss ' ...']);
    addpath(ss);
end;
