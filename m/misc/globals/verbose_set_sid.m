%> @ingroup globals usercomm
%> @file
%> @brief Asserts the @c VERBOSE global is present and initialized.
function verbose_set_sid(s)
verbose_assert();
global VERBOSE;
VERBOSE.sid = s;

