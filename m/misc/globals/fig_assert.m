%>@ingroup graphicsapi globals idata
%>@file
%>@brief Default colors, styles, fonts globals
%>
%> This is the list of the global variables that are initialized here:
%> <ul>
%>   <li>@c COLORS: Sequence of colors for general purpose.
%>   <li>@c FONT: Font for figure axis labels, legend, title etc.
%>   <li>@c FONTSIZE: Font size for figure axis labels, legend, title etc.
%>   <li>@c MARKERS: Sequence of markers for scatterplots etc.
%>   <li>@c MARKERSIZES: Sequence of marker sizes. Must match @c MARKERS in number of elements.
%>   <li>@c LINESTYLES: Sequence of line styles.
%>   <li>@c SCALE: Multiplier for @c MARKERSIZES, @c FONTSIZE and line widths. See example below.
%> </ul>
%>
%> @todo GUI to set this up! May be with axes where the user can click
function fig_assert()
global COLORS MARKERS MARKERSIZES FONT FONTSIZE LINESTYLES SCALE COLORS_STACKEDHIST;

if isempty(COLORS)
    a = [...
        228, 26, 28; ...
        55, 126, 184; ...
        77, 175, 74; ...
        152, 78, 163; ...
        255, 127, 0; ...
        255, 255, 51; ...
        166, 86, 40; ...
        247, 129, 191; ...
        153, 153, 153; ...
        ];
    a = round(a/255*1000)/1000;
    COLORS = mat2cell(a, ones(1, size(a, 1)), 3);

% % Old
%     COLORS = {[1, 0, 0], 
%               [0, 0, 1], 
%               [0, .7, 0], 
%               [1, 0, 1],
%               [1, .5, 0], 
%               [0, 0, 0],
%               [.9, .9, 0], 
%               [.67, 0, 0], 
%               [0, 0, .67],
%               [0, 1, 1],
%               [0, .67, 0],
%               [.67, .67, 0],
%               [0, .67, .67],
%               [.67, 0, .67]
%     };

    LINESTYLES = {'-', '--', '-.'};


    MARKERS = 'so^dvp<h>';
    MARKERSIZES = 2*[3 3 3 3 3 3 3 3 3];


    FONT = 'Arial';
    % FONTSIZE = 40; % Becomes aprox. 16.5 when a 300dpi PNG is exported and made 18cm wide in Word. 
    %                % PS: I think it goes well on my 1650x... monitor but a different screen size would need another FONTSIZE
    %                % to achieve the same effect (i.e. font size of 16.5 in Word)
    %                % This is good provision for potential reduction when the figure goes to the paper

    FONTSIZE = 20;



    SCALE = 1;
    
    COLORS_STACKEDHIST = make_colors_stackedhist();
end;


%---------------------------------
function c = make_colors_stackedhist()
% This is the colormap that was used for the stacked histograms

cm = jet(20);
cm = cm(19:-2:1, :);
f = (cos(linspace(0, 2*pi, 10))*.1+1)';
cm = bsxfun(@times, cm, f);
cm = cm/max(cm(:));
cm = round(cm*1000)/1000;

c = mat2cell(cm, ones(1, 10), 3);
