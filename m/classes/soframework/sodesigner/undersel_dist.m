%> architecture optimization for the dist classifier
%>
%>
classdef undersel_dist < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_dist_unders;
        end;
    end;

end
