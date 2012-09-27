%> @brief Logs the activity of an iterative feature selection
%>
%> For example, some one who uses it is @ref as_fsel_fb
%>
classdef log_iterativefsel < irlog
    properties
        %> structure array containing fields:
        %> @arg @c idxs_in cell array containing vectors of feature indexes
        idxs_in = {};
        %> Vectors of grades (each element matches one list of indexes in @ref idxs_in
        grades = [];
    end;
    
    methods
        function o = log_iterativefsel()
            o.classtitle = 'Feature Selection';
            o.flag_ui = 0;
        end;
        
        function [nf_in, grades] = extract_curve(o)
            nf_in = cellfun(@(v) (numel(v)), o.idxs_in);
            grades = o.grades;
        end;
    end;
end
