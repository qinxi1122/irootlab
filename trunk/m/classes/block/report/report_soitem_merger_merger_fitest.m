classdef report_soitem_merger_merger_fitest < report_soitem
    properties
    end;
    
    methods
        function o = report_soitem_merger_merger_fitest()
            o.classtitle = 'X-X-X-X-X-X';
            o.inputclass = 'soitem_merger_merger_fitest';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, item)
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
            s = '';
            
            s = cat(2, s, item.html_rates());
        end;
    end;
end
