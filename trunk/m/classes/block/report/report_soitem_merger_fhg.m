%> ?
classdef report_soitem_merger_fhg < report_soitem
    properties
        peakdetector;
        subsetsprocessor;
        %> @ref biocomparer object
        biocomparer;
        
        %> =report_log_fselrepeater_histcomp::get_defaultsubsetsprocessors().
        %> Cell of subsetsprocessors to perform biomarkers comparisons using different subsetsprocessors. If used, the comparison will be per stab
        %> Note that this property does not have a corresponding GUI input at the moment.
        subsetsprocessors;
        
        
        flag_draw_histograms = 1;
        flag_draw_stability = 1;
        
        flag_biocomp_per_clssr = 1;
        flag_biocomp_per_stab = 1;
        flag_biocomp_all = 1;
        %> Biomarkers comparison per subsetsprocessor
        flag_biocomp_per_ssp = 1;
        flag_nf4grades = 1;
        %> =10. Stabilization number to be used in the "all" comparison
        stab4all = 10;
        
        %> Whether to generate a table where the varying element will be the nf4grades of a fixed-nf4grades subsetsprocessor
        flag_biocomp_nf4grades = 1;
    end;
    
    methods
        function o = report_soitem_merger_fhg()
            o.classtitle = 'Histograms and biomarkers comparison tables';
            o.inputclass = 'soitem_merger_fhg';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function [o, out] = do_use(o, item)
            out = log_html();
            if o. flag_biocomp_per_clssr || o.flag_biocomp_per_stab || o.flag_biocomp_all || o.flag_nf4grades
                item = item.calculate_stabilities(def_subsetsprocessor(o.subsetsprocessor));
            end;
            
            s = o.get_standardheader(item);
            
            out.html = [s, o.get_html_graphics(item)];
            out.title = item.get_description();
        end;
    end;

    
    methods
        %> Generates a table with the best in each architecture, with its respective time and confidence interval
        %> @param item a soitem_merger_fhg object
        function s = get_html_graphics(o, item)
            s = '';
            
            ssp = def_subsetsprocessor(o.subsetsprocessor);
            pd = def_peakdetector(o.peakdetector);
            bc = def_biocomparer(o.biocomparer);
            
            
            if o.flag_biocomp_per_clssr
                % Finds out methodologies with more than one variation ("stabilizations")
                groupidxs = item.find_methodologygroups();
                n = numel(groupidxs);

                if n <= 0
                    % Giving no message at the moment
                else
                    % Generates sub-reports for these groups separately
                    for i = 1:n
                        if i > 1; s = cat(2, s, '<hr />', 10); end;
                        s = cat(2, s, sprintf('<h1>Methodology: "%s"</h1>\n', item.s_methodologies{groupidxs{i}(1)}), o.get_html_from_logs(item, groupidxs{i}));
                    end;

                    s = cat(2, s, '<h1>Methodology table merge</h1>', item.html_biocomparisontable_stab(ssp, pd, bc));

                    s = cat(2, s, '<hr />', 10);
                end;
            end;

            if o.flag_biocomp_per_stab
                stabs = unique(item.stabs);
                for i = 1:numel(stabs)
                    s = cat(2, s, sprintf('<h1>Stabilization: "%d"</h1>\n', stabs(i)), o.get_html_from_logs(item, item.find_stab(stabs(i))));
                end;
            end;
                
            if o.flag_biocomp_all
                % Picks one representant from each group
                idxs = [item.find_stab(o.stab4all)]; %; item.find_stab(20)];
                idxs = idxs(:)'; % makes 10, 20, 10, 20, ...
                idxs = [idxs, item.find_single()];
                s = cat(2, s, '<h1>Comparison of Methodologies</h1>', 10, o.get_html_from_logs(item, idxs));
                % Generates one report for comparison among ALL different methodologies
                s = cat(2, s, '<hr />', 10);
            end;

            
            if o.flag_biocomp_nf4grades
                s = cat(2, s, '<h1>Comparison of nf4grades</h1>', 10);

                stabs = unique(item.stabs);
                stabs(stabs < 0) = [];
                if isempty(stabs)
                    s = cat(2, s, '<p><font color=red>Comparison of number of selected features available for methodologies with stabilization only</font></p>');
                else
                    for i = 1:numel(stabs)
                        s = cat(2, s, sprintf('<h2>Comparison of number of selected features - stab%02d</h2>\n', stabs(i)));
                        s = cat(2, s, o.get_html_biocomp_nf4grades(item, item.find_stab(stabs(i))));
                    end;

                    s = cat(2, s, sprintf('<h2>Comparison of nf4grades - stab-all</h2>\n'));
                    s = cat(2, s, o.get_html_biocomp_nf4grades(item, find(item.stabs >= 0))); %#ok<FNDSB>
                end;
                s = cat(2, s, '<hr />', 10);
            end;
            
            if o.flag_biocomp_per_ssp
                s = cat(2, s, '<h1>Comparison of subsetsprocessors</h1>', 10);

                stabs = unique(item.stabs);
                stabs(stabs < 0) = [];
                if isempty(stabs)
                    s = cat(2, s, '<p><font color=red>Comparison of subsetsprocessors available for methodologies with stabilization only</font></p>');
                else
                    for i = 1:numel(stabs)
                        s = cat(2, s, sprintf('<h2>Comparison of subsetsprocessors - stab%02d</h2>\n', stabs(i)));
                        s = cat(2, s, o.get_html_biocomp_ssps(item, item.find_stab(stabs(i))));
                    end;

                    s = cat(2, s, sprintf('<h2>Comparison of subsetsprocessors - stab-all</h2>\n'));
                    s = cat(2, s, o.get_html_biocomp_ssps(item, find(item.stabs >= 0))); %#ok<FNDSB>
                end;
                s = cat(2, s, '<hr />', 10);
            end;            
            

            % Average stability curves
            if o.flag_draw_stability
                idxs = find(item.stabs >= 0);
                n = numel(idxs);
                if n <= 0
                    s = cat(2, s, '<p><font color=red>Average stability curve per stabilization available for methodologies with stabilization only</font></p>');
                else
                    for i = 1:n
                        log_rep = item.logs(idxs(i));
                        ds_stab(i) = log_rep.extract_dataset_stabilities(); %#ok<AGROW>
                        ds_stab(i).classlabels = {sprintf('stab%02d', item.stabs(idxs(i)))}; %#ok<AGROW>
                    end;
                    ds = o.merge_ds_stab(ds_stab);
                    ov = vis_hachures();
                    figure;
                    ov.use(ds);
                    maximize_window([], 1.8);
                    s = cat(2, s, '<h1>Average stability curve per stabilization</h1>', 10);
                    s = cat(2, s, o.save_n_close([], 0));
                end;
                s = cat(2, s, '<hr />', 10);
            end;
            
            
            
            if o.flag_nf4grades
                %-----> nf for grades table
                s = cat(2, s, o.get_html_nf4grades(item, 1:numel(item.logs)));
                s = cat(2, s, '<hr />', 10);
            end;
            
            % Reports the objects used
            s = cat(2, s, '<h2>Setup of some objects used</h2>');
            a = {ssp, pd, bc};
            for i = 1:numel(a)
                obj = a{i};
                s = cat(2, s, '<p><b>', obj.get_description, '</b></p>', 10, '<pre>', obj.get_report(), '</pre>', 10);
            end;
            s = cat(2, s, '<hr />', 10);
        end;
        
        %
        function s = get_html_biocomp_nf4grades(o, item, idxs)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_nf4grades(idxs, def_subsetsprocessor(o.subsetsprocessor), o.peakdetector, o.biocomparer);
            s = cat(2, s, temp);

            % Draws as image as well, easier to perceive
            figure;
            means = mean(M, 3);
            imagesc(means);
            xtick = 1:size(M, 1);
            set(gca(), 'xtick', xtick, 'ytick', xtick, 'xticklabel', titles, 'yticklabel', titles);
            hcb = colorbar();
            format_frank([], [], hcb);
            s = cat(2, s, o.save_n_close([], 0));
        end;

        function s = get_html_biocomp_ssps(o, item, idxs)
            s = '';
            [temp, M, titles] = item.html_biocomparisontable_ssps(idxs, o.get_ssps(), o.peakdetector, o.biocomparer); %#ok<NASGU,ASGLU>
            s = cat(2, s, temp);
        end;

        
        %
        function s = get_html_from_logs(o, item, idxs)
            s = '';
            ssp = def_subsetsprocessor(o.subsetsprocessor);

            % Legend
            if o.flag_draw_histograms            
                s = cat(2, s, '<h2>Histograms</h2>', 10);
                od = drawer_histograms(); % Note that "od" will be also used below
                % ---
                
                od.subsetsprocessor = subsetsprocessor(); %#ok<CPROP,PROP>
                od.peakdetector = o.peakdetector;
                log_rep = item.logs(idxs(1));
                figure;
                od.draw_for_legend(log_rep);
                show_legend_only();
                s = cat(2, s, o.save_n_close([], 0));

                % ---
                od.subsetsprocessor = ssp;
                od.peakdetector = o.peakdetector;
            end;

            n = numel(idxs);
            for i = 1:n
                log_rep = item.logs(idxs(i));
                
                if o.flag_draw_histograms
                    figure;
                    od.draw(log_rep);
                    maximize_window([], 8);
                    s = cat(2, s, '<h2>', item.get_logdescription(idxs(i)), '</h2>', o.save_n_close([], 0));
                end;

                if o.flag_draw_stability
                    % Stability curve
                    ds_stab(i) = log_rep.extract_dataset_stabilities(); %#ok<AGROW>
                    ds_stab(i).classlabels = {replace_underscores(sprintf('%s stab%02d', item.s_methodologies{idxs(i)}, item.stabs(idxs(i))))}; %#ok<AGROW>
                end;
            end;

            % Stability curves
%             ds = o.merge_ds_stab(ds_stab);
%             ov = vis_alldata();
            if o.flag_draw_stability
                for j = 1:2 % 1 pass for the legend, second for the graphics
                    figure;
                    for i = 1:n
                        plot(ds_stab(i).fea_x, ds_stab(i).X, 'Color', find_color(i), 'LineWidth', scaled(2)); % 'LineStyle', find_linestyle(i),
                        hold on;
                    end;
                    format_xaxis(ds_stab(1));
                    format_yaxis(ds_stab(1));
                    make_box();
                    
                    if j == 1
                        legend(cat(2, ds_stab.classlabels));
                        format_frank();
                        show_legend_only();
                    else
                        format_frank();
                    end;
                    s = cat(2, s, o.save_n_close([], 0));
                end;
                        
            end;
            
            % Biomarkers coherence tables
            s = cat(2, s, '<h2>Biomarkers coherence</h2>', 10, item.html_biocomparisontable(idxs, ssp, o.peakdetector, o.biocomparer));
        end;

        
        %> nf4grades table
        function s = get_html_nf4grades(o, item, idxs)
            ssp = def_subsetsprocessor(o.subsetsprocessor);

            s = '';
            s = cat(2, s, '<h2>Number of informative features</h2>', 10, item.html_nf4grades(idxs, ssp));
        end;
    end;
    
    methods
        %
        function ssps = get_ssps(o)
            if isempty(o.subsetsprocessors)
                ssps = report_log_fselrepeater_histcomp.get_defaultsubsetsprocessors();
            else
                ssps = o.subsetsprocessors;
            end;
        end;
    end;
    
    methods(Access=protected)
        %> Merges datasets but first makes sure they all have same number of features
        function ds = merge_ds_stab(o, daa) %#ok<MANU>
            nf = max([daa.nf]);
            for i = 1:numel(daa)
                if daa(i).nf < nf
                    temp = daa(i).X;
                    [ro, co] = size(temp);
                    daa(i).X = NaN(ro, nf);
                    daa(i).X(1:ro, 1:co) = temp;
                    daa(i).fea_x = 1:nf;
                    daa(i) = daa(i).assert_fix(); % just in case
                end;
            end;
            ds = data_merge_rows(daa);
        end;
    end;
end
