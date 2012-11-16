%> ?
classdef report_soitem_merger_merger_fitest_1d < report_soitem
%     properties
%         %> =(auto). Minimum value for the colour scaling of the HTML cells
%         minimum = [];
%         %> =(auto). Maximum value for the colour scaling of the HTML cells
%         maximum = [];
%     end;
%     
    methods
        function o = report_soitem_merger_merger_fitest_1d()
            o.classtitle = '1D Classification table';
            o.inputclass = 'soitem_merger_merger_fitest';
%             o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, item)
            out = log_html();
            
            s = o.get_standardheader(item);
            
            out.html = [s, o.get_html_graphics(item)];
            out.title = item.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param item a soitem_merger_merger_fitest object
        function s = get_html_graphics(o, item) %#ok<MANU>
%             it = soitem_sovalues();
            sov = item.get_sovalues_1d();
            r = report_soitem_sovalues();
            s = r.get_html_tables(sov);
        end;
    end;
end
