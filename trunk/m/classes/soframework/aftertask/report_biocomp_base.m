%> Biomarkers comparison report
classdef report_biocomp_base < report_base
    properties
        halfheight = 30; % Half height for biomarker comparison (measured in cm^-1)
    end;
    
    % To move to bottom of file later
    methods(Access=protected)
        function pd = get_peakdetector(o)
            pd = peakdetector();
            pd.mindist_units = 30;
            pd.no_max = 7;
        end;
        
        function osp = get_subsetsprocessor(o)
            osp = subsetsprocessor();
            osp.weightmode = 'uniform';
            osp.nf4gradesmode = 'fixed'; % later will be changed to 'stability'
            osp.stabilitythreshold = 0.05;
        end;
        
        %> Returns Desired stab or lower
        function f = get_filename_stab(o, dir, token, stab)
            
            function n = lowerstab(stab)
                v = [0, 2, 5, 10, 20, 50];
                idx = find(stab == v);
                if isempty(idx)
                    irerror(sprintf('Not working with stab=%d', stab));
                end;
                n = [];
                if idx > 1
                    n = v(idx-1);
                end;
            end
            
            while 1
                f = fullfile(dir, sprintf('output_fhg_%s_stab%02d.mat', token, stab));
                if ~exist(f, 'file');
                    stab = lowerstab(stab);
                    if isempty(stab)
                        irerror(sprintf('Couldn''t find a file for dir "%s" and token "%s"', dir, token));
                    end;
                else
                    break;
                end;
            end;
        end;
    end;
    
    
    methods
        function s = get_token(o)
            s = 'biomarkercomparison';
        end;


        function s0 = process_group(o, group)
            topref = sprintf('%s_top', group.title);

            % Loads all files into a "itemss variable
            fi = group.filenames;
            nfi = numel(fi);
            
            for j = 1:nfi
                load(fi{j});
                itemss(j, :) = r.sodata.items; % If there is inconsistent dimension there will be an error here, but this is heavily unlikely
            end;
            
            s0 = ''; % Final string
            s1 = ''; % Table of contents
            nds = size(itemss, 2);
            if nds > 1
                s1 = ['<a name="', topref, '"/><ul>', 10];
            end;
            for i = 1:nds
                
                fnprefix1 = sprintf('%s_ds%03d', group.prefix, i);
                

                if nds > 1
                    % TOC
                    s1 = cat(2, s1, '<li><a href="#', fnprefix1, '">', itemss{1, i}.dstitle, '</a></li>', 10);

                    s0 = cat(2, s0, sprintf('<h2>Dataset %d/%d: "%s"', i, nds, itemss{1, i}.dstitle), '&nbsp;<a name="', fnprefix1, '"/><a href="#', topref, '">&uarr;</a></h2>', 10);
                end;
            
                    
                clear('biolist', 'ass');
                for j = 1:nfi
                    item = itemss{j, i};
                    ass(j) = item.as_fsel_hist;
                    [a1, ass(j).title, a3] = fileparts(fi{j}); %#ok<NASGU>
                end;
                
                s0 = cat(2, s0, o.process_ass(fnprefix1, ass)); % Generates figures and tables
                s0 = cat(2, s0, '<hr/>', 10);
            end;
            if nds > 1
                s1 = cat(2, s1, '</ul>', 10);
            end;
            
            s0 = cat(2, s1, s0);
        end;            
    end;      
   
    
    methods(Access=protected)
        function s = process_ass(o, fnprefix, ass)
            fig_assert();
            global SCALE;
            save_SCALE = SCALE;
            

            s = '';
            NO_SETUPS = 2;
            no_ass = numel(ass);
            
            % SCALE = MINSCALE when no_ass = MAXPLOTS
            % SCALE = MAXSCALE when no_ass = 1
            MAXSCALE = 2;
            MINSCALE = 0.6;
            MAXPLOTS = 6;
            SCALE = (no_ass-1)*(MINSCALE-MAXSCALE)/(MAXPLOTS-1)+MAXSCALE;
            
            osp = o.get_subsetsprocessor();
            pd = o.get_peakdetector();
            u = vis_stackedhists();
            
            for i_setup = 1:NO_SETUPS
                switch i_setup
                    case 1
                        osp.nf4gradesmode = 'fixed';
                        osp.nf4grades = [];
                        setupname = 'Fixed nf4grades';
                        u.colors = {}; % Will use the Jet colormap anyway
                        % [], .7*[1, 1, 1], .9*[1, 1, 1]};
                    case 2
                        osp.nf4gradesmode = 'stability';
                        osp.stabilitythreshold = 0.05;
                        setupname = 'Stability-based nf4grades';
                        u.colors = {[.8, 0, 0], [.9, .2, .2], .7*[1, 1, 1], .85*[1, 1, 1]}; % That red-and-gray
                end;
                
                s = cat(2, s, sprintf('<h3>Setup "%s"</setup>\n<h4>Histograms</h4>\n', setupname));
                
                if o.flag_create_images
                    figure;
                end;
                
                for i  = 1:no_ass
                    a = ass(i);

                    % Calculations
                    a.subsetsprocessor = osp;
                    a = a.update_from_subsets();
                    pd = pd.boot(a.fea_x, a.grades);

                    % Collects biomarkers
                    idxs = pd.use(a.grades);
                    biolist(i).wns = a.fea_x(idxs);
                    biolist(i).weights = sqrt(a.grades(idxs));

                    if o.flag_create_images
                        u.no_informative = a.nf4grades_calculated;
                        u.peakdetector = pd;

                        % Plot
                        subplot(no_ass, 1, i);
                        u.use(a);
                        title(replace_underscores(sprintf('Case %s, nf4grades=%d', a.title, a.nf4grades_calculated)));
                        legend off;
                        
                        
                        switch i_setup
                            case 1
                                colormap('jet');
                            case 2
                        end;
                        
                        freezeColors();
                    end;

                end;
                
                if o.flag_create_images
                    pause(.1);
                    maximize_window(gcf(), 4/no_ass);
                end;
                
                % === Biomarkers comparison tables (will construct four different tables)
                s = cat(2, s, '<h4>Biomarkers coherence</h4>', 10);
                for k = 1:4
                    flag_weight = k == 1 || k == 3;
                    flag_2 = k == 3 || k == 4;
                    
                    s = cat(2, s, sprintf('<h5>%s, %s</h5>\n', iif(flag_2, 'Second algorighm', 'First algorithm'), iif(flag_weight, 'Weighted by sqrt(peak heights)', 'Weightless')));
                    
                    fun = iif(flag_2, @compare_biomarkers2, @compare_biomarkers);
                    WA = [];
                    WB = [];
                        
                    % + Mounts table
                    M = eye(no_ass);
                    for i = 1:no_ass
                        for j = i+1:no_ass
                            A = biolist(i).wns;
                            B = biolist(j).wns;
                            if flag_weight
                                WA = biolist(i).weights;
                                WB = biolist(j).weights;
                            end;
                                
                                
                            [matches, index] = fun(A, B, WA, WB, o.halfheight); %#ok<ASGLU>
                            M(i, j) = index;
                            M(j, i) = index;
                        end;
                    end;
                    M = round(M*1000)/1000;
                
                    % + generates the HTML
                    s = cat(2, s, html_comparison(M, {ass.title}));
                end;
                
                s = cat(2, s, o.save_n_close(sprintf('%s_histograms_setup_%d', fnprefix, i_setup), 60, 150), '<hr/>');
            end;
            
            SCALE = save_SCALE;
        end;
    end;
end
