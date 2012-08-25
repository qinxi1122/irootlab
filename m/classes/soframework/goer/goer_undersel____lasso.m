%> UNDERSEL for FE (bypass because LASSO has embedded Feature Selection) and Classifier lasso
classdef goer_undersel____lasso < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_lasso';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end
