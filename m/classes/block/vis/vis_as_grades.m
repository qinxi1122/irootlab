%> @brief Visual representation of @ref as_grades object
classdef vis_as_grades < vis
    properties
        data_hint = [];
    end;
    
    methods
        function o = vis_as_grades(o)
            o.classtitle = 'Grades';
            o.inputclass = 'as_grades';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            obj.draw(o.data_hint);
        end;
    end;
end
