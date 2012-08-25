%> Vector Comparer - Normalized Xor
%>
%> Measure of diversity. Vectors must be of same size. 
%> @todo I think this came from Kuncheva's book. Vectors are probably boolean. It seems that the formula lacks a sum(). Never used anyway, I
%> didn't come to the point of refining classifier aggregation.
classdef vectorcomp_xornorm < vectorcomp
    methods(Access=protected)
        function z = do_test(o, v1, v2)
            z = xor(v1, v2)/numel(v1);
        end;
    end;
    
    methods
        function o = vectorcomp_xornorm(o)
            o.classtitle = 'Normalized Xor';
            o.flag_params = 0;
        end;
    end;
end
