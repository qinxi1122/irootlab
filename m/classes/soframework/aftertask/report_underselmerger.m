%> draws the figures and generates HTML for the architecture-independent
%> design
classdef report_underselmerger < report_singlefile
    methods
        function s = get_token(o)
            s = 'underselmerger';
        end;
        

        function s0 = process_item(o, item, fnprefix) %#ok<INUSD>
            sor = item.sovalues;

            s0 = '';

            if o.flag_tables
                s0 = cat(2, s0, '<h3>Specifications</h3>', 10);
                s0 = cat(2, s0, '<center>', sor.get_html_specs(), '</center>', 10);


                ot = sovaluestablereport();
                ot.flag_ptable = o.flag_ptable;

                s0 = cat(2, s0, '<h3>Comparison tables</h3>', ot.get_html(sor));
            end;
        end;

        
        
% % % % %         function s0 = process_item(o, item, fnprefix)
% % % % %             sor = item.sovalues;
% % % % % 
% % % % %             s0 = '';
% % % % %             
% % % % % 
% % % % %             if o.flag_images
% % % % %                 s0 = cat(2, s0, '<h3>Figures</h3>', 10);
% % % % %                 s0 = cat(2, s0, o.images3(fnprefix, sor));
% % % % %             end;
% % % % % 
% % % % %             if o.flag_tables
% % % % %                 s0 = cat(2, s0, '<h3>Specifications</h3>', 10);
% % % % %                 s0 = cat(2, s0, '<center>', sor.get_html_specs(), '</center>', 10);
% % % % % 
% % % % %             end;
% % % % %             
% % % % %             if o.flag_tables
% % % % %                 ot = sovaluestablereport();
% % % % %                 ot.flag_ptable = o.flag_ptable;
% % % % % 
% % % % %                 s0 = cat(2, s0, '<h3>Comparison tables</h3>', ot.get_html(sor));
% % % % %             end;
% % % % %         end;
    end;
end
