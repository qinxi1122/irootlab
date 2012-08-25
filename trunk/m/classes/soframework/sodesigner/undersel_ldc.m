%> architecture optimization for the ldc classifier
%>
%>
classdef undersel_ldc < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_ldc_unders;
        end;
    end;

end
