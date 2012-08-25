%> UNDERSEL for FE lasso and Classifier ann
classdef goer_undersel__lasso__ann < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_ann';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
