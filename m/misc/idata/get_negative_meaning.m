%>@ingroup idata
%>@file
%>@brief Returns string that explaing what a negative class means.

function s = get_negative_meaning(x)

if x == -1
    s = 'Refuse-to-decide';
elseif x == -2
    s = 'Outlier';
elseif x == -3
    s = 'Refuse-to-cluster';
end;
