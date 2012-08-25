%> @ingroup globals code
%>@file
%>@brief Opens the running IRoot auto-generated code in MATLAB editor
function ircode_edit()
ircode_assert();
global IRCODE;
edit(IRCODE.filename);

