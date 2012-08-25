%> In this type of SODATAITEM, the sovalues object contains a values.dia field
classdef soitem_diachoice < soitem_sovalues
% % %     properties
% % %         %> sovalues object
% % %         sovalues;
% % %     end;
    
    methods(Sealed)
        %> Retrieves a sostage from the sovalues to replace in the diagnosissystem
        function dia_out = get_modifieddia(o)
            v = o.sovalues.choose_one();
            dia_out = v.dia;
        end;
    end;        
end