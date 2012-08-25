%>@ingroup graphicsapi
%>@file
%>@brief plot_reconst
%
%> @param data1
%> @param data2
%> @param idxs
function plot_reconst(data1, data2, idxs)

no_idxs = length(idxs);

[r, c] = rows_cols(no_idxs, 3/5);

for i = 1:no_idxs
    subplot(r, c, i);
    plot(data1.X(idxs(i), :), 'r', 'LineWidth', 1);
    hold on;
    plot(data2.X(idxs(i), :), 'k', 'LineWidth', 1);
end;
