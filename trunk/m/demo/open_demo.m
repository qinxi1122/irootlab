function open_demo(s)
try
    eval(s);
catch ME
    irerrordlg(sprintf('Failed runnind demo %s: %s.\nCheck MATLAB command window for more information about the error.', s, ME.message), 'Sorry');
    rethrow(ME);
end;