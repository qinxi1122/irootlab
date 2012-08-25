Mergeia, mergeia



% I might still want to use this. But I am quite convinced that the number of features for the histogram cannot be searched automatically, at least
% not yet
% % % % % if o.flag_search_nf4hist
% % % % %     dimspec = {[ids 0 0 icl], [1 2]};
% % % % %     [vv, aa] = sovalues.get_vv_aa(sor.values, sor.ax, dimspec); %#ok<NASGU>
% % % % % 
% % % % % 
% % % % %     %> Finds the "best" (x, y) to put a star on the image
% % % % %     ch2d = chooser_2d();
% % % % %     ch2d.chooser = chooser_notime;
% % % % %     star_ij = ch2d.use(sor.getYY(vv, 'rates'), sor.getYY(vv, 'times3'));
% % % % %     noinf =  star_ij(1);
% % % % % else
% % % % %     noinf = o.no_informative;
% % % % % end;



classdef report_fhg < report_base

    properties
        %> =1. Whether to search the number of features for the histogram in the fhana file
        flag_search_nf4hist = 1;

        
        % ayayay muchacho, these properties below probably came from the report_feahist, which will be merged with this one
        
        %> =3. Number of informative hits
        no_informative = 3;
        
        %> ='kun'. see @ref as_fsel_hist::weightmode
        weightmode = 'uniform';
    end;
      

    methods
        function s = get_token(o)
            s = 'fhg';
        end;

        %> Returns an array with .title and .filenames
        function g = get_groups(o) %#ok<MANU>
            g = [];
            
            % dir pass 1: finds groups of files
            ff = dir('*.mat');

            prefixes = {};
            for h = 1:numel(ff)
                fn = ff(h).name;
                [pa, na, ex] = fileparts(fn); %#ok<ASGLU>

                aa = regexp(na, 'output_fhg_(?<whatever2>.+)_stab', 'names');
                if ~isempty(aa)
                    aa = regexp(na, '(?<prefix>.+)_stab', 'names');
                    prefixes{end+1} = aa.prefix;
                end;
            end;

            prefixes = unique(prefixes);
            ngroups = numel(prefixes);
            
            % dir pass 2: finds files for each group
            for i = 1:ngroups
                d = dir([prefixes{i}, '*.mat']);
                g(i).title = prefixes{i};
                g(i).filenames = {d.name};
                g(i).prefix = prefixes{i};
            end;
        end;
            
            

        function s0 = process_group(o, group)
            topref = sprintf('%s_top', group.title);

            % Loads all files into a "itemss variable
            fi = group.filenames;
            nfi = numel(fi);
            
            fi2 = {};
            k = 0;
            for j = 1:nfi
                try
                    % These two lines may give error. In this case, the file will be skipped
                    load(fi{j});
                    temp = r.sodata.items; % If there is inconsistent dimension there will be an error here, but this is heavily unlikely

                    k = k+1;
                    itemss(k, :) = temp;
                    fi2{k} = fi{j};
                catch ME
                    irverbose(sprintf('INFO: loading file "%s" failed', fi{j}));
                end;
            end;
            
            fi = fi2;
            nfi = numel(fi);
            
            
            
            
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
                    
                dsa1 = irdata(); % Kuncheva's stability index curves (one curve per dataset
                dsa1.classlabels = replace_underscores(fi);
                dsa2 = dsa1;
                dse1 = dsa1;
                dse2 = dsa1; % Entropy curves datasets
                s2 = ['<h3>Histograms</h3>', 10]; % Histograms
                s3 = ''; % not used?
                
%                 profile on;
                
                for j = 1:nfi
                    fnprefix2 = sprintf('%s_ds%03d_file%03d', group.prefix, i, j);

                    item = itemss{j, i};
                    a = item.as_fsel_hist;
                    
                    if o.flag_create_images
                        % calculates Kuncheva's stability index curve
                        dsa1.X(j, :) = featurestability(a.subsets, numel(a.fea_x), 'kun', 'mul');
                        dsa1.classes(j, 1) = j-1;
                        dsa2.X(j, :) = featurestability(a.subsets, numel(a.fea_x), 'kun', 'uni');
                        dsa2.classes(j, 1) = j-1;

                        % calculates entropies
                        dse1.X(j, :) = hitsentropy(a.hitss, 'uni');
                        dse1.classes(j, 1) = j-1;

                        dse2.X(j, :) = hitsentropy(a.hitss, 'accum');
                        dse2.classes(j, 1) = j-1;
                    end;

                    % Per-file images
                    s2 = cat(2, s2, '<h4>File "', fi{j}, '"</h4>', 10, o.image_histograms(fnprefix2, a), 10);

                    s3 = cat(2, s3, '<h4>File "', fi{j}, '"</h4>', 10, o.image_histograms2(fnprefix2, a), 10);
                end;
                
%                 profile viewer;
                
                s0 = cat(2, s0, s2, s3);
                s0 = cat(2, s0, '<h3>Summary curves</h3>', 10, o.image_stability(fnprefix1, dsa1, dsa2), 10);
                s0 = cat(2, s0, o.image_entropy(fnprefix1, dse1, dse2), 10);
                
                s0 = cat(2, s0, '<hr/>', 10);
            end;
            if nds > 1
                s1 = cat(2, s1, '</ul>', 10);
            end;
            
            s0 = cat(2, s1, s0);
            
        end;            
        


        %> Two subplots: one with the entropy of each per-i-th-feature-to-be-selected histogram; other of entropy of accumulated histogram
        function s0 = image_entropy(o, fn, dse1, dse2)
            s0 = '';
            if o.flag_create_images
                dse1 = dse1.assert_fix();
                dse2 = dse2.assert_fix();

                v = vis_means();


                % Legends figure
                figure;v.use(dse1);
                fnl = sprintf('%s_legend', fn);
                save_legend(o.gff(fnl), 150); % High DPI because this may be the only opportunity to have the legend
                close;
                s0 = ['<center>', 10, ...
                      '<img src="', fnl, '.png" width=20%>', 10, ...
                      '</center>', 10];


                figure;

                subplot(1, 2, 1);
                v.use(dse1);
                legend off;
                title('Entropy of each histogram');
                format_frank();

                subplot(1, 2, 2);
                v.use(dse2);
                legend off;
                title('Entropy of accumulated histogram');
                format_frank(); 

                pause(.1);
                maximize_window(gcf(), 5);
            end;
            
            s0 = cat(2, s0, o.save_n_close(sprintf('%s_entropy', fn)));
        end;

        
        
        %> @param ds A dataset with one row per stabilization
        function s0 = image_stability(o, fn, dsa1, dsa2)
            if o.flag_create_images
                global SCALE; %#ok<TLEV>
                save_SCALE = SCALE;
    %             s0 = 'Image'; return;
                dsa1 = dsa1.assert_fix();
                dsa2 = dsa2.assert_fix();

                SCALE = o.scale0*1; %#ok<*NASGU>
                
                v = vis_means();

                figure;
                
                subplot(1, 2, 1);
                v.use(dsa2);
                xlabel('Number of features');
                ylabel('Stability index');
                legend off;
                title('Kuncheva''s PER-FEATURE stability index');

                subplot(1, 2, 2);
                v.use(dsa1);
                xlabel('Number of features');
                ylabel('Stability index');
                legend off;
                title('Kuncheva''s MULTI-feature stability index');
                
                pause(.1);
                maximize_window(gcf(), 5);
                
                SCALE = save_SCALE;
            end;
            
            s0 = o.save_n_close(sprintf('%s_stabilitycurves', fn));
        end;
        

        
        %> 3 subplots
        function s0 = image_histograms(o, fn, a)

            if o.flag_create_images
                % Overlapped and accumulated histogram
                figure;
                subplot(1, 3, 1);
                plot(a.fea_x, a.hitss', 'LineWidth', scaled(1.5));
                title('Individual histograms');
                format_xaxis(a.fea_x);
                format_frank();



                subplot(1, 3, 2);
                hitss = a.hitss;
                for iz = 1:size(a.hitss, 1)
                    zz(iz, :) = sum(hitss(1:iz, :), 1);
                end;
                plot(a.fea_x, zz', 'LineWidth', scaled(1.5));
                title('Accumulated histogram');
                format_xaxis(a.fea_x);
                format_frank();



                subplot(1, 3, 3);
                hitss = a.hitss;
                hitss(hitss < 3) = 0; % Applies threshold
                for iz = 1:size(a.hitss, 1)
                    zz(iz, :) = sum(hitss(1:iz, :), 1);
                end;
                plot(a.fea_x, zz', 'LineWidth', scaled(1.5));
                title('Accumulated histogram with threshold (<=3)');
                format_xaxis(a.fea_x);
                format_frank();

                pause(.1);
                maximize_window(gcf(), 8);
            end;
            
            s0 = o.save_n_close(sprintf('%s_histograms', fn));
        end;
        
        
        
        %> 3 subplots
        function s0 = image_histograms2(o, fn, a)
            
            % Empirical legend coordinates if single plot
%             set(legend(), 'Position', [0.9185    0.1278    0.0610    0.7553]); % Empirical

            if o.flag_create_images
                u = vis_stackedhists();
                u.weightmode = o.weightmode;

                figure;
                subplot(1, 3, 1);
                u.colors = {[], .7*[1, 1, 1], .9*[1, 1, 1]};
                u.no_informative = [];
                u.use(a);
                colormap('jet');
                title('Jet colormap');
                legend off;
                freezeColors();

                subplot(1, 3, 2);
                u.no_informative = o.no_informative;
                u.use(a);
                title(sprintf('# informative features: %d', o.no_informative));
                legend off;
                freezeColors();

                subplot(1, 3, 3);
                u.colors = {[.8, 0, 0], [.9, .2, .2], .7*[1, 1, 1], .85*[1, 1, 1]};
                u.no_informative = [];
                u.use(a);
                title(sprintf('All features are informative'));
                legend off;
                freezeColors();

                pause(.1);
                maximize_window(gcf(), 7);
            end;
            
            s0 = o.save_n_close(sprintf('%s_histograms2', fn), [], 150);
        end;
    end;
end
