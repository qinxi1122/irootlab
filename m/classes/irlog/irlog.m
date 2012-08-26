%> @brief Log base class
%>
%> A Log is currently defined as a piece of data that cannot be properly stored as a @c irdata object, and whose existence
%> is justified by it having particular visualizations.
classdef irlog < irobj
    methods
        function o = irlog(o)
            o.classtitle = 'Log';
            o.color = [250, 234, 130]/255;
        end;
    end;
end
