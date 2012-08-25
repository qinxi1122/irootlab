%> @brief Visualization - Stacked histograms
%>
%> Accessible from objtool, but not configurable (will use properties defaults).
classdef vis_stackedhists < vis
    properties
        data_hint = [];
        peakdetector = def_peakdetector();
        colors = {[], .85*[1, 1, 1]};
        no_informative = Inf;
        %> see @ref as_fsel_hist::weightmode
        weightmode = [];
    end;
    
    methods
        function o = vis_stackedhists(o)
            o.classtitle = 'Stacked Histograms';
            o.inputclass = {'log_hist'};
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = [];
            
            if ~isempty(o.weightmode)
                obj.weightmode = o.weightmode;
                obj = obj.update_from_subsets();
            end;

            obj.draw_stackedhists(o.data_hint, o.colors, o.peakdetector);
        end;
    end;
end