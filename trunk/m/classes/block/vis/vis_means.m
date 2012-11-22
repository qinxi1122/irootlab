%> @brief Visualization - Class means
classdef vis_means < vis
    methods
        function o = vis_means(o)
            o.classtitle = 'Class means';
            o.inputclass = 'irdata';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            data_draw_means(obj);
            make_box();
        end;
    end;
end
