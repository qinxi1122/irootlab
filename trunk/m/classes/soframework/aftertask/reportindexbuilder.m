%> draws the figures and generates HTML for the architecture-independent
%> design
classdef reportindexbuilder
    methods(Sealed)
        function o = go(o)
            dirs = get_dirs('.');
            no_dirs = numel(dirs);
            
            
            
            ssave = '!@*(&$';
            for i = 1:no_dirs
                s = dirs{i};
                
                if any(strfind(s, 'report'))
                    add dirnow, s to dataset
                else
                    dirnow = s;
                end;
            end;
            
        end;
    end;
end
