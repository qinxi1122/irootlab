%> @brief sostage - Classification LDC/QDC
%>
%>
classdef sostage_pp_diffnorm < sostage_pp
    properties
        diff_order = 1;
        diff_porder = 2;
        diff_ncoeff = 9;
        %> ='n'. Defaults to "Vector Normalization"
        norm_types = 'n';
    end;
    
    methods
        function o = sostage_pp_diffnorm()
            o.title = 'D-VN';
        end;
        
        function out = get_default(o)
            cutter1 = fsel();
            cutter1 = cutter1.setbatch({'v_type', 'rx', ...
            'flag_complement', 0, ...
            'v', [1800, 900]});

            difer = pre_diff_sg();
            difer.order = 1;
            difer.porder = 2;
            difer.ncoeff = 9;
        
            norer = pre_norm();
            norer.types = 'n';

            out = block_cascade();    
            out.blocks = {cutter1, difer, norer};
        end;
    end;
    
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = o.get_default();
            out.blocks{2}.order = o.diff_order;
            out.blocks{2}.porder = o.diff_porder;
            out.blocks{2}.ncoeff = o.diff_ncoeff;

            out.blocks{end}.types = o.norm_types;
        end;
    end;
end
