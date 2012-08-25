%> UNDERSEL for FE manova and Classifier svm
classdef goer_undersel__manova__svm < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_svm';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
