%> Log of a Feature Subset Grader object activity
%
classdef log_fsg < irlog
    properties
        %> 1D cell where entries can either be:
        %> @arg single entry for in-sample, non-pairwise fsg's
        %> @arg double entries for in-sample, pairwise fsg's
        %> @arg vector entries for cross-validates, pairwise fsg's
        allgrades = {};
    end;
    
    methods
        function o = log_fsg(o)
            o.classtitle = 'FSG';
            o.flag_ui = 0;
        end;
    end;
end
