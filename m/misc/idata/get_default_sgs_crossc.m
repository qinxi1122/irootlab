%>@file
%>@ingroup idata
%>@brief Returns default SGS for cross-calculation operations
%>
%> The default SGS is a 5-fold cross-validation <code>flag_group = 1</code>
function o  = get_default_sgs_crossc()

o = sgs_crossval();
o = o.setbatch({'flag_group', 1, ...
'flag_perclass', 0, ...
'randomseed', 0, ...
'flag_loo', 1, ...
'no_reps', 5});

