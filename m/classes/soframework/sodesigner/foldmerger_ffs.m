%> Cross-validated Fit-estimate with the individual fold-wise datasets.
%>
%> This one starts with one feature datasets only and adds features gradually to raise nf x grade curves
%>
%> The result is stored in a dataset with one row per fold. The recording is the "rate"
%>
%> 
classdef foldmerger_ffs < sodesigner
    % Bit lower level
    methods(Access=protected)
        %> Item must be a soitem_diaa
        %>
        %> The cell of diagnosissystem objects inside item can be nD, diacomp doesn't care
        function out = do_design(o)
            items = o.input;
            
            dl = o.oo.dataloader;
            no_cv = dl.k; % cross-validation's "k"
            

            % First pass to determine a minimum number of selected features
            minnf = Inf;
            for i = 1:no_cv
                item = items{i};
                dia = item.get_modifieddia();
                minnf = min(numel(dia.sostage_fe.v), minnf);
            end;
            
            dsout = irdata();
            dsout.title = 'nf versus rate';
            dsout.classes = zeros(no_cv, 1);
            dsout.xname = 'Number of features';
            dsout.xunit = '';
            dsout.yname = 'Classification rate';
            dsout.yunit = '%';
           
            
            for i = 1:no_cv
                item = items{i};
                
                % Gets datasets
                dl.cvsplitindex = i;
                dl.ttindex = 1;
                ds_fit = dl.get_dataset();
                if i == 1
                    % Initialization that is data-dependent is done in the first iteration when we have data
                    dstitle = ds_fit.title;
                    logs = o.oo.cubeprovider.ttlogprovider.get_ttlogs(ds_fit);
                    ratelog = logs{1}; % fair assumption

                    cube = o.oo.cubeprovider.get_cube(ds_fit);
                    cube.log_mold = {ratelog}; % Needs one log only
                    cube.sgs = []; % Note below that cube.data will have 2 elements
                end;
                dl.ttindex = 2;
                ds_est = dl.get_dataset();
                
                % Gets "v" and other things from the diagnosissystem
                dia = item.get_modifieddia();
                molds = cell(minnf, 1);
                for j = 1:minnf
                    dia.sostage_fe.nf = j;
                    molds{j, 1} = dia.get_fecl();
                end;
                
                
                % Cube
                cube.block_mold = molds;
                cube.data = [ds_fit, ds_est];
                cubelog = cube.go();
                
                % Reads dataset into dataset row
                logcell = squeeze(cubelog.logs)';
                dsout.X(i, :) = cellfun(@(x) (x.get_rate()), logcell);
            end;
            
            % Finalizes dataset
            dsout = dsout.assert_fix();
                
            out = soitem_foldmerger_ffs();
            out.data = dsout;
            out.title = ['Forward feature selection fold merging - ', item.title];
            out.dstitle = dstitle;
        end;
    end;
end