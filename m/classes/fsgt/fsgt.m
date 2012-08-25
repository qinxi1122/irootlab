%> @ingroup fsgt
%> FSGT - Feature Subset Grader dedicated to decision Trees
%>
%> One may ask why not use (or adapt) @ref fsg? The main reason is that @ref fsgt returns the chosen feature and
%> cut-point also.
classdef fsgt < irobj

    properties(SetAccess=protected)
        flag_pairwise = 0;
        flag_univariate = 0;
        grade;
        %> Cell of matrices of @c irdata datasets
        subddd;
        %> Prepared.
        flag_sgs;
    end;
    
    methods
        %> Abstract.
        %>
        %> @retval [grades, idx, threshold]
        function [grades, idx, threshold] = test(o, X, classes)
            grades = [];
            idx = [];
            threshold = [];
        end;
        
        function o = fsgt(o)
            o.classtitle = 'FSG Trees';
        end;
    end;   
end
