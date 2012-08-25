%> @ingroup guigroup
%> @file uip_as_fsel_grades_fsg.m
%> @brief Properties Window for @ref as_fsel_grades_fsg
%>
%> @sa as_fsel_grades

%> @cond
function out = uip_as_fsel_grades_fsg(varargin)

varargin{3} = 1; % flag_needs_fsg
out = uip_as_fsel_grades(varargin{:});
%> @endcond