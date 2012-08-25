
Olha nego, ao inves de agrupar arquivos, mergeia, mergeia


classdef report_biocomp_5 < report_biocomp_base
    methods
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
                if numel(d) > 1 % Will prevent the un-stabilized MANOVA, Fisher, and LASSO from tagging along
                    g(end+1).title = prefixes{i};
                    g(end).filenames = {d.name};
                    g(end).prefix = prefixes{i};
                end;
            end;
            
            
            % Now the "manually" mounted
            tokens = {'ffs_ldc', 'ffs_qdc', 'ffs_svm', 'lasso', 'manova', 'fisher'};
            stab = 50;
            for i = 1:numel(tokens)
                a{i} = o.get_filename_stab('.', tokens{i}, stab);
            end;
            g(end+1).filenames = a;
            g(end).title = 'cross-method';
            g(end).prefix = 'cross-method';
        end;
    end;
end
