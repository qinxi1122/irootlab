%>@ingroup datasettools
%>@file
%>@brief Draws "all curves in dataset"
function data = data_draw(data)

pieces = data_split_classes(data);
h = [];
llabels = {};
for i = 1:length(pieces)
    if pieces(i).no > 0
        eh = zeros(1, size(pieces(i).X, 2));
        h_temp = plot(data.fea_x, pieces(i).X', 'Color', find_color(i));
        h(end+1) = h_temp(1);
        llabels{end+1} = data.classlabels{i};
        hold on;
    end;
end;
legend(h, llabels);

alpha(0);


set_title('All curves', data);
format_xaxis(data);
ylabel([data.yname, iif(~isempty(data.yunit), sprintf(' (%s)', data.yunit), '')]);
format_frank();
