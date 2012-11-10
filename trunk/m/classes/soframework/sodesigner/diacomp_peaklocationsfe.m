%> Replaces the FE part by peak location detection
classdef diacomp_peaklocationsfe < diacomp
    methods
        %> Gives an opportunity to change somethin inside the item
        function item = process_item(o, item)
            fe = get_fcon_maxminpos();
            
            ni = numel(item.diaa);
            for i = 1:ni
                item.diaa{i}.sostage_fe = [];
                item.diaa{i}.blk_fe = fe;
            end;
        end;
    end;
end