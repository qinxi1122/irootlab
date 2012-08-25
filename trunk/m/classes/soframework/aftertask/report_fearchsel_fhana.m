%> Stability index report
classdef report_fearchsel_fhana < report_base

    properties
        %> =1. Whether to search the number of features for the histogram in the fhana file
        flag_search_nf4hist = 1;

        
        % ayayay muchacho, these properties below probably came from the report_feahist, which will be merged with this one
        
        %> =3. Number of informative hits
        no_informative = [];
        
        %> ='kun'. see @ref as_fsel_hist::weightmode
        weightmode = 'uniform';
    end;
      

    methods
        function s = get_token(o)
            s = 'fearchsel_fhana';
        end;

        %> Returns an array with .title and .filenames
        function g = get_groups(o) %#ok<MANU>
            g = [];
            
            % dir pass 1: finds groups of files
            ff = dir('*.mat');

            prefixes = {};
            for h = 1:numel(ff)
                fn = ff(h).name;
                [pa, na, ex] = fileparts(fn); %#ok<ASGLU,NASGU>

                aa = regexp(na, 'output_fearchsel_fhana_(?<whatever2>.+)_stab', 'names');
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
                    
                ds = irdata(); % Kuncheva's stability index curves (one curve per dataset
                ds.classlabels = replace_underscores(fi);
%                 dse1 = ds;
%                 dse2 = ds; % Entropy curves datasets
                s2 = ['<h3>Images</h3>', 10]; % Histograms
                s3 = ''; % not used?
                
%                 profile on;
                
                for j = 1:nfi
                    fnprefix2 = sprintf('%s_ds%03d_file%03d', group.prefix, i, j);

                    item = itemss{j, i};
                    sor = item.sovalues;
                    
                    % Per-file images
                    s2 = cat(2, s2, '<h4>File "', group.filenames{j}, '"</h4>', 10, o.image_nfxnf4hist(fnprefix2, sor), 10);
                end;
                
%                 profile viewer;
                
                s0 = cat(2, s0, s2, s3);
                s0 = cat(2, s0, ''); %'<h3>Summary curves</h3>', 10, o.image_stability(fnprefix1, ds), 10);
%                 s0 = cat(2, s0, o.image_entropy(fnprefix1, dse1, dse2), 10);
                
                s0 = cat(2, s0, '<hr/>', 10);
            end;
            if nds > 1
                s1 = cat(2, s1, '</ul>', 10);
            end;
            
            s0 = cat(2, s1, s0);
            
        end;            
        

        
        %> 3 subplots
        function s0 = image_nfxnf4hist(o, fn, sor)
            if o.flag_create_images
                u = vis_sovalues_drawimage();
                u.dimspec = {[0 0], [1, 2]};
                u.valuesfieldname = 'rates';
                u.clim = [];
                u.flag_logtake = 0;
                u.flag_transpose = 0;
                figure;
                u.use(sor);

                pause(.1);
                maximize_window(gcf(), 4.5);
            end;

            s0 = o.save_n_close(sprintf('%s_fn4hist', fn));
        end;
    end;
end



        