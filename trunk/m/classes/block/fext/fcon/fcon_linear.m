%> Feature Construction - Linear Transformations base class
classdef fcon_linear < fcon
    properties
        %> Prefix for the factos space variables, e.g., "PC", "LD"
        t_fea_prefix = 'LIN';
        %> Names of the factors!
        t_fea_names = [];
        %> Loadings vector
        L = [];
        %> Loadings x-axis (in this case, the up-to-down dimension)
        L_fea_x;
        %> Name of loadings x-axis
        xname;
        xunit;
    end;

    
    methods
        function o = fcon_linear()
            o.classtitle = 'Linear Transformation';
        end;
        
        function s = get_t_fea_name(o, idx)
            if ~isempty(o.t_fea_names)
                if numel(o.t_fea_names) < idx
                    irerror(sprintf('t_fea_names size %d < %d', numel(o.t_fea_names), idx));
                end;
                s = o.t_fea_names{idx};
            elseif ~isempty(o.t_fea_prefix)
                s = [o.t_fea_prefix, int2str(idx)];
            else
                s = int2str(idx);
            end;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data = data.transform_linear(o.L, o.t_fea_prefix);
        end;
    end;
end
