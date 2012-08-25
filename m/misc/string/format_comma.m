%>@ingroup string graphicsapi
%>@file
%>@brief format_comma
%>@todo There is another similar function
function format_comma(ax, flag_y)

if ~exist('ax')
    ax = gca();
end;

if ~exist('flag_y')
    flag_y = 0;
end;

a = {'XTick'};
if flag_y
    a{end+1} = 'YTick';
end;

for i = 1:length(a)
    numbers = get(ax, a{i});
    labels = cell(1, length(numbers));
    for j = 1:length(numbers)
        labels{j} = format_number_with_commas(numbers(j));
    end;
  set(ax, [a{i} 'Label'], labels);
end  
  

