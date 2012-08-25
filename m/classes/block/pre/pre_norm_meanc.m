%> @brief Normalization - Mean-centering
%>
%> @sa normaliz.m
classdef pre_norm_meanc < pre_norm_base
    methods
        function o = pre_norm_meanc(o)
            o.classtitle = 'Mean-centering';
            o.types = 'c';
        end;
    end;
end