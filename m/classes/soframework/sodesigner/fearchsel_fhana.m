%> FEARCHSEL-FHANA - Feature Histogram Analyser
%>
%>
classdef fearchsel_fhana < fearchsel
    properties
        %> Maximum number of features. Tested number of features will start with 1 until nf_max
        nf_max;
        %> ='uniform'. Hits weighting mode. See as_fsel_hist::weightmode
        weightmode = 'uniform';
    end;
    
    methods
        function o = customize(o)
            o = customize@fearchsel(o);
            o.nf_max = o.oo.fearchsel_fhana_nf_max;
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
    
        %> Finds "v"
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
            dia.sostage_fe = sostage_fe_fs;
            dia.sostage_fe.fea_x = ds.fea_x;
            as = item.as_fsel_hist;
            nnfh = size(as.hitss, 1);
            
                
            molds = cell(o.nf_max, nnfh);
            for infh = 1:nnfh
                for inf = 1:o.nf_max
                    as.weightmode = o.weightmode;
                    as.type = 'nf';
                    as.nf_select = inf;
                    as.nf4grades = infh;
                    as = as.update_from_subsets();
                    as = as.process_grades(); % Recalculates the grades vector

                    dia.sostage_fe.v = as.v;
                    dia.sostage_fe.grades = as.grades;
                    specs{inf, infh} = sprintf('nf4hist=%d, nf=%d', infh, inf);

                    molds{inf, infh} = dia.get_fecl();
                    sostages{inf, infh} = dia.sostage_fe;
                end;
            end;            

            r = o.go_cube(ds, molds, sostages, specs);

            r.ax(1) = raxisdata_unit('Number of Features', 'nf', 1:o.nf_max);

            r.ax(2) = raxisdata_unit('NF for histogram', 'nf4hist', 1:nnfh);

            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
        end;        
    end;
end
