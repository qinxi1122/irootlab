%>@ingroup idata globals
%> @file
%> @brief Returns the default "fixed" subsetsprocessor
%>
%> Returns a subsetsprocessor that uses Kuncheva's stability measure to determine the number of features to compose the grades vector; other setup options
%> defined in the MORE global
%>
%> @sa more_assert.m, setup_write.m
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_subsetsprocessor(out)
if nargin == 0 || isempty(out)
    more_assert();
    global MORE;  %#ok<TLEV>
    irverbose(sprintf('INFO: Default subsetsprocessor (mode="%s") ...', MORE.ssp_nf4gradesmode), 2);
    out = subsetsprocessor();
    out.nf4grades = [];
    out.nf4gradesmode = MORE.ssp_nf4gradesmode;
    out.stabilitytype = 'kun';
    out.stabilitythreshold = MORE.ssp_stabilitythreshold;
    out.minhits_perc = MORE.ssp_minhits_perc;
end;
