%> @brief Normalization - std Normalization
%>
%> @sa normaliz.m
classdef pre_norm_std < pre_norm_base
    methods
        function o = pre_norm_std()
            o.classtitle = 'Standardization';
            o.short = 'Std';
            o.types = 's';
        end;
    end;
end