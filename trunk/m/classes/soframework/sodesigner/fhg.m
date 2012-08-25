%> FHG - Feature Histogram Generator
%>
%> <h3>Stabilization</h3>
%> It is not obvious how data is used in either case (i.e., with/without stabilization). So, this is explained in detail.
%> @arg Without stabilization, the dataset that reaches the fselrepeater will be split (probably 90%-10%) guided by the cubeprovider::get_sgs_fhg()
%>      SGS, so that the FSG will receive 2 datasets;
%> @arg With stabilization, the FSG will receive the same dataset, but its SGS property will be set, so it will ignore the 10% and will sub-sample the
%>      90% for an averaged performance estimation.
classdef fhg < sodesigner
    methods
        function o = customize(o)
            o = customize@sodesigner(o);
        end;
    end;
    
    methods(Abstract)
        as_fsel = get_as_fsel(o, ds, dia);
    end;
    
    methods
        %> Must return a unique string describing the FHG methodology. Defaults to <code>class(o)</code>
        function [s, s2] = get_s_methodology(o, dia) %#ok<INUSD>
            s = upper(class(o));
            s2 = '';
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);

            % Creates all those objects
            sgs = o.oo.cubeprovider.get_sgs_fhg();

            ah = fselrepeater(); 
            ah.data = ds;
            ah.sgs = sgs;
            ah.fext = pre_std();
            ah.flag_parallel = o.oo.flag_parallel;
            ah.as_fsel = o.get_as_fsel(ds, dia);
            log = ah.go();
            
            out = soitem_fhg();
            out.log = log;
            out.dia = dia;
            out.stab = o.oo.cubeprovider.no_reps_stab;
            out.s_methodology = o.get_s_methodology(dia);
            out.dstitle = ds.title;
            out.dstitle = ds.title;
            out.title = [out.s_methodology, ...
                         iif(out.stab >= 0, sprintf('stab%02d', o.oo.cubeprovider.no_reps_stab), '')...
                         ': ', out.dia.get_sequencedescription()];
        end;        
    end;
end
