%> @brief Visualization - Loadings
%>
%> @sa uip_vis_loadings.m
classdef vis_loadings < vis
    properties
        data_hint = [];
        idx_fea = 1;
        flag_trace_minalt = 0;
        flag_abs = 0;
        peakdetector = [];
        flag_envelope = 0;
        flag_bmtable = 0;
    end;
    
    methods
        function o = vis_loadings(o)
            o.classtitle = 'Loadings';
            o.inputclass = {'fcon_linear', 'block_cascade_base'};
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = [];
            if ~isempty(obj.fea_names)
                legends = obj.fea_names(o.idx_fea);
            else
                nf = length(o.idx_fea);
                legends = cell(1, nf);
                for i = 1:nf
                    legends{i} = ['Factor ' int2str(o.idx_fea(i))];
                end;
            end;
            
            flag_p = ~isempty(o.peakdetector);
            if ~isempty(o.data_hint)
                hintx = o.data_hint.fea_x;
                hinty = mean(o.data_hint.X, 1);
            else
                hintx = [];
                hinty = [];
            end;

            if any(o.idx_fea > size(obj.L, 2))
                irerror(sprintf('There are only %d loadings!', size(obj.L, 2)));
            end;
            
            if ~o.flag_bmtable
                draw_loadings(obj.L_fea_x, obj.L(:, o.idx_fea), hintx, hinty, legends, o.flag_abs, ...
                              o.peakdetector, o.flag_trace_minalt, flag_p, flag_p, 0, o.flag_envelope);
            else
                draw_loadings_pl(obj.L_fea_x, obj.L(:, o.idx_fea), hintx, hinty, legends, o.flag_abs, ...
                              o.peakdetector);
            end;
            format_xaxis(obj);
            make_box();
        end;
    end;
end