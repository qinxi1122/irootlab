% @brief Opens HTML report in MATLAB web browser.
%> @todo make this general, not only t-test
classdef report_testtable < irreport
    properties
        idx_fea = 1;
    end;
    
    methods
        function o = report_testtable()
            o.classtitle = 'Test table';
            o.inputclass = 'irdata';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, data)
            out = log_html();
            out.html = o.get_html_table(data);
            out.title = obj.get_description();
        end;
    end;
    
    methods
        function s = get_html_table(o, data)
            h = arrayfun(@(s) ['<td class="tdhe">', s{1}, '</td>'], data.classlabels, 'UniformOutput', 0);

            s = '';
            s = cat(2, s, ['<h1>', 'T-test table for dataset ', data.get_description(), '</h1>', 10, '<table>', 10, '<tr>', ...
                '<td class="tdhe">class \ class</td>', strcat(h{:}), '</tr>', 10]);

            
            pieces = data_split_classes(data);
            
            for i = 1:data.nc
                s = cat(2, s, ['<tr><td class="tdle">', data.classlabels{i}, '</td>', 10]);

                for j = 1:data.nc
                    [flag, p] = ttest2(pieces(i).X(:, o.idx_fea), pieces(j).X(:, o.idx_fea)); %#ok<ASGLU>
                    
                    s = cat(2, s, ['<td class="tdnu">', num2str(p), '</td>', 10]);
                end;
                
                s = cat(2, s, ['</tr>', 10]);
            end;
            
            s = cat(2, s, ['</table>', 10]);
        end;
    end;
end
