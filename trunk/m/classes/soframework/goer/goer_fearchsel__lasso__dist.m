%> architecture optimization for the knn classifier
classdef goer_fearchsel__lasso__dist < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'fearchsel_lasso';
        end;

        function d = customize_session(o, d)
            % Make your experiments here
            d.oo.fearchsel_lasso_nf_max = 80;
        end;
    end;
end
