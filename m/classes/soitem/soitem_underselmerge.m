%> Output of an @ref underselmerge process (merging Cross-validation folds of undersampling selection)
classdef soitem_underselmerge < soitem
    properties
        %> cell of sovalues objects
        sovaluess;
    end;
    
    methods(Sealed)
        %> Generates a dataset. One class for rates and one class for times3
        function ds = extract_dataset(o)
            ni = numel(o.sovaluess);
            
            ds = irdata();
            ds.classlabels = {'Rates', 'Train+test times'};
            ds.classes = [zeros(ni, 1); ones(ni, 1)];
   
            for i = ni:-1:1
                ds.X(i+ni, :) = o.sovaluess{i}.get_y('times3');
                ds.X(i, :) = o.sovaluess{i}.get_y('rates');
            end;
            
            ds = ds.assert_fix();
        end;
    end;
    
    methods(Access=protected)
        function s = do_get_html_report(o)
        end;
    end;
end
