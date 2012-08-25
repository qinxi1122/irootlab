%> @brief Splits dataset - pairwise recombination
%>
%> Will result in n-1 datasets. Each dataset will have two classes: the one corresponding to idx_ref and one of the other classes
%>
%> Not published in GUI.
classdef blmisc_split_pairwise < blmisc_split
    properties
        hierarchy = [];
        idx_ref = 1;
    end;
    
    methods
        function o = blmisc_split_pairwise(o)
            o.classtitle = 'Pairwise';
            o.flag_ui = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, datasets] = do_use(o, data)

            temp = data_split_classes(data, o.hierarchy);
            classmap = classlabels2cell(data.classlabels, o.hierarchy);
            ii = 0;
            for i = 1:length(temp)
                if i ~= o.idx_ref
                    ii = ii+1;
                    datasets(ii) = data_merge_rows(temp([o.idx_ref, i]));
                    datasets(ii).title = [classmap{i, 3} ' vs. ' classmap{o.idx_ref, 3}];
                end;
            end;
        end;
    end;  
end

