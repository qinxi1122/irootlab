%> @brief Visualization - Cluster Vectors
%>
%> @sa uip_vis_cv.m
classdef vis_cv < vis
    properties
        data_input;
        data_hint = [];
        idx_class_origin = 0;
        flag_trace_minalt = 0;
        flag_abs = 0;
        peakdetector = [];
        flag_envelope = 0;
        flag_bmtable = 0;
    end;
    
    methods
        function o = vis_cv(o)
            o.classtitle = 'Cluster Vectors';
            o.inputclass = {'fcon_linear', 'block_cascade_base'};
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            CV = data_get_cv(o.data_input, obj.L, o.idx_class_origin);
            flag_p = ~isempty(o.peakdetector);
            
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;

            % Eliminates the vector corresponding to the origin class
            labels = o.data_input.classlabels;
            colorindexes = 1:size(CV, 2);
            if o.idx_class_origin > 0
                CV(:, o.idx_class_origin) = [];
                labels(o.idx_class_origin) = [];
                colorindexes(o.idx_class_origin) = [];
            end;

            
            if ~o.flag_bmtable
                draw_loadings(o.data_input.fea_x, CV, hintx, hinty, labels, o.flag_abs, ...
                              o.peakdetector, o.flag_trace_minalt, flag_p, flag_p, 0, o.flag_envelope, colorindexes);
                      
            else
                draw_loadings_pl(o.data_input.fea_x, CV, hintx, hinty, labels, o.flag_abs, ...
                              o.peakdetector, colorindexes);
            end;

                      
                      
            format_xaxis(o.data_input);
            make_box();
        end;
    end;
end
