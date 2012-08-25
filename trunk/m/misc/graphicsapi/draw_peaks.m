%>@ingroup graphicsapi
%> @file
%> @brief Draws peaks
%
%> @param x
%> @param y
%> @param indexes
%> @param flag_text
function draw_peaks(x, y, indexes, flag_text)
global SCALE FONTSIZE FONT;

if ~exist('flag_text', 'var')
    flag_text = 1;
end;

scale = max(abs(y));
offset = 0.025*scale;

y(y == Inf) = max(y(y ~= Inf));

x_peaks = x(indexes);
y_peaks = y(indexes);


for i = 1:length(x_peaks)
    plot(x_peaks(i), y_peaks(i), 'kx', 'MarkerSize', 10*SCALE, 'LineWidth', 3*SCALE);
    hold on;
    offset = 0.025*scale;
    if y_peaks(i) < 0
        offset = -offset;
    end;
    
    if flag_text
        text(x_peaks(i), y_peaks(i)+offset, sprintf('%.0f', x(indexes(i))), 'FontName', FONT, 'FontSize', FONTSIZE*SCALE*.75);
    end;
end;
