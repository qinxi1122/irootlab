%> Merges individual cross-validated estimates from several fitest outputs into a single sodataitem_diachoice with a sovalues to be looked at
classdef fhgmerger < sodesigner
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            items = o.input.item;
            ni = numel(items);
            
            for i = 1:ni
                titles{i, 1} = items{i}.dia.get_sequencedescription();
                values(i, 1) = sovalues.read_logs(items{i}.logs);
                diaa{i, 1} = items{i}.dia;
            end;
            
            r = sovalues();
            r.chooser = o.oo.diacomp_chooser;
            r.values = values;
            r = r.set_field('title', titles);
            r = r.set_field('dia', diaa);
            
            r.ax(1) = raxisdata();
            r.ax(1).label = 'System';
            r.ax(1).values = 1:ni;
            r.ax(1).legends = titles;

            r.ax(2) = raxisdata_singleton();

            out = sodataitem_diachoice();
            out.sovalues = r;
            out.title = 'Several methodologies';
        end;
    end;
end


                
                
                
