%> @brief OBSOLETE Generates a bmtable based on values and sostages
%>
%> Sostages need to be objects of type sostage_fe_fs
classdef bmtablegenerator < irobj
    properties
        sovalues;
        
        dimspec;
        
        %> Structure with varying fields and dimension 1-D , i.e., [number of cases]
        values;
        
        %> @ref sostage objects that correspont to the cases in @ref values
        sostages;

        %> =10 Maximum number of "biomarkers"
        nf_max = 10;
        
% % % % %         %> @ref raxisdata object
% % % % %         ax = raxisdata();
    end;
    
    methods
        
        function bt = get_bmtable(o)
            if isempty(o.sovalues.sostages)
                ss = o.sovalues.sostagess;
            else
                ss = o.sovalues.sostages;
            end;
            
            [vv, ax, ax2, ss] = o.sovalues.get_vv_aa(o.sovalues.values, o.sovalues.ax, o.dimspec, ss);
            
            bt = o.get_default();
            
            [ni, nj] = size(ss);
            
            k = 0;
            for i = 1:ni
                for j = 1:nj
                    k = k+1;
                    sos = ss{i, j};
                    sos.sodata.nf_restrict = min(sos.sodata.nf_restrict, o.nf_max);
                    bt.blocks{k} = sos.get_block();
%                     bt.blocks{k}.title = sos.title;

                    bt.grid{i, j} = setbatch(struct(), {'i_block', k, 'i_dataset', 1, 'i_peakdetector', 1, 'i_art', 1, 'i_unit', ...
                        1, 'params', {'idx_fea', 1}, 'flag_sig', 0});
                end;
            end;
        end;
        
        
        function bt = get_stem(o)

            bt = o.get_default();

            
            n = numel(o.sostages);

            for i = 1:n
                sos = o.sostages{i};
                sos.sodata.nf_restrict = min(sos.sodata.nf_restrict, o.nf_max);
                bt.blocks{i} = sos.get_block();
%                 bt.blocks{i}.title = o.sostages{i}.title;
            end;
    
            for i = 1:n
                bt.grid{1, i} = setbatch(struct(), {'i_block', i, 'i_dataset', 1, 'i_peakdetector', 1, 'i_art', 1, 'i_unit', ...
                    1, 'params', {'idx_fea', 1}, 'flag_sig', 0});
            end;

            bt.rowname_type = 'block';
            bt.flag_train = 0;
            
            bt = bt.go();
        end;
        
        
        function bt = get_default(o)
%             art = bmart_pentagram;
%             art.color = [0.8510 0.3725 0.0078];
            % art.marker = '*';

            pd = peakdetector();
            pd.mindist_units = 0;
            pd.no_max = o.nf_max;

            bt = bmtable();
            bt.peakdetectors = {}; %{pd};
            bt.datasets = {}; 
%             bt.arts = {art};
            bt.units = {bmunit_hist};
            bt.data_hint = load_hintdataset();
        end;
    end;
end
