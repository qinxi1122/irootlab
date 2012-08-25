%> UNDERSEL for FE pca and Classifier qdc
classdef goer_undersel__pca__qdc < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_qdc';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
