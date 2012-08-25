%>@file
%>@ingroup graphicsapi ioio
%>@brief Saves current legend as PNG
%>
%> This function will save a PNG with the legend, but will mess with the positioning on the screen
%>
%> May not work well if the window is maximized
%
%> @param fn =(new) File name
%> @param dpi =0 Dots Per Inch = resolution. 0 = screen resolution
function fn = save_legend(fn, dpi)
fig_assert();

if nargin < 1 || isempty(fn)
    fn = find_filename('figure', [], 'png');
end;
if nargin < 2 || isempty(dpi)
    dpi = 0;
end;

psavef = get(gcf, 'Position');
psavea = get(gca, 'Position');

hl = legend();
psavel = get(hl, 'Position');
usavel = get(hl, 'Units');

show_legend_only();

save_as_png(gcf(), fn, dpi);

% Restoration
set(hl, 'Units', usavel);
set(hl, 'Position', psavel);

set(gca, 'Position', psavea);
set(gcf, 'Position', psavef);


