%> @brief Visual representation of univariate feature selectio
classdef vis_as_fsel < vis
    properties
        data_hint = [];
        flag_mark = 0;
    end;
    
    methods
        function o = vis_as_fsel(o)
            o.classtitle = 'Features Selected';
            o.inputclass = 'as_fsel';
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = [];
            obj.draw(o.data_hint, o.flag_mark);
        end;
    end;
end