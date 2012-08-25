%> @ingroup globals code
%> @file
%> @brief Asserts the @c IRCODE global is present and initialized.
function list = ircode_assert()
global IRCODE;
if isempty(IRCODE) || isempty(IRCODE.s)
    IRCODE.s = {};
    IRCODE.filename = '';
    ircode_eval2('', ['IRoot started @ ' datestr(now)]);
end;
