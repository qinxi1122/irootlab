%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref blmisc_classlabels_rename
%>
%> Asks for new class labels
%>
%> @sa blmisc_classlabels_rename
%>
%> @image html Screenshot-Rename.png
%
%> @cond
function result = uip_blmisc_classlabels_rename(o, data)
result.flag_ok = 0;
scl = cell2str(data.classlabels);
n = numel(data.classlabels);
while 1
    flag_break = 0;
    p = inputdlg('Enter new classlabels (class labels)', 'Rename', 1, {scl});
    if ~isempty(p)
        scl = p{1};
        flag_error = 0;
        serror = '';
        try
            new_codes = eval(scl);
        catch ME
            serror = ME.message;
            flag_error = 1;
        end;
        
        if ~flag_error
            if ~iscell(new_codes)
                flag_error = 1;
                serror = 'Invalid new class labels!';
            elseif numel(new_codes) ~= n
                flag_error = 1;
                serror = 'Wrong number of labels!';
            else
                result.params = {'classlabels_new', cell2str(new_codes)};
                result.flag_ok = 1;
                flag_break = 1;
            end;
        end;
        
        if flag_error
            irerrordlg(serror, 'Error');
        end;
    else
        flag_break = 1;
    end;
    
    if flag_break
        break;
    end;
end;
%> @endcond
