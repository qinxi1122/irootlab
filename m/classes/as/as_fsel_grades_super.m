%> @brief "Super-object" encapsulating both a @ref as_fsel_grades and a @ref as_grades_data object
%>
%> @arg The @ref as_grades_data object calculates the grades vector, whereas ...
%> @arg the @ref as_fsel_grades performs itself the feature selection.
classdef as_fsel_grades_super < as_fsel
    properties
        %> Dataset to be passed to the @ref as_grades_data object
        data;
        
        %> @ref as_grades_data object
        as_grades_data;
        
        %> @ref as_fsel_grades object
        as_fsel_grades;
    end;
    
    properties(Dependent)
        %> Number of features to be selected
        nf_select;
    end;
    
    methods
        function o = as_fsel_grades_super()
            o.classtitle = 'Grades super-object';
        end;
        
        function log2 = go(o)
            o.as_grades_data.data = o.data;
            log1 = o.as_grades_data.go();
            o.as_fsel_grades.input = log1;
            log2 = o.as_fsel_grades.go();
        end;
        
        function n = get.nf_select(o)
            n = NaN;
            if ~isempty(o.as_fsel_grades)
                n = o.as_fsel_grades.nf_select;
            end;
        end;
        
        function o = set.nf_select(o, n)
            if ~isempty(o.as_fsel_grades)
                o.as_fsel_grades.nf_select = n;
            end;
        end;
    end;
end
