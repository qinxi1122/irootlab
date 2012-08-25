%> UNDERSEL for FE fisher and Classifier knn
classdef goer_undersel__fisher__knn < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_knn';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
