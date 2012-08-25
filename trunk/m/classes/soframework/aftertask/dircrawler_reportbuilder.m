%> Report deleter
classdef dircrawler_reportbuilder < dircrawler
    properties
        tokens = {'clarchsel', 'fearchsel', 'undersel', 'fhg', 'fearchsel_fhana', 'diacomp', 'lcr2', 'biocomp_5'};
        tokens4 = {'biocomp_4'};
    end;
    
    methods
        function o = dircrawler_reportbuilder()
            o.patt_exclude = 'report';
        end;

        function o = process_dir(o, d)
            dd = dir('output*.mat'); % Probes if there is any mat file at current directory
            if ~isempty(dd)
            
                n = numel(o.tokens);

                for i = 1:n
                    t = ['report_', o.tokens{i}];
                    try
                        go(t);
                    catch ME
                        irverbose(sprintf('(dircrawler_reportbuilder::process_dir()) %s failed: %s', t, ME.message), 2);
                        if get_envflag('FLAG_RETHROW')
                            rethrow(ME);
                        end;
                    end;
                end;
            end;
            
            
            dd = dir('nospline*'); % Probes if is at the "nospline-spline-ndec2" level
            if ~isempty(dd)
                n = numel(o.tokens4);

                for i = 1:n
                    t = ['report_', o.tokens4{i}];
                    try
                        go(t);
                    catch ME
                        irverbose(sprintf('(dircrawler_reportbuilder::process_dir()) %s failed: %s', t, ME.message), 2);
                        if get_envflag('FLAG_RETHROW')
                            rethrow(ME);
                        end;
                    end;
                end;
            end;
        end;
    end;
end