%> Returns a list of output filenames
function flag = get_envflag(s)
sflag = getenv(s);
flag = ~isempty(sflag) && str2double(sflag) > 0;

