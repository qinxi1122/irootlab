%>@ingroup graphicsapi
%> @file
%> @brief Draws image map
%
%> @param Y
%> @param height
function draw_image(Y, height)


width = numel(Y)/height;
if width ~= floor(width)
    irerror(sprintf('Invalid height: number of image points not divisible by specified height: %d', height));
end;


cc = colormap();
ncolors = size(cc, 1);

nanana = isnan(Y);
Ytemp = Y(~nanana);
Ytemp = Ytemp(:);
mi = min(Ytemp);
ma = max(Ytemp);

Y(nanana) = 0;
Y(~nanana) = 1+(ncolors-1)*(Y(~nanana)-mi)/(ma-mi);


imagesc(reshape(Y, height, width));

colormap([0, 0, 0; cc]);


shading flat;

axis image;
axis off;
set(gca, 'XDir', 'normal', 'YDir', 'normal');
set(gca, 'XLim', [1, width], 'YLim', [1, height]);
format_frank();

