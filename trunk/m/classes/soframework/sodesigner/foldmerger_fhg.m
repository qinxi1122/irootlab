%> Merges individual cross-validation-fold-wise log_fselrepeater objects
classdef foldmerger_fhg < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            items = o.input;
            ni = numel(items);
            
            log = items{1}.log; % Takes first log_fselrepeater and ... (see below)
            
            for i = 2:ni
                % ... merges with other log_fselrepeater
                temp = items{i}.log;
                log.logs = [log.logs, temp.logs];
%                 log.subsets = [log.subsets, temp.subsets];
%                 log.nfxgrade = [log.nfxgrade; temp.nfxgrade]; % This one will be filled in only for the FHG_FFS case
            end;
            

            out = items{1};
            out.log = log;
        end;
    end;
end


                
                
                
