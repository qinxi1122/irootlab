%> Feature Construction - Linear Transformations base class
classdef fcon_linear < fcon
    properties
        %> Feature prefix. If set, will be passed to @irdata::transform_linear() to build feature names such as "PC1",
        %> "PC2", or "LD1", "LD2".
        fea_prefix = [];
        %> Feature names.
        fea_names = [];
        %> Loadings vector
        L = [];
        %> Loadings x-axis (in this case, the up-to-down dimension)
        L_fea_x;
        %> All objects with the @c get_grades capability must have the @c grades_x property as well, to equalize for @ref bmtable
        grades_x;
        %> Name of loadings x-axix
        xname;
        xunit;
    end;

    
    methods
        function o = fcon_linear(o)
            o.classtitle = 'Linear Transformations';
        end;
        
        %> Sensitive to "idx_fea" and "flag_abs" in @c params
        function z = get_grades(o, params)
            pp = setbatch(struct(), params);
            if ~isfield(pp, 'idx_fea')
                pp.idx_fea = 1;
            end;
            z = o.L(:, pp.idx_fea)';
            if isfield(pp, 'flag_abs') && pp.flag_abs
                z = abs(z);
            end;
        end;

        function z = get.grades_x(o)
            z = o.L_fea_x;
        end;

        %> bmtable integration
        function z = get_grades_x(o, params)
            z = o.grades_x();
        end;
        
        function z = get_gradeslegend(o, params)
            pp = setbatch(struct(), params);
            if ~isfield(pp, 'idx_fea')
                pp.idx_fea = 1;
            end;
            z = get_gradeslegend@fcon(o, params);
            if ~isempty(o.fea_names)
                z = [z, iif(~isempty(z), ', ', ''), o.fea_names{pp.idx_fea}];
            else
                z = [z, iif(~isempty(z), ', ', ''), o.fea_prefix, int2str(pp.idx_fea)];
            end;
        end;
    end;
    
    methods(Access=protected)
        function [o, data] = do_use(o, data)
            data = data.transform_linear(o.L, o.fea_prefix);
        end;
    end;
end
