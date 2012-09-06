%> architecture optimization for the dist classifier
classdef goer_lcr2__dist < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'lcr2';
        end;
    end;
    
    methods
        function d = customize_session(o, d)
            % Make your experiments here
%             d.oo.flag_parallel = 0;
        end;
    end;
end
