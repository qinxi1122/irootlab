%> @ingroup as tentative
%> @brief Calculates grades as loadings vector
%>
%> @sa feasel_corr
classdef as_grades_loadings < as_grades_data
    properties
        %> @ref fcon_linear block to calculade loadings
        fcon_linear;
        %> =1. Which loadings vector to use. 1 makes sense in most cases.
        idx_loadings = 1;
    end;
    
    methods
        function o = as_grades_loadings()
            o.classtitle = 'Loadings';
        end;

        function out = go(o)
            da1 = o.data(1);

            blk = o.fcon_linear.boot();
            blk = blk.train(da1);

            out = log_grades();
            out.grades = abs(blk.L(:, o.idx_loadings))';
            out.fea_x = da1.fea_x;
            out.xname = da1.xname;
            out.xunit = da1.xunit;
            out.yname = blk.get_description;
        end;
    end;   
end
