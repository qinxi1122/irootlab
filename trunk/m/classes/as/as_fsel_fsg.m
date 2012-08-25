%> @brief Base class for Feature Selection AS's that use a @ref fsg object to grade the features/feature subsets.
%>
%> Difference between this and @ref as_fsel_grades_fsg is that the latter is a final class and the feature selection is
%> univariate.
%>
%> <b>Developers</b> please note that implementations within the go() path must consider receiving a vector of two
%> datasets (or more) (for further information, see for example @ref fsg_clssr)
classdef as_fsel_fsg < as_fsel
    properties
        %> Dataset
        data;
        %> Feature Subset Grader object.
        fsg = [];
    end;

    methods(Access=protected)
        %> Abstract
        function o = do_go(o)
        end;
    end;
    
    methods
        function o = as_fsel_fsg()
            o.classtitle = 'FSG';
        end;

        %#######
        %> Wrapper to @ o.fsg.calculate_grades() to implement logging capability
        %> @param idxs Cell of vectors.
        function z = get_idxsgrades(o, idxs)
            z = o.fsg.calculate_grades(idxs);
        end;
        
        function o = draw(o, data_hint, flag_mark)
            if ~exist('data_hint', 'var')
                data_hint = [];
            end;
            
            o.draw_grades(data_hint, 1);
            o.draw_markers();
            o.draw_finish();
        end;

        %>
        %> Please not that @c data needs to be a 2-element vector if required by the @ref fsg, for example, a @ref fsg
        %> that uses a classifier and does not use cross-validation
        function log = go(o)
            o.fsg.data = o.data;
            o.fsg = o.fsg.boot();
            
            log = o.do_go();
        end;

    end;   
end
