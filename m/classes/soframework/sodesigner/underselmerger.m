%> Merges the individual fold-wise UNDERSEL's into one single file
classdef underselmerger < sodesigner
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_underselmerge();

            items = o.input;
            ni = numel(items);
            
            for i = 1:ni
                out.sovaluess{i} = items{i}.sovalues;
            end;
        end;
    end;
end


                
                
                
