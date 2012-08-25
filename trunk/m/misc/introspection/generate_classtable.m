%>@file
%>@ingroup introspection
%>@brief Creates a CSV file with a list of classes, similar to what is seen in blockmenu.m
aa = {'block', 'sgs', 'peakdetector', 'fsg', 'irlog'};

cc = {};
for i = 1:numel(aa)
    l = classmap_get_list(aa{i});
    cc = [cc; itemlist2cell(l, 0, 1)];
end;
h = fopen('classtable.txt', 'w');
fwrite(h, csv_from_cell(cc));
fclose(h);
