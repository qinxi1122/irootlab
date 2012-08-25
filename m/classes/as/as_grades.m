%> @ingroup as
%> @brief Analysis Session that calculates a "grades" vector
classdef as_grades < as
    methods
        function o = as_grades()
            o.classtitle = 'Grades calculator';
        end;
    end;
    
    methods
        %> "Abstract". Should be overriden and return @ ref log_grades object
        function out = go(o) %#ok<MANU>
            out = [];
        end;
    end;    
end
