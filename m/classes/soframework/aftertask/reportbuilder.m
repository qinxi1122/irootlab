% %> Report builder
classdef reportbuilder
    properties
        map = {...
               'soitem_diachoice', {{'get_report_soitem_sovalues', 'Flat comparison table (grouped by classifier and feature extraction)'}}; ... % soitem_diachoice descends from soitem_sovalues, but the former is output of latter (and fewer) tasks
               'soitem_items', {{'get_report_soitem_items', 'Curves/Images from Model Selection'}}; ...
               'soitem_foldmerger_fitest', {{'get_report_soitem_foldmerger_fitest', 'Confusion matrices for each system set-up'}}; ...
               'soitem_fhgs', {{'get_report_soitem_fhg', 'Feature histograms'}, {'get_report_soitem_fhg_histcomp', 'Histograms comparison'}}; ...
               'soitem_merger_fhg', {{'get_report_soitem_merger_fhg', 'Histograms and biomarkers comparison tables'}}; ...
               'soitem_merger_merger_fhg', {{'get_report_soitem_merger_merger_fhg', 'General biomarker comparison tables'}}; ...
               'soitem_merger_merger_fitest', {{'get_report_soitem_merger_merger_fitest', 'General 2D performance comparison table'}, ...
                                               {'get_report_soitem_merger_merger_fitest_1d', 'General flat performance comparion table'}}; ...
              };
          
        %> If activated, won't call the "use()" methods of the reports
        flag_simulation = 0;
    end;
    
    properties(SetAccess=protected)
        %> (Read-only) Directory found to put reports in
        dirname;
        %> (Read-only) Name of filename to store state
        DATAFILENAME = 'reportbuilder_state.data'
        %> whether finished
        flag_finished = 0;
        %> Indicates which reports are switched on. I deactitaved 2 reports that generated figures
        flags_map2 = boolean([1, 0, 0, 1, 1, 1, 1, 1, 1]);
    end;
    
    methods
        function o = set_flag_map2(o, i, x)
            if isempty(o.flags_map2)
                [dummy, o.flags_map2] = o.get_map2();
            end;
            o.flags_map2(i) = x;
        end;
        
        %> Flattens .map
        function [z, flags, titles] = get_map2(o)
            m = size(o.map, 1);
            z = {};
            k = 0;
            for i = 1:m
                n = length(o.map{i, 2});
                for j = 1:n
                    k = k+1;
                    z(k, :) = {o.map{i, 1}, o.map{i, 2}{j}{1}};
                    titles{k} = o.map{i, 2}{j}{2};
                end;
            end;
            
            if isempty(o.flags_map2)
                flags = boolean(ones(1, k));
            else
                flags = boolean(o.flags_map2);
            end;
        end;
        
        %> Flat map with only the activated reports
        function z = get_map3(o)
            [a, flags, titles] = o.get_map2(); %#ok<NASGU>
            z = a(flags, :);
        end;
    end;        
    
    methods
        function o = reportbuilder()
        end;
        
        function o = go(o)
            setup_load();
            state = o.load_state(); % Will create "state" variable in local workspace
            o.assert_dir_exists(state.dirname);
            
            ipro = progress2_open('Report builder', [], 0, state.no_reports);
            while ~state.flag_finished
                state = o.cycle_(state);
                ipro = progress2_change(ipro, [], [], state.cnt);
            end;
            progress2_close(ipro);
            o.create_index();
            irverbose('Report builder finished!');
            o.print_link();
            o.flag_finished = 1;
        end;

        function o = print_link(o)
            state = o.load_state();
            pf = fullfile(pwd(), state.dirname, 'index.html');
            fprintf('View: <a href="matlab:web(''%s'', ''-new'')">%s</a>\n', pf, pf);
        end;

        
        %> Resets report building progress by re-creating state file
        function o = reset(o)
            o.create_state();
            o.flag_finished = 0;
        end;
      
        function print_status(o)
            fprintf('\n__Reports completion______________\n');
            if ~exist(o.DATAFILENAME, 'file')
                disp('Reports list not built yet');
                return;
            end;
            
            state = o.load_state();
            fprintf('Reports directory: %s\n', state.dirname);
            fprintf('Completed: %d/%d\n', state.cnt, state.no_reports);
            % Doesn't print because doesn't open if clicked when waiting for keyboard input
%             if exist(fullfile(pwd(), state.dirname, 'index.html'), 'file')
%                 o.print_link();
%             end;
            disp('==================================');
        end;
        
        %> Increments pointers, generates 1 report, saves state
        function state = cycle_(o, state)
            S_BACK = ['<p><input type="button" value="Back" onclick="window.history.back();" />&nbsp;&nbsp;<a href="index.html">Back</a></p>', 10];
            
            % Increment pointers
            if state.i_file == 0
                state.i_file = 1;
            end;
            state.i_report = state.i_report+1;
            if state.i_file == 0 || state.i_report > state.filemap(state.i_file).no_reports
                state.i_file = state.i_file+1;
                state.i_report = 1;
            end;
            if state.i_file > state.no_files
                state.flag_finished = 1;
                return;
            end;

            % Makes report.
            % Exceptions are recorded into the output HTML and suppressed
            mi = state.filemap(state.i_file);
            li = mi.list(state.i_report);
            p = pwd();
            cd(state.dirname); % Must be there to use() report object (it generates figures etc)
            try
                o_report = o.(li.s_getter);
                o_report.title = ['File "', mi.infilename, '"'];
                load(fullfile('..', mi.infilename));
                item = r.item;
                if ~o.flag_simulation
                    o_html = o_report.use(item);
                else
                    o_html = log_html;
                    o_html.html = 'Simulation mode';
                end;
            catch ME
                o_html = log_html;
                o_html.html = strrep(ME.getReport(), char(10), '<br />');
                irverbose(ME.getReport(), 3);
            end;
            o_html.html = cat(2, S_BACK, o_html.html, S_BACK);
            o.save(li.outfilename, o_html);
            cd(p);
            state.cnt = state.cnt+1;
            
            % Save state
            o.save_state(state);
        end;
       
        
        %> Loads state file. Creates if does not exist
        function state = load_state(o) %#ok<STOUT>
            if ~exist(o.DATAFILENAME, 'file')
                o.create_state();
            end;
            load(o.DATAFILENAME, '-mat'); % Variable "state" should be inside
        end;

        %> Saves existing state variable in file
        function o = save_state(o, state) %#ok<INUSD>
            save(o.DATAFILENAME, 'state');
            irverbose(sprintf('Saved Report Builder State to file ``%s``', o.DATAFILENAME), 1);
        end;

        %> Creates state file
        %>
        %> <verbatim>
        %> .dirname - name of subdirectory within pwd
        %> .scenename - name of scene extracted from scenesetup.m (optional)
        %> .filemap - file map generated by build_filemap()
        %> .i_file - index of last processed item of .filemap
        %> .i_report - index of last processed item of filemap(i_file).list
        %> .no_reports total number of reports
        %> .no_files - short to numel(.filemap)
        %> .flag_finished - set to 1 when all reports have been successfully generated
        %> .cnt - iteration counter (1 to no_reports)
        %> </endverbatim>
        function o = create_state(o)
            state.dirname = find_dirname('reports_');
            if exist('scenesetup.m', 'file')
                scenesetup;
                state.scenename = a.scenename;
            else
                state.scenename = '';
            end;
            [state.filemap, state.no_reports] = o.build_filemap();
            state.i_file = 0;
            state.i_report = 0;
            state.no_files = numel(state.filemap);
            state.flag_finished = 0;
            state.cnt = 0;
            o.save_state(state);
        end;

        %> Creates task structure array
        %>
        %> .infilename - mat filename starting with "output"
        %> .status     - 0: ok; -1: failed somehow
        %> .statusmsg  - message string, further details on -1 status
        %> .time_go       - time taken (extracted from file)
        %> .descr      - description (extracted from file)
        %> .dstitle    - dataset title (extracted from file)
        %> .no_reports - number of associated reports
        %> .list - structure array with following fields:
        %>     .s_getter - string with name of report getter method
        %>     .outfilename - output html file
        %>     .title - alleged report title
        %>
        %> @return [filemap structure, total number of reports]
        function [tt, no_total] = build_filemap(o)
            no_total = 0;
            a = o.get_map3();
            classes = a(:, 1);
            getters = a(:, 2);
            
            dd = dir('output*.mat');
%             [dummy, idxs] = sort([dd.datenum]);
%             dd = dd(idxs); % Sorts by date
            if ~isempty(dd)
                names = {dd.name};
                no_files = numel(names);
                ipro = progress2_open('Report task builder', [], 0, no_files);
                it = 1; % 
                for i = 1:no_files
                    % Variables starting with "t_" will mount the file record
                    fn = names{i};
                    flag_has = 1; % If set to 0 inside, file will be skipped at the end of the "try" block
                    try
                        clear r;
                        load(fn);
                        
                        if ~exist('r', 'var')
                            tt(it).status = -1;
                            tt(it).statusmsg = 'No "r" variable inside .mat file';
                        else
                            item = r.item;
                            if strcmp(item.dstitle, '(not used)')
                                flag_has = 0;
                            else
                                b = cellfun(@(x) (isa(item, x)), classes); % Finds classes that match class of item
                                gttr = getters(b);
                                no_reports = numel(gttr);
                                for j = 1:no_reports
                                    o_report = o.(gttr{j}); % Instantializes report just to get class name
                                    tt(it).list(j).s_getter = gttr{j};
                                    tt(it).list(j).outfilename = [fn, '__', class(o_report), '.html'];
                                    tt(it).list(j).title = o_report.classtitle;
                                end;
                                if no_reports > 0
                                    tt(it).status = 0; %#ok<*AGROW>
                                    tt(it).time_go = r.time_go;
                                    tt(it).descr = item.get_description();
                                    tt(it).dstitle = item.dstitle();
                                    tt(it).no_reports = no_reports;
                                    taskidxs(it) = r.taskidx;
                                    no_total = no_total+no_reports;
                                else
                                    flag_has = 0;
                                end;
                            end;
                        end;                        
                    catch ME
                        tt(it).status = -1;
                        tt(it).statusmsg = strrep(ME.getReport(), char(10), '<br />');
                        irverbose(sprintf('Failed processing file "%s": %s', fn, ME.message));
                    end;
                    if flag_has
                        tt(it).infilename = fn;
                        it = it+1;
                    end;
                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);
                
                [dummy, idxs] = sort(taskidxs); % Sorts reports by task index
                tt = tt(idxs);
            end;
        end;
        
        %> Creates directory if it does not exist
        function o = assert_dir_exists(o, dirname)
            ff = fullfile('.', dirname);
            if ~exist(ff, 'dir')
                mkdir(ff);
                irverbose(sprintf('Created directory ``%s``', ff), 1);
            end;
        end;
        
        %> Creates index.html
        function o = create_index(o)
            state = o.load_state(); % Will create "state" variable in local workspace
            o.assert_dir_exists(state.dirname);
            no_files = numel(state.filemap);

            s_ = iif(~isempty(state.scenename), ...
                     ['Reports for Scene "', state.scenename, '"'], ...
                     'Reports index');
            s = ['<h1>', s_, '</h1>', 10];
            s = cat(2, s, '<center>', 10, '<table class=bo>', 10);
            temp = cellfun(@(x) ['<td class=bob><div class=hel>', x, '</div></td>', 10], {'File name', 'Time', 'Description', 'Dataset name', 'Reports'}, 'UniformOutput', 0);
            s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
                
            for i = 1:no_files
                mi = state.filemap(i); % Map Item
                if mi.status == 0
                    s_reports = '';
                    for j = 1:numel(mi.list)
                        li = mi.list(j);
                        if exist(fullfile(state.dirname, li.outfilename), 'file')
                            s_ = sprintf('<a href="%s">%s</a><br />\n', ...
                                 li.outfilename, li.title);
                        else
                            s_ = sprintf('<font color=#444444><em>%s</em></font><br />\n', ...
                                 li.title);
                        end;
                        s_reports = cat(2, s_reports, s_);
                    end;
                    
                    s_fn = mi.infilename;
                    a = o.describe_filename(s_fn);
                    if ~isempty(a)
                        s_fn = [s_fn, 10, '<ul>', 10];
                        for i = 1:numel(a)
                            s_fn = [s_fn, '<li>', a{i}, '</li>', 10];
                        end;
                        s_fn = [s_fn, '</ul>', 10];
                    end;
                    
                    temp = cellfun(@(x) ['<td class=bob1>', x, '</td>', 10], ...
                        {s_fn, num2str(mi.time_go), mi.descr, mi.dstitle, ...
                        s_reports}, 'UniformOutput', 0);
                    s = cat(2, s, '<tr>', 10, temp{:}, '</tr>', 10);
                else
                    s = cat(2, s, '<tr>', sprintf('<td class=bob1>%s</td>\n', mi.infilename), ...
                        '<td colspan=4 class=bob1>', mi.statusmsg, ...
                        '</td>', 10, '</tr>', 10);
                end;
            end;
            s = cat(2, s, '</table>', 10, '</center>', 10);
            o_html = log_html();
            o_html.title = sprintf('Index of reports for directory "%s"', pwd());
            o_html.html = s;
            o.save(fullfile(state.dirname, 'index.html'), o_html);
        end;


        
        %> Finds tokens (or absence thereof) within a filename
        %> @return cell of strings to be probably converted into a UL
        function a = describe_filename(o, fn)
            % Patterns to match and their corresponding explanation
            tt = {'_grag_', 'Per group';
                  '_np_', 'Non-pairwise classifier';
                  '_pa_', 'Pairwise (one-versus-one) classifier';
                  '_ovr00', 'All classes'};
            % Patterns NOT TO MATCH and their corresponding explanations
            tt2 = {'_ovr00', '2 classes (one-versus-reference)';
                   '_grag_', 'Per row'};
           
            a = {};
            for i = 1:size(tt, 1)
                if any(strfind(fn, tt{i, 1}))
                    a{end+1} = tt{i, 2};
                end;
            end;
            for i = 1:size(tt2, 1)
                if ~any(strfind(fn, tt2{i, 1}))
                    a{end+1} = tt2{i, 2};
                end;
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
   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %
    % Report object getters
    %
    % These routines allow full control over the report object parameters
    % Parameters for these routines can be got from objtool if the GUI interface for the report is properly set.
    %
    methods
        function r = get_report_soitem_merger_fhg(o) %#ok<*MANU>
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

        function r = get_report_soitem_fhg_hist(o)
            r = report_soitem_fhg_hist();
            r.data_hint = load_hintdataset();
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
        
       function r = get_report_soitem_items(o)
            r = report_soitem_items();
       end;

       function r = get_report_soitem_merger_merger_fitest(o)
            r = report_soitem_merger_merger_fitest();
            r.minimum = [];
            r.maximum = [];
       end;

       function r = get_report_soitem_merger_merger_fitest_1d(o)
            r = report_soitem_merger_merger_fitest_1d();
       end;
    end;
end
