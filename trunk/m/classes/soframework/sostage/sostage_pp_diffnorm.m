%> @brief sostage - Classification LDC/QDC
%>
%>
classdef sostage_pp_diffnorm < sostage_pp
    properties
        diff_order = 1;
        diff_porder = 2;
        diff_ncoeff = 9;
        %> ='n'. Defaults to "Vector Normalization"
        %> @warning Must not have any vertical normalization (e.g. standardization or mean-centering)! Because the pre-processing is applied to training and test sets separately sometimes.
        norm_types = 'n';
    end;
    
    methods
        function o = sostage_pp_diffnorm()
            o.title = 'Diff-VN';
        end;
    end;

    methods(Access=protected)
        function out = do_get_block(o)
            cutter1 = fsel();
            cutter1 = cutter1.setbatch({'v_type', 'rx', ...
            'flag_complement', 0, ...
            'v', [1800, 900]});

            difer = pre_diff_sg();
            difer.order = o.diff_order;
            difer.porder = o.diff_porder;
            difer.ncoeff = o.diff_ncoeff;
        
            norer = pre_norm();
            norer.types = o.norm_types;

            out = block_cascade();    
            out.blocks = {cutter1, difer, norer};            
        end;
    end;
end
