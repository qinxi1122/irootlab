%> Classification Domain
classdef vis_clssr2d < vis
    methods
        function o = vis_clssr2d(o)
            o.classtitle = 'Classification Domain';
            o.inputclass = 'clssr';
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = [];
            %> @todo still TODO
        end;
    end;
end