%> @brief System Optimization stage - block provider
%>
%> @arg This is a standard interface with standard property names, e.g. sostag_cl::flag_cbable
%> @arg Can encapsulate classifiers as undersampling ensembles & 2-class one-versus-one ensembles
%>
%> Could be solved with blocks? Yes. This is an example of "convergent evolution". Because sostage used to have optimization routines inside
%> (these have been all moved to sodesigner).
%>
%> .title property is very important because will be used as part or full block title.
classdef sostage < irobj
    % "Standalone" property
    properties
        %> =0. Whether the classifier has embedded feature extraction
        flag_embeddedfe = 0;
    end;
    

    % Methods with a default behaviour, but likely to be implemented some time
    methods(Access=protected, Abstract)
        %> Returns a block
        blk = do_get_block(o);
    end;
    
    methods
        function blk = get_block(o)
            blk = o.do_get_block();
            blk.title = o.title;
        end;
    end;
    
    
    methods(Sealed)
        function s = get_description(o)
            s = replace_underscores(o.title);
        end;
    end;    
end
