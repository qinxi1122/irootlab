%> UNDERSEL for FE bypass and Classifier ldc
classdef goer_undersel__bypass__ldc < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_ldc';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
