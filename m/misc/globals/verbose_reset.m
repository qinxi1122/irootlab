%> @ingroup globals usercomm
%> @file
%> @ingroup log
%> @brief Resets the output log filename
function verbose_reset()
verbose_assert();
global VERBOSE;
VERBOSE.filename = '';

