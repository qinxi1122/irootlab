%> @brief Art stuff for BioMarker Tables
%>
%> @sa bmtable
classdef bmart < irobj
    properties
        marker = 'o';
        markerscale = 1;
        % color already defined in irobj.
    end;
    
    methods
        function o = bmart(o)
            o.classtitle = 'Art';
        end;
    end;
end