%>@ingroup idata
%>@file
%>@brief get_credits
%>@todo mention another publication

function s = get_credits()

s = sprintf([ ...
    '\n', ...
    '*********************************************************************************************************\n', ...
    'IRoot v', iroot_version(), '\n\n', ...
    'Copyright 2012 Julio Trevisan, Francis L. Martin & Plamen P. Angelov.\n\n', ...
    'This product is licenced under the terms of the GNU Lesser General Public License (http://www.gnu.org/licenses/lgpl.html).\n\n', ...
    'Please mention the website in your publications: http://bioph.lancs.ac.uk/iroot\n\n', ...
    ]);