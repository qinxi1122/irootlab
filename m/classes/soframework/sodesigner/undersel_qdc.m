%> architecture optimization for the qdc classifier
%>
%>
classdef undersel_qdc < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_qdc_unders;
        end;
    end;
end
