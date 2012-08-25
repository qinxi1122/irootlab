%> @brief Log of a @ref fsel object activity
%>
%> @todo I don't remember when and what for this is used.
classdef log_fsel < irlog
    properties
        %> structure array containing fields:
        %> @arg @c idxs_in cell array containing vectors of feature indexes
        %> @arg @c grades corresponding grades
        steps = struct('idxs_in', {}, 'grades', {});
    end;
    
    methods
        function o = log_fsel(o)
            o.classtitle = 'Feature Selection';
        end;
    end;
end
