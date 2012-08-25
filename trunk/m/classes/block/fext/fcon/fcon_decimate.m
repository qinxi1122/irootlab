%> Decimation - makes averages of adjacent features
classdef fcon_decimate < fcon
    properties
        %> = 2. Decimation factor. Curves will have floor(original_size*1/factor) number of point after decimation
        factor = 2;
    end;

    methods
        function o = fcon_decimate(o)
            o.classtitle = 'Decimation';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, data] = do_use(o, data)
            data.fea_x = decim(data.fea_x, o.factor);
            data.X = decim(data.X, o.factor);
        end;
    end;
end
