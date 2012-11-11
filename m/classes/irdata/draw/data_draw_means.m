%>@ingroup datasettools
%>@file
%>@brief Draws class means

function data = data_draw_means(data)

cm = classes2colormap(data.classes, 1);

ucl = unique(data.classes);

hs = [];

ymin = Inf;
ymax = -Inf;
for i = 1:numel(ucl)
    ytemp = mean(data.X(data.classes == ucl(i), :), 1);
    ymin = min([ymin, ytemp]);
    ymax = max([ymax, ytemp]);
    htemp = plot_curve_pieces(data.fea_x, ytemp, 'Color', cm(i, :), 'LineWidth', scaled(3));
    hs(end+1) = htemp{1};
    hold on;
end;
legend(hs, data_get_legend(data));

set_title('Class means', data);
ylabel([data.yname, iif(~isempty(data.yunit), sprintf(' (%s)', data.yunit), '')]);
format_xaxis(data);
format_ylim([ymin, ymax]);
format_frank();
