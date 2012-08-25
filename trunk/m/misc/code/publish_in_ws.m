%> @file
%>@ingroup code
%> @brief "Publishes" data into the 'base' workspace under given name.
%
%> @param data Any variable.
%> @param name Name the variable will have.
function publish_in_ws(data, name)
global T;
T = data;
evalin('base', ['global T; ' name ' = T;']);
clear global T;
