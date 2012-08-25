%> Cross-validated Fit-estimate with the individual datasets
classdef fitest < sodesigner
    methods
        %> Gives an opportunity to change somethin inside the item, e.g. activate/desactivate pairwise
        function item = process_item(o, item)
        end;
        
        function o = customize(o)
            o = customize@sodesigner(o);
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        %> Item must be a sodataitem_diaa
        %>
        %> The cell of diagnosissystem objects inside item can be nD, diacomp doesn't care
        function out = do_design(o)
            items = o.input.item;
            
            dl = o.oo.dataloader;
            no_cv = dl.k; % cross-validation's "k"
            
            [postpr_test, postpr_est] = o.oo.cubeprovider.get_postpr();
            
            for i = 1:no_cv
                dl.cvsplitindex = i;
                dl.ttindex = 1;
                ds_fit = dl.get_dataset();
                if i == 1
                    dstitle = ds_fit.title;
                    logs = o.oo.cubeprovider.ttlogprovider.get_ttlogs(ds_fit);
                    no_logs = numel(logs);
                    for j = 1:no_logs
                        logs{j} = logs{j}.allocate(no_cv);
                    end; 
                end;
                dl.ttindex = 2;
                ds_est = dl.get_dataset();
            
                item = o.process_item(items{i});
                blk = item.dia.get_block(); % I am not sure whether it is a diaa or what, here
                
                logs = singlett(logs, blk, ds_fit, ds_est, postpr_test, postpr_est);
            end;
                
            out = sodataitem_fitestout();
            out.dia = item.dia;
            out.logs = logs;
            out.title = ['Cross-validation ', out.dia.get_sequencedescription()];
            out.dstitle = dstitle;
        end;
    end;
end