%> @ingroup misc graphicsapi
%> @brief Maximizes figure on screen
%> @file
%>
%> Has a workaround to prevent figure from occupying two monitors, which
%> consists of dividing the width by two if the width-to-height ratio is
%> greater than 2.
%
%> @param h =gcf() Handle to figure.
%> @param aspectratio (Optional). If used, will force the aspect ratio to be as specified, making the image as big as possible. Aspect ratio is 
%> defined as the image width divided by its height.
function maximize_window(h, aspectratio)
if nargin < 1 || isempty(h)
    h = gcf();
end;

p = get(0,'Screensize'); % p(3) is width, and p(4) is height
p(3:4) = floor(p(3:4)*.99);

if p(3)/p(4) > 1.9
    % Likely to be picking the full double monitor screen size
    p(3) = floor(p(3)/2);
end;

if nargin >= 2 && ~isempty(aspectratio)
    ar_original = p(3)/p(4);
    arar = aspectratio/ar_original;
    
    if arar < 1
        p(3) = p(3)*arar;
    elseif arar > 1
        p(4) = p(4)/arar;
    end;
end;


figure(h);
set(h, 'Position', p);


