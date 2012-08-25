%> @brief sostage - Classification LDC/QDC
%>
%>
classdef sostage_pp_std < sostage_pp
    
    methods
        function o = sostage_pp_std()
            o.title = 'Standardization';
        end;
        
        function out = get_default(o)
            out = pre_norm();
            out.types = 's';
        end;
    end;
end
