%> Report builder
classdef reportbuilder
    properties
        map = {...
               'soitem_diachoice', {'get_report_soitem_sovalues'}; ...
%                'soitem_foldmerger_fitest', {'get_report_soitem_foldmerger_fitest'}; ...
%                'soitem_fhg', {'get_report_soitem_fhg_histcomp'}; ...
               'soitem_merger_fhg', {'get_report_soitem_merger_fhg'}; ...
               'soitem_merger_merger_fhg', {'get_report_soitem_merger_merger_fhg'}; ...
              };
        %> If activated, won't call the "use()" methods of the reports
        flag_simulation = 0;
    end;
    
    properties(SetAccess=protected)
        dirname;
    end;
    
    methods
        function o = reportbuilder()
        end;
        
        function o = go(o)
            setup_load();
            o.dirname = find_dirname('reports_');
            mkdir(o.dirname);
            s_pwd = pwd();
            if exist('scenesetup.m', 'file')
                scenesetup;
                s = ['<h1>Scene: "', a.scenename, '"</h1>', 10]; %#ok<NODEF>
            else
                [a, b] = fileparts(pwd);
                s = ['<h1>Directory: "', b, '"</h1>', 10];
            end;
            cd(o.dirname);
            try
                s = cat(2, s, '<center>', o.process_dir(), '</center>', 10);
                o_html = log_html;
                o_html.html = s;
                o.save('index.html', o_html);
                cd(s_pwd);
            catch ME
                cd(s_pwd);
                rethrow(ME);
            end;
        end;
            

        function s = process_dir(o)
            s = '';
            s_back = ['<p><input type="button" value="Back" onclick="window.history.back();" />&nbsp;&nbsp;<a href="index.html">Back</a></p>', 10];
            a = o.map;
            classes = a(:, 1);
            getters = a(:, 2);
            
            dd = dir('../output*.mat'); % Probes if there is any mat file at current directory
            if ~isempty(dd)
                names = {dd.name};
                no_files = numel(names);
                
                
                s = cat(2, s, '<table class=bo>', 10);
                temp = cellfun(@(x) ['<td class=bob><div class=hel>', x, '</div></td>', 10], {'File name', 'Time', 'Description', 'Data', 'Reports'}, 'UniformOutput', 0);
                s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
                
                ipro = progress2_open('Report builder', [], 0, no_files);
                for i = 1:no_files
                    fn = names{i};
                    try
                        clear r;
                        load(fullfile('..', fn));
                        
                        if ~exist('r', 'var')
                            % MAT file has no "r" variable, skips file
                        else
                            item = r.item;
                            s_class = class(item);
                            i_class = find(strcmp(classes, s_class));
                            if isempty(i_class)
                                % Class not handled, skips file
                            else
                                irverbose(sprintf('Processing file "%s"...', fn));
                                s_getters = getters{i_class};
                                s_reports = '';
                                for j = 1:numel(s_getters)
                                    o_report = o.(s_getters{j});
                                    if ~o.flag_simulation
                                        o_html = o_report.use(item);
                                    else
                                        o_html = log_html;
                                        o_html.html = 'Ficassi tansu';
                                    end;
                                    o_html.html = cat(2, s_back, o_html.html, s_back);
                                    filename = [fn, '__', class(o_report), '.html'];
                                    o.save(filename, o_html);
                                    s_reports = cat(2, s_reports, sprintf('<a href="%s">%s</a><br />\n', filename, o_report.classtitle));
                                end;
                                temp = cellfun(@(x) ['<td class=bob1>', x, '</td>', 10], {fn, num2str(r.time_go), item.get_description, item.dstitle, s_reports}, 'UniformOutput', 0);
                                s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
                            end;
                        end;                        
                    catch ME
                        s = cat(2, s, '<tr>', '<td colspan=5 class=bob1>', strrep(ME.getReport(), char(10), '<br />'), '</td>', 10, '</tr>', 10);
                        irverbose(sprintf('Failed processing file "%s": %s', fn, ME.message));
                    end;
                    
                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);
                s = cat(2, s, '</table>', 10);
            end;
        end;

        
        function o = save(o, filename, log_html)
%             fn = fullfile(o.dirname, filename);
            fn = filename;
            h = fopen(fn, 'w');
            if h <= 0
                irerror(sprintf('Could''t create file "%s"', fn));
            end;
            fwrite(h, log_html.get_embodied());
            fclose(h);
        end;
    end;
   
    
    
    %
    % Report object getters
    %
    % These routines allow full control over the report object parameters
    %
    methods
        function r = get_report_soitem_merger_fhg(o)
            r = report_soitem_merger_fhg();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessor = [];
            r.biocomparer = [];
            r.subsetsprocessors = [];
            r.flag_draw_histograms = 1;
            r.flag_draw_stability = 1;
            r.flag_biocomp_per_clssr = 1;
            r.flag_biocomp_per_stab = 1;
            r.flag_biocomp_all = 1;
            r.flag_biocomp_per_ssp = 1;
            r.flag_nf4grades = 1;
            r.stab4all = 10;
            r.flag_biocomp_nf4grades = 1;
        end;
        
        function r = get_report_soitem_fhg(o)
            r = report_soitem_fhg();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessor = [];
        end;

        function r = get_report_soitem_fhg_histcomp(o)
            r = report_soitem_fhg_histcomp();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessors = [];
            r.biocomparer = [];
        end;

        function r = get_report_soitem_merger_merger_fhg(o)
            r = report_soitem_merger_merger_fhg();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.peakdetector = [];
            r.subsetsprocessors = [];
            r.biocomparer = [];
            r.subsetsprocessor = [];
            r.flag_draw_stability = 1;
            r.flag_biocomp_per_clssr = 1;
            r.flag_biocomp_per_stab = 1;
            r.flag_biocomp_all = 1;
            r.flag_biocomp_per_ssp = 1;
            r.flag_nf4grades = 1;
            r.stab4all = 10;
            r.flag_biocomp_nf4grades = 1;
        end;

        function r = get_report_soitem_sovalues(o)
            r = report_soitem_sovalues();
            r.flag_images = 1;
            r.flag_tables = 1;
            r.flag_ptable = 1;
        end;
        

        function r = get_report_soitem_foldmerger_fitest(o)
            r = report_soitem_foldmerger_fitest();
            r.flag_images = 1;
            r.flag_tables = 1;
        end;        
    end;
end
