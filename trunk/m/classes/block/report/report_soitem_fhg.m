%> ?
%>
%> @todo implement the params GUI
classdef report_soitem_fhg < report_soitem
    properties
        peakdetector;
        subsetsprocessor;
        data_hint;
    end;
    
    methods
        function o = report_soitem_fhg()
            o.classtitle = 'FHG';
            o.inputclass = 'soitem_fhg';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, obj)
            out = log_html();
            
            s = o.get_standardheader(obj);
            
            out.html = [s, o.get_html_graphics(obj)];
            out.title = obj.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param sor sovalues object
        function s = get_html_graphics(o, item)
            log_rep = item.log;
            
            od = drawer_histograms();
            od.subsetsprocessor = o.subsetsprocessor;
            od.peakdetector = o.peakdetector;
            
            v = vis_stackedhists();
            v.data_hint = o.data_hint;
            v.peakdetector = def_peakdetector(o.peakdetector);
            
            s = '';
            
            % Legend
            figure;
            od.draw_for_legend(log_rep);
            show_legend_only();
            s = cat(2, s, o.save_n_close([], 0));

            % 2-subplot
            figure;
            hist = od.draw(log_rep);
            maximize_window([], 6);
            s = cat(2, s, o.save_n_close([], 0));

            % One histogram only
            
            figure;
            v.use(hist);
            set(gca, 'color', 1.15*[0.8314    0.8157    0.7843]);
            maximize_window(gcf(), 4);
            set(gcf, 'InvertHardCopy', 'off'); % This is apparently needed to preserve the gray background
            set(gcf, 'color', [1, 1, 1]);
            legend off;
            s = cat(2, s, o.save_n_close());

            % Stability curve
            ds_stab = log_rep.extract_dataset_stabilities();
            ov = vis_means();
            figure;
            ov.use(ds_stab);
            legend off;
            title('');
%             maximize_window(gcf(), 2);
            s = cat(2, s, o.save_n_close([], 0));
        end;
    end;
end
