%>@ingroup idata
%> @file
%> @brief Returns the default "fixed" biocomparer
%
%> @param out If passed, returns it; otherwise, returns a default object
function out = def_biocomparer(out)
if nargin == 0 || isempty(out)
    more_assert();
    global MORE; %#ok<TLEV>
    irverbose(sprintf('INFO: Default biocomparer... (halfheight = %d)', MORE.bc_halfheight), 2);
    out = biocomparer();
    out.flag_use_weights = 1;
    out.halfheight = MORE.bc_halfheight;
end;