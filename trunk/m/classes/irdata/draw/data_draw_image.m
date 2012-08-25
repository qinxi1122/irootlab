%>@ingroup datasettools
%> @file
%> @brief Draws image map

%> @param data
%> @param mode
%> @param idx_fea
%> @param flag_set_position =1 If 1, will call <code>set(gca, 'Position', [0, 0, 1, 1]);</code>
function data_draw_image(data, mode, idx_fea, flag_set_position)


if ~exist('flag_set_position', 'var') || isempty(flag_set_position)
    flag_set_position = 1;
end;
    

if mode == 0
    x = data.X(:, idx_fea);
elseif mode == 1
    x = data.classes;
elseif mode == 2
    x = data.Y(:, 1);
end;

% [Q1, Q2] = meshgrid(1:data.width, 1:data.height);
% o = pcolor(Q1, Q2, reshape(x, data.height, data.width));
o = imagesc(reshape(x, data.height, data.width));

if mode == 1
    cm = classes2colormap(x);
    colormap(cm);
else
    colormap('default');
end;
shading flat;
%     alpha(o, 0.4);

axis image;
axis off;

if flag_set_position
    set(gca, 'Position', [0, 0, 1, 1]);
end;



%------------------------------------------------------
function y = col2colors(x)
y = x;


%------------------------------------------------------
function cm = classes2colormap(classes)

cm = []; % colormap
if sum(classes == -2)
    cm = [cm; 0, 0, 0]; % Filtered out points in black
end;
if sum(classes == -1)
    cm = [cm; .5, .5, .5]; % Rejected points in gray
end;

for i = 1:max(classes(:))+1
    cm = [cm; rgb(find_color(i+1))];
end;

