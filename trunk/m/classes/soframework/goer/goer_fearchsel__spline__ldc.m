%> Feature Extraction Design - Partial Least Squares - ldc classifier
classdef goer_fearchsel__spline__ldc < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'fearchsel_spline';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            d.oo.flag_parallel = 0;
        end;
    end;
end
