%> @brief Unit - percentage
classdef bmunit_perc < bmunit
    methods
        function o = bmunit_perc(o)
            o.classtitle = 'Percentage';
            o.yformat = '%5.1f%%';
            o.flag_zeroline = 0;
        end;
    end;
end