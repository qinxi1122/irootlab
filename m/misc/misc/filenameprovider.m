%> @ingroup misc
%> @file
%> @brief Class to make up file names
classdef filenameprovider
    properties
        %> Identifier to be part of the generated filenames
        id = 'vera';
        %> Whether to always generate the name of a file which does not yet exist
        flag_unique = 0;
    end;
    
    methods
        %> @param token =[] (optional) A string to be in the middle of the generated file name
        %> @param ext ='mat' Extension
        function name = get_filename(o, token, ext)
            if nargin < 3 || isempty(ext)
                ext = 'mat';
            end;
            
            if nargin < 2
                token = [];
            end;
            
            prefix = sprintf('%s%s', o.id, iif(isempty(token), '', ['_', token]));
            
            if o.flag_unique
                name = find_filename(prefix, [], ext);
            else
                name = sprintf('%s.%s', prefix, ext);
            end;
        end;
    end;
end
