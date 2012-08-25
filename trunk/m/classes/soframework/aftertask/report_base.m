%> draws the figures and generates HTML for the architecture-independent
%> design
classdef report_base
    properties
        %> flag_word =0. Will affect how the percentage widths are specified for images etc
        flag_word = 0;
        
        %> Basic scale (for the full-width images)
        scale0 = 0.75;
        
        %> =1 whther to generate the images
        flag_images = 1;
        
        %> =1. Whether to create the tables
        flag_tables = 1;
        
        %> =0. Whether to show the p-values cross-comparison table
        flag_ptable = 0;
        
        %> Whether to create the figures or to skip their creations (HTML
        %> tags will still be generaged)
        flag_create_images = 1;
    end;

    properties(Access=protected)
        oo;
        subdir;
        %> file groups
        groups;
        %> "clarchsel", "undersel" etc. used to build directory name etc
        token;
    end;

    methods(Abstract)
        %> has to return "clarchsel", "undersel" etc
        s = get_token(o);
        
        %> Has to return a structure array with .name and .xxxxxx
        g = get_groups(o);
        
        %> Processes one element from o.groups
        o = process_group(o);
    end;
    
    methods(Sealed)
        function o = setup(o)
            o.token = o.get_token();

            % help yourself to this
            try
                o.oo = sosetup_scene();
            catch ME
                irverbose('Warning: failed calling sosetup_datset(). "oo" won''t be available', 2);
            end;

            
            % Gets files
            o.groups = o.get_groups();

            % Nevermind if does not finds files. setup() is an information gathering function, won't change anything anyway
            o.subdir = find_dirname(['report_', o.token]);
            
            o.flag_create_images = ~get_envflag('FLAG_SKIP_IMAGES');
        end;
        
        %> Returns filename with path for proper saving
        function s = gff(o, filename)
            s = fullfile(o.subdir, filename);
        end;
    end;

    methods
        function go(o)
            fig_assert();

            o = o.setup();
            
            if isempty(o.groups)
                irverbose('No matching files found to process');
                return;
            end;

            
            mkdir(o.subdir);
            
            [o, s0] = o.make_index();
            
            h = fopen(o.gff('index.html'), 'w');
            fwrite(h, s0);
            fclose(h);
        end;

        
        %> Default index maker
        %> @return [o, s0] s0 is an HTML string
        function [o, s0] = make_index(o)

            % Main processing
            ngroups = numel(o.groups);
            for i = 1:ngroups
                gn = o.groups(i).title;

                ss(i).groupname = gn;
                try
                    ss(i).html = o.process_group(o.groups(i)); %, '<hr/>', 10);
%                     ss(i).html = 'Comeu';
                    ss(i).flag_error = 0;
                    ss(i).filename = sprintf('group_%s.html', gn); % Fortunately the group names are derived from a file name already
                catch ME
                    ss(i).flag_error = 1;
                    ss(i).html = sprintf('<font color=red>Couldn''t process group "%s": %s!</font></p>', gn, ME.message);
                    irverbose(sprintf('(report_base::make_index()) Couldn''t process group "%s": %s!', gn, ME.message), 2);
                    if get_envflag('FLAG_RETHROW'); rethrow(ME); end;
                end;
            end;
            
            % Generates main index
            s0 = stylesheet;
            s0 = cat(2, s0, '<h1>Report contents</h1>', 10, '<center>', 10);
            s0 = cat(2, s0, '<table class="bo">');

            for i = 1:ngroups
                s0 = cat(2, s0, '<tr><td class="bo">');
                if ss(i).flag_error
                    s0 = cat(2, s0, ss(i).html);
                else
                    s0 = cat(2, s0, '<a href="', ss(i).filename, '">', ss(i).groupname, '</a>');
                end;
                s0 = cat(2, s0, '</td></tr>');
            end;
            s0 = cat(2, s0, '<tr><td class="bo"><a href="allgroups.html">All</a></td></tr>', 10);
            s0 = cat(2, s0, '</table>');
            

            
            % HTML with everything inside
            sa = stylesheet();
            for i = 1:ngroups
                head = sprintf('<h1>Group %d/%d: "%s"</h1>\n', i, ngroups, ss(i).groupname);
                sa = cat(2, sa, head, 10, ss(i).html, '<hr/>', 10);
            end;
            h = fopen(o.gff('allgroups.html'), 'w');
            fwrite(h, sa);
            fclose(h);
            
            
                
            % Individual files
            for i = 1:ngroups
                if ~ss(i).flag_error
                    head = sprintf('<h1>Group %d/%d: "%s"</h1>\n', i, ngroups, ss(i).groupname);
                    si = stylesheet();
                    si = cat(2, si, head, 10, ss(i).html);

                    h = fopen(o.gff(ss(i).filename), 'w');
                    fwrite(h, si);
                    fclose(h);
                end;
            end;
        end;
    end;

    
    % *-*-*-*-*-*-*-* TOOLS
    methods(Access=protected)
        %> Used to save a figure both as png and fig, and close it
        %> @return an "img" HTML tag that may be used if wanted
        %> @param perc =100 percentage width (0-100)
        %> @param res =(screen resolution)
        function s = save_n_close(o, fn, perc, res)
            if nargin < 3 || isempty(perc)
                perc = 100;
            end;
            if nargin < 4
                res = [];
            end;
            
            if o.flag_create_images            
                save_as_png([], o.gff(fn), res);
                save_as_fig([], o.gff(fn));
                close;
            end;
            
            s = ['<center>', 10, ...
                 '<img src="', fn, '.png" width="', int2str(perc), '%">', 10, ...
                 '</center>', 10];

        end;
        
        function s = images3(o, fn, sor)
            global SCALE;

            flag_many = size(sor.values, 2) > 1;
            

            SCALE = o.scale0; %#ok<*NASGU>

            fn1 = [fn, '_ratestimes'];
            fn3 = [fn, '_legend'];

            if o.flag_create_images
                u = vis_sovalues_drawplot();
                u.dimspec = {[0 0], [1 2]};
                u.valuesfieldname = 'rates';
                u.flag_legend = 1;
                u.flag_star = 1;
                u.ylimits = [];
                u.xticks = [];
                u.xticklabels = {};
                u.flag_hachure = ~flag_many;

                if flag_many
                    % Legend is only justified if there is more than one curve
                    figure;u.use(sor);
                    save_legend(o.gff(fn3), 150); % High DPI because this may be the only opportunity to have the legend
                    close;
                end;
            

                figure;
                subplot(1, 2, 1);
                u.use(sor);
                legend off;

                u.valuesfieldname = 'times3';
                subplot(1, 2, 2);
                u.use(sor);
                legend off;
                
                pause(.1);
                maximize_window(gcf(), 4);
            end;

            o.save_n_close(fn1);

            if flag_many
                s = ['<center>' 10, ...
                     '<img src="', fn1, '.png" border=0 width=100%>', 10, ...
                     '<br/>', 10, ...
                     '<img src="', fn3, '.png" border=0 width=10%>', 10, ...
                    '</center>', 10];
            else
                s = ['<center>' 10, ...
                     '<img src="', fn1, '.png" border=0 width=100%>', 10, ...
                    '</center>', 10];
            end;

                
            SCALE = o.scale0;



            if flag_many
                fn1 = [fn, '_rates2'];
                fn2 = [fn, '_times2'];

                if o.flag_create_images
                    u = vis_sovalues_drawsubplot();
                    u.dimspec = {[0 0], [1 2]};
                    u.valuesfieldname = 'rates';
                    u.ylimits = [];
                    u.xticks = [];
                    u.flag_star = 1;
                    u.xticklabels = {};
                    figure;u.use(sor);

                    o.save_n_close(fn1);

                    u.valuesfieldname = 'times3';
                    figure;u.use(sor);

                    o.save_n_close(fn2);
                end;
                
                s = [s, '<center>' 10, ...
                     '<img src="', fn1, '.png" width=100%>', 10, ...
                     '<br/>', 10, ...
                     '<img src="', fn2, '.png" width=100%>', 10, ...
                    '</center>', 10];
            end;
        end;

        %*****************************************************************************************************************************************

        function s = images4(o, fn, sor)
            global SCALE;

            SCALE = o.scale0;

            fn1 = [fn, '_ratestimes'];

            if o.flag_create_images
                view_ratetimesubimages(sor);
                maximize_window();
            end;

            o.save_n_close(fn1);
            
            s = ['<center>' 10, ...
                 '<img src="', fn1, '.png" width=100%>', 10, ...
                '</center>', 10];
        end;
    end;    
end
