%> @ingroup globals usercomm
%> @file
%> @brief Asserts the @c VERBOSE global is present and initialized.
function verbose_assert()
global VERBOSE;
if isempty(VERBOSE) || isempty(VERBOSE)
    VERBOSE.minlevel = 0; % Minimum level for output
    VERBOSE.flag_file = 0; % Whether to output to file as well as to screen
    VERBOSE.filename = '';
    VERBOSE.sid = '';
end;
