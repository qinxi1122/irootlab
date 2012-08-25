%> @brief Shortcut for setting a raxisdata object
%>
%>
function o = raxisdata_unit(label, short, values)
o = raxisdata();
o.label = label;
o.values = values;
o.legends = arrayfun(@(x) sprintf('%s=%d', short, x), values, 'UniformOutput', 0);
