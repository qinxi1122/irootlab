%> FHG - Feature Histogram Generator
%>
%>
classdef fhg_pcalda < fhg
    methods
        %> The classifier matters here, therefore adds the class of the classifier's class to the default output
        function s = get_s_methodology(o, dia)
            s = [upper(class(o)), int2str(o.oo.fhg_pcalda_no_factors)];
        end;
    
        function as = get_as_fsel(o, ds, dia) %#ok<*INUSD>
            pd = peakdetector();
            pd.mindist_units = 30;
            pd.no_max = 0;
            
            blk = cascade_pcalda();
            blk.no_factors = o.oo.fhg_pcalda_no_factors;
            
            af = as_grades_loadings();
            af.fcon_linear = blk;
            
            ag = as_fsel_grades();
            ag.nf_select = o.oo.fhg_pcalda_nf_select;
            ag.peakdetector = pd;
            
            as = as_fsel_grades_super();
            as.as_grades_data = af;
            as.as_fsel_grades = ag;
        end;
    end;
end
