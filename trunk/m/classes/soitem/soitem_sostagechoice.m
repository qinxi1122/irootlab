%> soitem where a choice is about modifying one of the stages of a Diagnosis System
classdef soitem_sostagechoice < soitem_sovalues
    properties
        %> diagnosissystem object
        dia;
    end;
    
    methods(Sealed)
        %> Retrieves a sostage from the sovalues to replace in the diagnosissystem
        function dia_out = get_modifieddia(o)
            dia_out = o.dia;
                
            if ~isempty(o.sovalues)
                % If sovalues is empty, replaces sovalues chosen one accordingly, otherwise uses the input diagnosis systems
                v = o.sovalues.choose_one();
                sos = v.sostage;
                if isa(sos, 'sostage_cl')
                    dia_out.sostage_cl = sos;
                elseif isa(sos, 'sostage_fe')
                    dia_out.sostage_fe = sos;
                elseif isa(sos, 'sostage_pp')
                    dia_out.sostage_pp = sos;
                end;
            end;
        end;
    end;        
end