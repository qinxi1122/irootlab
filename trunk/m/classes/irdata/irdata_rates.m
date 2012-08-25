%> Represents datasets generated by @ref reptt_sgs
%>
%> This dataset contains only one variable, which is the classification rate, and each class in the dataset represents a different
%> classification model.
%>
%> Its generated HTML contains a table of classification rates and standard deviations
classdef irdata_rates < irdata
    methods
        %> Constructor
        function data = irdata_rates()
            data.classtitle = 'Rates Dataset';
        end;
    end;
    
    methods(Access=protected)
        %> Abstract. HTML inner body
        function s = do_get_html(data)
            s = do_get_html@irdata(data);
            
            s = cat(2, s, ['<h1>', 'Rates & Standard deviations (StDv)', '</h1>', 10, '<table>', 10, '<tr>', ...
                '<td class="tdhe">Class</td><td class="tdhe">Rate</td><td class="tdhe">StDv</td></tr>', 10]);

            pieces = data_split_classes(data);
            
            for i = 1:numel(pieces)
                d = pieces(i);
                s = cat(2, s, ['<tr><td class="tdle">', d.classlabels{1}, '</td>', ...
                    '<td class="tdnu">', num2str(mean(d.X(:, 1))), '</td>', 10, ...
                    '<td class="tdnu">', num2str(std(d.X(:, 1))), '</td>', 10]);
                s = cat(2, s, ['</tr>', 10]);
            end;
            
            s = cat(2, s, ['</table>', 10]);
            
        end;
    end;
end
