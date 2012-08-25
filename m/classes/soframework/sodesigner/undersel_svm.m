%> architecture optimization for the svm classifier
%>
%>
classdef undersel_svm < undersel
    methods
        function o = customize(o)
            o = customize@undersel(o);
            o.unders = o.oo.undersel_svm_unders;
        end;
    end;
end
