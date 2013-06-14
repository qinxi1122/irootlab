%>@ingroup idata
%>@file
%>@brief get_cite

function s = get_cite(flagHref)
if nargin < 1
    flagHref = 1;
end;

a1 = iif(flagHref, '<a href="http://irootlab.googlecode.com">', '');
a2 = iif(flagHref, '</a>', '');


s = sprintf([ ...
'         ___ Relevant papers to cite when you use IRootLab ____\n\n', ...
'If IRootLab works well for you and you use it for your respective study\n', ...
'and publication, please cite the following:\n\n', ...
'Trevisan, J., Angelov, P.P., Scott, A.D., Carmichael, P.L. & Martin, F.L.\n', ...
'(2013) "IRootLab: a free and open-source MATLAB toolbox for vibrational\n', ...
'biospectroscopy data analysis". Bioinformatics 29(8), 1095-1097.\n', ...
'doi: 10.1093/bioinformatics/btt084.\n\n', ...
'Martin, F.L., Kelly, J.G., Llabjani, V., Martin-Hirsch, P.L., Patel, I.I.,\n', ...
'Trevisan, J., Fullwood, N.J. & Walsh, M.J. (2010) "Distinguishing cell\n', ...
'types or populations based on the computational analysis of their infrared\n', ...
'spectra". Nature Protocols 5(11), 1748-1760. doi:10.1038/nprot.2010.133\n', ...
]);