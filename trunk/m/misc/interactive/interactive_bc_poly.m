%>@ingroup interactive
%>@file
%>@brief Helps find polynomial order for polynomial-fit baseline correction

varname = input('Enter dataset variable name: ', 's');

dataset = eval([varname ';']);
no = size(dataset.X, 1);


idx = input(sprintf('Enter index of spectrum to use (between 1 and %d): ', no));

dataset = data_map_rows(dataset, idx);


order = 5;
epsilon = 0;

k = 1;
while 1
    order_ = input(sprintf('Enter polynomial order [%d]: ', order));
    if ~isempty(order_)
        order = order_;
    end;

%     epsilon_ = input(sprintf('Enter epsilon [%g]: ', epsilon));
%     if ~isempty(epsilon_)
%         epsilon = epsilon_;
%     end;

    dataset2 = data_bc_poly(dataset, order, epsilon);
    
    if k == 1
        figure;
    end;
    k = k+1;
    hold off;
    plot(dataset.x, dataset.X, 'r', 'LineWidth', 2);
    hold on;
    plot(dataset.x, dataset2.X, 'b', 'LineWidth', 2);
    plot(dataset.x, dataset.X-dataset2.X, 'k', 'LineWidth', 2);
    legend({'Before', 'After', 'Baseline'});
    format_xaxis(dataset);
    format_frank();
    
%     s_happy = input(sprintf('Are you happy with order = %d and epsilon = %g [y/N]? ', order, epsilon), 's');
    s_happy = input(sprintf('Are you happy with order = %d [y/N]? ', order, epsilon), 's');
    if ~isempty(intersect({s_happy}, {'y', 'Y'}))
        break;
    end;
end;


