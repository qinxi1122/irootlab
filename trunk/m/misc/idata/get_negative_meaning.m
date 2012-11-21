%>@ingroup idata
%>@file
%>@brief Returns string that explaing what a negative (-1, -2, -3) class means.

%> @param x A value <= -1
function s = get_negative_meaning(x)

if x == -1
    s = 'Refuse-to-decide';
elseif x == -2
    s = 'Outlier';
elseif x == -3
    s = 'Refuse-to-cluster';
elseif x >= 0
    irerror('< 0, please');
else
    irerror(sprintf('Unrecognized: %d', x));
end;
