%> architecture optimization for the knn classifier
classdef goer_fearchsel__ffs__dist < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'fearchsel_ffs';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            d.oo.fearchsel_ffs_nf_max = 80;
        end;
    end;
end
