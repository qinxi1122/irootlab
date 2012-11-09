%> @brief Unit - Histogram
%>
%> Same as Integer, but plots as histogram (stem plot). Affects @ref bmtable
classdef bmunit_hist < bmunit
    methods
        function o = bmunit_hist(o)
            o.classtitle = 'Histogram';
            o.yformat = '%3d';
            o.flag_zeroline = 0;
            o.flag_zero = 1;
            o.flag_hist = 1;
        end;
    end;
end