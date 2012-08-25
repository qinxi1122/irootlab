%> architecture optimization for the ls classifier
%>
%>
classdef undersel_ls < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_ls_unders;
        end;
    end;
end

