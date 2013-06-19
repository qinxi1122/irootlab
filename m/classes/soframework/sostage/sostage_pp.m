%> @brief system optimizer stage doer - Pre-processing generic
%>
%>
classdef sostage_pp < sostage
    properties
        flag_spline = 0; % I still have to implement this;
        spline_nf;
        
        %> Resampling number of features. If <= 0, there will be no resampling
        nf_resample = 0;
    end;
end
