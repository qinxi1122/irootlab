%> architecture optimization for the knn classifier
%>
%>
classdef undersel_knn < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_knn_unders;
        end;
    end;
end
