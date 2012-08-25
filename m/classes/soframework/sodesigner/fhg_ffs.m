%> FHG - Feature Histogram Generator - set for a Forward Feature Selection using a classifier
%>
%> if o.oo.cubeprovider.no_reps_stab > 0, will activate a sub-sampling loop within the Feature Selection.
classdef fhg_ffs < fhg
    methods
        %> The classifier matters here, therefore adds the class of the classifier's class to the default output
        function s = get_s_methodology(o, dia)
            blk = dia.sostage_cl.get_block();
            s = [get_s_methodology@fhg(o), '&', blk.title];
        end;
    

        function fb = get_as_fsel(o, ds, dia)
            if dia.sostage_cl.flag_pairwise
                irwarning('Feature Histogram Generation with pairwise classifier is gonna be slooooooooooow');
            end;
            if dia.sostage_cl.flag_under
                dia.sostage_cl.under_no_reps = 1; % Restricts undersampling to 1 component classifier
            end;

            [pr_t, pr_e] = o.oo.cubeprovider.get_postpr();

            lo = estlog_classxclass();
            lo.estlabels = ds.classlabels;
            lo.testlabels = ds.classlabels;
            lo.flag_inc_t = 0;

            fsg = fsg_clssr();
            fsg.postpr_est = pr_e;
            fsg.postpr_test = pr_t;
            fsg.estlog = lo;
            if  o.oo.cubeprovider.no_reps_stab > 0
                sgs_stab = o.oo.cubeprovider.get_sgs_fhg_stab(); % This one is for the stabilization
                fsg.sgs = sgs_stab;
            end;
            fsg.clssr = dia.sostage_cl.get_block();
            
            fb = as_fsel_forward;
            fb.nf_select = o.oo.fhg_ffs_nf_select;
            fb.fsg = fsg;
        end;
    end;
end
