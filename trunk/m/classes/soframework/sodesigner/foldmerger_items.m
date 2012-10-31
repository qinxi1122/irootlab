%> Cross-validated Fit-estimate with the individual datasets
classdef foldmerger_items < sodesigner
    methods
        %> Gives an opportunity to change somethin inside the item, e.g. activate/desactivate pairwise
        function dia = process_dia(o, dia)
        end;
        
        function o = customize(o)
            o = customize@sodesigner(o);
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        %> Item must be a soitem_diaa
        %>
        %> The cell of diagnosissystem objects inside item can be nD, diacomp doesn't care
        function out = do_design(o)
            out = soitem_items();

            out.items = o.input;
            out.title = sprintf('#Items: %d', numel(out.items));
            if numel(out.items) > 0
                out.dstitle = out.items{1}.dstitle;
            end;
        end;
    end;
end