%> architecture optimization for the frbm_kg1 classifier
%>
%>
classdef undersel_frbm_kg1 < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_frbm_unders;
        end;
    end;
end

