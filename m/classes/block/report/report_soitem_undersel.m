%> Comparison and p-values tables
%>
%> @todo implement the params GUI
classdef report_soitem_undersel < report_soitem
    properties
        %> =0. Whether to generate the p-values tables
        flag_ptable = 0;
        
        %> ={'rates', 'times3'}
        names = {'rates', 'times3'}
        
        %> vectorcomp_ttest_right() with no logtake. vectorcomp object used tor the p-values tables
        vectorcomp = [];

        %> Maximum number of table rows
        maxrows = 20;
    end;

    methods
        function o = report_soitem_undersel()
            o.classtitle = 'Undersampling graphics';
            o.inputclass = 'soitem_undersel';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = log_html();
            
            s = o.get_standardheader(obj);
            
            out.html = [s, o.get_html_graphics(obj.sovalues)];
            out.title = obj.get_description();
        end;
    end;

    
    methods
        %> @param sor sovalues object
        function s = get_html_graphics(o, sor)
            s = o.images_1d(sor);
        end;
    end;
end
