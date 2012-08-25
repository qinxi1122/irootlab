%> architecture optimization for the ann classifier
%>
%>
classdef undersel_ann < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_ann_unders;
        end;
    end;
end
