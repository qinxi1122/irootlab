%> @ingroup globals
%> @file
%> @brief Makes sure that the MORE global exists
%>
%> @sa def_biocomparer.m, def_peakdetector.m, def_subsetsprocessor.m, def_postpr_est.m, def_postpr_test.m
function more_assert()
global MORE;
if isempty(MORE)
    MORE.pd_maxpeaks = 6;
    MORE.pd_minaltitude = 0.105;
    MORE.pd_minheight = 0.10;
    MORE.pd_mindist_units = 31;
    
    MORE.ssp_stabilitythreshold = 0.05;
    MORE.ssp_minhits_perc = 0.031;
    MORE.ssp_nf4gradesmode = 'fixed';
    
    MORE.bc_halfheight = 45;
    
    MORE.flag_postpr_grag = 0;
end;
