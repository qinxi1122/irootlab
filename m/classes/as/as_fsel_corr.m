%> @brief Feature Selection
classdef as_fsel_corr < as_fsel
    properties
        %> =10. Number of features to be selected
        nf_select = 10;
    end;
    
    methods
        function o = as_fsel_corr()
            o.classtitle = 'Corr';
        end;

        function o = go(o)
            o.v = feasel_corr(o.data(1), o.nf_select);
            o.grades = zeros(1, o.data(1).nf);
            o.grades(o.v) = 1;
            o.fea_x = o.data(1).fea_x;
            o.xname = o.data(1).xname;
            o.xunit = o.data(1).xunit;
            o.yname = 'fsel-corr';
        end;
    end;   
end
