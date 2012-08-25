%>@ingroup idata
%> @file
%> @brief Returns a cell of subsetsprocxessors
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_subsetsprocessors(out)
            
MINHITS_PERC = 0.031;

out = {};

ii = [1, 2, 3, 5];
for i = 1:numel(ii)
    ssp = subsetsprocessor();
    ssp.nf4grades = ii(i);
    ssp.nf4gradesmode = 'fixed';
    ssp.title = sprintf('%d informative feature%s', ii(i), iif(ii(i) == 1, '', 's'));
    out{end+1} = ssp;
end;

ssp = subsetsprocessor();
ssp.nf4grades = [];
ssp.nf4gradesmode = 'fixed';
ssp.title = 'All informative';
out{end+1} = ssp;

ssp = subsetsprocessor();
ssp.nf4grades = [];
ssp.nf4gradesmode = 'fixed';
ssp.minhits_perc = MINHITS_PERC;
ssp.title = sprintf('All informative with minimum hits of %.1f%%', MINHITS_PERC*100);
out{end+1} = ssp;
% 
% ssp = subsetsprocessor();
% ssp.nf4gradesmode = 'stability';
% ssp.stabilitythreshold = 0.05;
% ssp.weightmode = 'uniform';
% ssp.stabilitytype = 'kun';
% ssp.title = 'Stability threshold';
% out{end+1} = ssp;
