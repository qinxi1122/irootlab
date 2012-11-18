%> Report deleter
classdef dircrawler_demoindexbuilder < dircrawler
    properties(SetAccess=protected)
        map = {};
        html;
    end;
        
    methods
        function o = dircrawler_demoindexbuilder()
            o.patt_exclude = '';
            o.rootdir = fullfile(get_rootdir(), 'demo');

        end;

        function o = process_dir(o, d)
            level = sum(d == filesep) - sum(o.rootdir == filesep)+1; % Uses number of slashes to determine level
            
            ff = dir('*.m');
            names = {ff.name};
            no = numel(names);
            
            for i = 1:no
                if i == 1
                    r = [];
                    if exist(fullfile(d, 'README.txt'), 'file')
                        h = fopen(fullfile(d, 'README.txt'), 'r');
                        r = fgets(h);
                        fclose(h);
                    end;
                    
                    [q, w] = fileparts(d);
                    o.map(end+1, :) = {[repmat('  ', 1, 2*(level-1)), '<b>', upper(w), '</b>'], r};
                end;
                h = fopen(fullfile(d, names{i}), 'r');
                s = fgets(h);
                s = strrep(s, '%>', '');
                s = strrep(s, '@brief', '');
                
                [q, w, e] = fileparts(names{i});

                o.map(end+1, :) = {[repmat('&nbsp;', 1, 2*level), '<a href="matlab: open_demo(''', w, ''')">', upper(w), '</a>'], [s, '&nbsp;<a href="matlab:help2(''', names{i}, ''')">. . .</a>']};
            end;
        end;
        
        function o = finish(o)
            n = size(o.map, 1);
            
            if n == 0
                irverbose('Nothing was generated!');
                return;
            end;
            

            s = stylesheet();
            s = cat(2, s, '<body bgcolor=#ffe592><h1>IRootLab demos</h1><center>', 10);
            
%             aa = {'Dataset', 'Observation meaning', 'Portion of dataset used', 'Dataset split', 'Pre-processing spec'};


            s = cat(2, s, '<table class = nobo>', 10);
            for i = 1:n
                s = cat(2, s, '<tr>', 10);
                s = cat(2, s, '<td valign=top>', o.map{i, 1}, '</td><td valign=top>', o.map{i, 2}, '</td>', 10);
                s = cat(2, s, '</tr>', 10);
            end;
            s = cat(2, s, '</table>', 10);
            s = cat(2, s, '</center></body>', 10);
            
            o.html = s;
        end;
    end;
end