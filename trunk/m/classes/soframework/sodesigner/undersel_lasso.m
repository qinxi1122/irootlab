%> architecture optimization for the lasso classifier
%>
%>
classdef undersel_lasso < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_lasso_unders;
        end;
    end;

end
