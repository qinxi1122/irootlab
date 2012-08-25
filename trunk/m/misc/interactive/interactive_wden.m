%>@ingroup interactive
%>@file
%>@brief Helps find thresholds for wavelet de-noising

varname = input('Enter dataset variable name: ', 's');

dataset = eval([varname ';']);
no = size(dataset.X, 1);


idx = input(sprintf('Enter index of spectrum to use (between 1 and %d): ', no));

dataset = data_map_rows(dataset, idx);


thresholds = [0, 0, 0, 1000, 1000, 1000];
no_levels = 6;

k = 1;
while 1
    no_levels_ = input(sprintf('Enter no_levels [%g]: ', no_levels));
    if ~isempty(no_levels_)
        no_levels = no_levels_;
    end;

    thresholds_ = input(sprintf('Enter thresholds [%s]: ', mat2str(thresholds)));
    if ~isempty(thresholds_)
        thresholds = thresholds_;
    end;


    dataset2 = data_wden(dataset, no_levels, thresholds, 'haar');
    
    if k == 1
        figure;
    end;
    k = k+1;
    hold off;
    plot(dataset.x, dataset.X, 'r', 'LineWidth', 2);
    hold on;
    plot(dataset.x, dataset2.X, 'b', 'LineWidth', 2);
    plot(dataset.x, dataset.X-dataset2.X, 'k', 'LineWidth', 2);
    legend({'Before', 'After', 'Difference'});
    format_xaxis(dataset);
    format_frank();
    
%     s_happy = input(sprintf('Are you happy with thresholds = %d and no_levels = %g [y/N]? ', thresholds, no_levels), 's');
    s_happy = input(sprintf('Are you happy [y/N]? '), 's');
    if ~isempty(intersect({s_happy}, {'y', 'Y'}))
        break;
    end;
end;


