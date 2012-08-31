%> @brief sostage - Rubberband -> Normalization
%>
%>
classdef sostage_pp_rubbernorm < sostage_pp
    properties
        %> ='1'. Defaults to "Amide 1 Peak"
        %> @warning Must not have any vertical normalization (e.g. standardization or mean-centering)! Because the pre-processing is applied to training and test sets separately sometimes.
        norm_types = '1';
        
        
    end;

    methods
        function o = sostage_pp_rubbernorm()
            o.title = 'RBBC-NAm';
        end;
    end;
    
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = block_cascade();

            cutter1 = fsel();
            cutter1 = cutter1.setbatch({'v_type', 'rx', ...
            'flag_complement', 0, ...
            'v', [1800, 900]});
        
            out.blocks = {cutter1};
            
            if o.ndec > 0
                for i = 1:o.ndec
                    out.blocks{end+1} = fcon_decimate();
                end;
            end;

            rbbc = pre_bc_rubber();
            rbbc.flag_trim = 1;
            out.blocks{end+1} = rbbc;
            
            norer = pre_norm();
            norer.types = o.norm_types;
            out.blocks{end+1} = norer;
            
            if o.flag_spline
                osp = fcon_spline();
                osp.no_basis = o.spline_nf;
                out.blocks{end+1} = osp;
            end;
        end;
    end;
end
