%> This is designed to group several soitem_merger_fhg together
classdef merger_merger_fhg < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_merger_merger_fhg();
            items = o.input;
            ni = numel(items);
            for i = 1:ni
                out.items(i) = items{i}; % Converts cell to object array
            end;
            out.title = ['Merge of ', int2str(ni), ' MERGE_FHG', iif(ni > 1, '''s', '')];
            out.dstitle = 'varies';
        end;
    end;
end
