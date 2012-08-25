%> ClArchSel base class for those classifiers whose only optimization is the number of features in the FE coupled stage
classdef clarchsel_noarch < clarchsel
    properties
        nfs;
    end;
    
    methods        
        function o = customize(o)
            o = customize@clarchsel(o);
        end;        
    end;
    
    methods(Abstract)
        %> LDC, QDC, DIST, all differ only in which sostage_cl that they use
        sos = get_sostage_cl(o);
    end;
        
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            dia.sostage_cl = o.get_sostage_cl();
            
            out = soitem_sostagechoice();
            out.sovalues = [];
            out.dia = dia;
            out.title = [upper(class(o)), ': ', out.dia.get_sequencedescription()];
            out.dstitle = '(not used)';
        end;
    end;

end
