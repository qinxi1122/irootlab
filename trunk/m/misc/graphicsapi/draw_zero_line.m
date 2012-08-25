%>@ingroup graphicsapi
%>@file
%>@brief Draws zero line
%
%> @param x
%> @param width
function draw_zero_line(x, width)

if ~exist('width', 'var')
    width = 2;
end;

len = length(x);
z = zeros(1, len);
plot(x, z, 'k', 'LineWidth', width);
