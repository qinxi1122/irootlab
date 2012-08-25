%> Algorithm-independent design - correction for unbalanced dataset
%>
%> This class was originally comparing non-pairwise vs. pairwise X (carterian product) balancing strategy
%>
%> Now it is only addressing the balancing issue
%>
%>
classdef undersel < sodesigner
    properties
        unders = NaN;
    end;
    
    methods
        function o = customize(o)
            o = customize@sodesigner(o);
            o.chooser = o.oo.undersel_chooser;
        end;
    end;
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);
            
            % Makes a vector of blocks
            nunder = numel(o.unders);
            ticks = {};
            i1 = 0;
            for iu = -1:nunder
                if iu == 0 && ~dia.sostage_cl.flag_cbable
                    continue;
                end;
                
                i1 = i1+1;
                if iu == -1
                    ticks{i1} = 'None';
                elseif iu == 0
                    ticks{i1} = 'Formula';
                else
                    ticks{i1} = sprintf('U%d', o.unders(iu));
                end;
                    
                dia.sostage_cl.flag_cb = iu == 0;
                dia.sostage_cl.flag_under = iu > 0;
                if iu > 0
                    dia.sostage_cl.under_no_reps = o.unders(iu);
                else
                    dia.sostage_cl.under_no_reps = [];
                end;                    

                molds{i1, 1} = dia.get_fecl();
                sostages{i1, 1} = dia.sostage_cl;
            end;
            
            r = o.go_cube(ds, molds, sostages, ticks');
            
            r.ax(1).label = 'Undersampling strategy';
            r.ax(1).values = [iif(dia.sostage_cl.flag_cbable, [-1, 0], [0]), o.unders];
            r.ax(1).ticks = ticks;
            
            r.ax(2) = raxisdata_singleton();
       
            out = soitem_undersel();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
            out.title = ['Undersampling Selection - ', out.dia.get_sequencedescription()];
            out.dstitle = ds.title;
        end;
    end;
end
