%> AHA Plots the (nf)x(rates) curves
%>
classdef report_soitem_foldmerger_ffs < report_soitem
    methods
        function o = report_soitem_foldmerger_ffs()
            o.classtitle = 'Fold-wise (nf)x(rates) curves';
            o.inputclass = 'soitem_foldmerger_ffs';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = log_html();
            
            s = o.get_standardheader(obj);
            
            out.html = [s, o.get_html_graphics(obj.data)];
            out.title = obj.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param sor sovalues object
        function s = get_html_graphics(o, data)
            figure;
            data_draw(data);
            hold on;
            plot(data.fea_x, mean(data.X, 1), 'Color', find_color(1), 'LineWidth', scaled(3));
            legend off;
            title(o.classtitle);
            s = irreport.save_n_close([], 0, []);
        end;
    end;
end
