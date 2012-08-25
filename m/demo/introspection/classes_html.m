%> @ingroup demo introspection
%> @brief Generates HTML with class tree
%> @file

classmap_assert;
global CLASSMAP;

s = stylesheet();
s = cat(2, s, CLASSMAP.root.to_html());

filename = 'classes.html';
h = fopen(filename, 'w');
fwrite(h, s);
fclose(h);

web(filename, '-new');
